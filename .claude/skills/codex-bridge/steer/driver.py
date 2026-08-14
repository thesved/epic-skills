#!/usr/bin/env python3
"""codex-steer driver: owns one `codex app-server` child and a FIFO control channel,
so an orchestrator can message a RUNNING delegated GPT run (turn/steer), queue
follow-up turns on the same thread, interrupt, or stop - like SendMessage for codex.

Agent dir layout (~/.codex-steer/<name>/):
  prompt.md    initial task, read once at start (empty file = start idle)
  cmd.fifo     control channel: one JSON object per line
  state.json   {status, thread_id, live_turn_id, ...} atomically rewritten
  events.jsonl filtered protocol log (delta/noise methods dropped)
  out.md       human transcript: agent messages, commands, turn boundaries
  driver.log   driver diagnostics

FIFO commands:
  {"cmd":"msg","text":"..."}                steer live turn; no live turn -> new turn
  {"cmd":"img","path":"/abs.png","text":"..."}  same, with a localImage attached
  {"cmd":"interrupt"}                       abort the live turn (thread survives)
  {"cmd":"stop"}                            terminate app-server and exit

Statuses: starting -> idle/running -> ... -> stopped | dead (app-server exited).
Protocol is experimental (schema drifts per codex version): on breakage regenerate
with `codex app-server generate-json-schema --out <dir>` and diff.
"""
import argparse, json, os, queue, signal, subprocess, sys, threading, time

# Detach into our own session so launchd/session death can't take the agent down
# (macOS has no setsid(1); see chrome skill's launch.sh for the process-group trap).
try:
    os.setsid()
except OSError:
    pass

NOISE = {
    "item/agentMessage/delta", "item/reasoning/delta", "turn/diff/updated",
    "thread/tokenUsage/updated", "account/rateLimits/updated",
    "mcpServer/startupStatus/updated", "remoteControl/status/changed",
}

ap = argparse.ArgumentParser()
ap.add_argument("--dir", required=True)
ap.add_argument("--workdir", required=True)
ap.add_argument("--model", default="gpt-5.6-sol")
ap.add_argument("--sandbox", default="workspace-write")
ap.add_argument("--approval", default="never")
A = ap.parse_args()
D = os.path.abspath(A.dir)

log_f = open(os.path.join(D, "driver.log"), "a", buffering=1)
ev_f = open(os.path.join(D, "events.jsonl"), "a", buffering=1)
out_f = open(os.path.join(D, "out.md"), "a", buffering=1)

def dlog(msg):
    log_f.write(f"[{time.strftime('%H:%M:%S')}] {msg}\n")

state = {
    "name": os.path.basename(D), "status": "starting", "thread_id": None,
    "live_turn_id": None, "driver_pid": os.getpid(), "appserver_pid": None,
    "model": A.model, "workdir": A.workdir, "sandbox": A.sandbox,
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%S"), "updated_at": None,
    "turns_completed": 0, "last_error": None,
}
state_lock = threading.Lock()

def write_state(**kw):
    with state_lock:
        state.update(kw)
        state["updated_at"] = time.strftime("%Y-%m-%dT%H:%M:%S")
        tmp = os.path.join(D, ".state.tmp")
        with open(tmp, "w") as f:
            json.dump(state, f, indent=1)
        os.replace(tmp, os.path.join(D, "state.json"))

proc = subprocess.Popen(
    ["codex", "app-server"],
    stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL,
    text=True, bufsize=1,
)
write_state(appserver_pid=proc.pid)

pending = {}
ids = iter(range(1, 10**6))
initial_prompt = ""

def send(msg):
    proc.stdin.write(json.dumps(msg) + "\n")
    proc.stdin.flush()

def request(method, params=None, timeout=120):
    i = next(ids)
    q = queue.Queue(maxsize=1)
    pending[i] = q
    send({"id": i, "method": method, "params": params or {}})
    msg = q.get(timeout=timeout)
    if "error" in msg:
        raise RuntimeError(f"{method} -> {msg['error']}")
    return msg.get("result", {})

def note(md_line):
    out_f.write(md_line + "\n")

def on_notification(msg):
    m = msg.get("method")
    p = msg.get("params", {})
    if m not in NOISE:
        ev_f.write(json.dumps(msg) + "\n")
    item = p.get("item", {})
    if m == "turn/started":
        write_state(live_turn_id=p.get("turn", {}).get("id"), status="running")
    elif m in ("turn/completed", "turn/failed"):
        st = p.get("turn", {}).get("status")
        note(f"\n-- turn done: {json.dumps(st)} [{time.strftime('%H:%M:%S')}] --\n")
        write_state(live_turn_id=None, status="idle",
                    turns_completed=state["turns_completed"] + 1,
                    last_error=None if m == "turn/completed" else json.dumps(p)[:500])
    elif m == "item/completed" and item.get("type") == "agentMessage":
        note(f"### agent [{time.strftime('%H:%M:%S')}]\n{item.get('text', '')}")
    elif m == "item/completed" and item.get("type") == "userMessage":
        txt = " ".join(c.get("text", "") for c in item.get("content", []))
        if txt.strip() != initial_prompt:  # the task itself is already logged
            note(f"### injected [{time.strftime('%H:%M:%S')}]\n{txt}")
    elif m == "item/started" and item.get("type") == "commandExecution":
        note(f"- $ {item.get('command', '')}")

def reader():
    for line in proc.stdout:
        line = line.strip()
        if not line:
            continue
        try:
            msg = json.loads(line)
        except json.JSONDecodeError:
            continue
        if "id" in msg and "method" not in msg:
            ev_f.write(json.dumps(msg) + "\n")
            q = pending.pop(msg["id"], None)
            if q:
                q.put(msg)
        elif "method" in msg:
            try:
                on_notification(msg)
            except Exception as e:  # never let a bad event kill the stream
                dlog(f"notification handler error: {e}")

threading.Thread(target=reader, daemon=True).start()

cmds = queue.Queue()

def fifo_reader():
    path = os.path.join(D, "cmd.fifo")
    while True:
        try:
            with open(path) as f:  # blocks until a writer connects
                for line in f:
                    line = line.strip()
                    if line:
                        try:
                            cmds.put(json.loads(line))
                        except json.JSONDecodeError:
                            dlog(f"bad fifo line: {line[:200]}")
        except Exception as e:
            dlog(f"fifo error: {e}")
            time.sleep(1)

threading.Thread(target=fifo_reader, daemon=True).start()

# handshake + thread + optional initial turn
try:
    request("initialize", {
        "clientInfo": {"name": "codex-steer", "title": "codex-steer", "version": "1.0.0"},
        "capabilities": {"experimentalApi": True},
    })
    send({"method": "initialized", "params": {}})
    th = request("thread/start", {
        "cwd": A.workdir, "model": A.model,
        "approvalPolicy": A.approval, "sandbox": A.sandbox,
    })
    tid = th["thread"]["id"]
    write_state(thread_id=tid, status="idle")
    dlog(f"thread {tid}")
    prompt_path = os.path.join(D, "prompt.md")
    prompt = open(prompt_path).read().strip() if os.path.exists(prompt_path) else ""
    initial_prompt = prompt
    if prompt:
        write_state(status="running")
        tr = request("turn/start", {"threadId": tid, "input": [{"type": "text", "text": prompt}]})
        write_state(live_turn_id=tr["turn"]["id"])
        note(f"### task [{time.strftime('%H:%M:%S')}]\n{prompt}")
except Exception as e:
    dlog(f"startup failed: {e}")
    write_state(status="dead", last_error=str(e))
    proc.terminate()
    sys.exit(1)

def start_turn(inp):
    write_state(status="running")
    tr = request("turn/start", {"threadId": state["thread_id"], "input": inp})
    write_state(live_turn_id=tr["turn"]["id"])

def deliver(inp, label):
    """Steer the live turn; if none (or it just ended), start a new turn."""
    live = state["live_turn_id"]
    if live:
        try:
            request("turn/steer", {"threadId": state["thread_id"],
                                   "expectedTurnId": live, "input": inp})
            dlog(f"{label}: steered into live turn {live}")
            return "steered"
        except RuntimeError as e:  # turn ended between check and call
            dlog(f"{label}: steer failed ({e}); falling back to turn/start")
    start_turn(inp)
    dlog(f"{label}: started new turn")
    return "new-turn"

stop = False
while not stop:
    if proc.poll() is not None:
        dlog("app-server exited")
        write_state(status="dead", last_error="app-server exited")
        break
    try:
        c = cmds.get(timeout=1)
    except queue.Empty:
        continue
    try:
        kind = c.get("cmd")
        if kind == "msg":
            deliver([{"type": "text", "text": c.get("text", "")}], "msg")
        elif kind == "img":
            inp = [{"type": "localImage", "path": c.get("path", "")}]
            if c.get("text"):
                inp.append({"type": "text", "text": c["text"]})
            deliver(inp, "img")
        elif kind == "interrupt":
            live = state["live_turn_id"]
            if live:
                request("turn/interrupt", {"threadId": state["thread_id"], "turnId": live})
                dlog(f"interrupted turn {live}")
            else:
                dlog("interrupt: no live turn")
        elif kind == "stop":
            stop = True
        else:
            dlog(f"unknown cmd: {c}")
    except Exception as e:
        dlog(f"cmd {c} failed: {e}")
        write_state(last_error=str(e))

if stop:
    proc.terminate()
    try:
        proc.wait(timeout=10)
    except subprocess.TimeoutExpired:
        proc.kill()
    write_state(status="stopped", live_turn_id=None)
    dlog("stopped")
