#!/usr/bin/env python3
"""Minimal identical agent harness over OpenRouter chat completions: tools read_file, write_file, list_files, run_shell (cwd-jailed, 60 s timeout).
Usage: miniagent.py --seats "name:model:effort,..." [--runs 1] [--workers 4] [--max-turns 40]. Same repo task as run_agentic.py; results -> results_miniagent.jsonl"""
import argparse, json, os, shutil, subprocess, sys, time, hashlib, re, urllib.request, concurrent.futures as cf
HERE = os.path.dirname(os.path.abspath(__file__)); TPL = os.path.join(HERE, "template"); RUNS = os.path.join(HERE, "runs_mini")
KEY = subprocess.run(["bash", "-c", "source ~/.claude/skills/_model-cache/lib.sh; resolve_key OPENROUTER_API_KEY"], capture_output=True, text=True).stdout.strip()
TASK = open(os.path.join(HERE, "run_agentic.py")).read().split('TASK = """')[1].split('"""')[0]
SYSTEM = "You are an autonomous coding agent working inside a repository. Use the tools to inspect and edit files and to run commands. Work until the goal is verified by running the tests yourself. Do not ask questions; there is no user to answer. When finished, reply with a short summary."
TOOLS = [
 {"type": "function", "function": {"name": "list_files", "description": "List files recursively (relative paths)", "parameters": {"type": "object", "properties": {}, "required": []}}},
 {"type": "function", "function": {"name": "read_file", "description": "Read a UTF-8 text file", "parameters": {"type": "object", "properties": {"path": {"type": "string"}}, "required": ["path"]}}},
 {"type": "function", "function": {"name": "write_file", "description": "Create or overwrite a text file with the full new content", "parameters": {"type": "object", "properties": {"path": {"type": "string"}, "content": {"type": "string"}}, "required": ["path", "content"]}}},
 {"type": "function", "function": {"name": "run_shell", "description": "Run a shell command in the repo root (60 s timeout); returns stdout+stderr and exit code", "parameters": {"type": "object", "properties": {"command": {"type": "string"}}, "required": ["command"]}}}]
FIXED = {"z-ai/glm-5.3-flash": {"provider": {"order": ["Baseten"], "allow_fallbacks": True}}}

def safe(root, p):
    full = os.path.realpath(os.path.join(root, p))
    if not full.startswith(os.path.realpath(root) + os.sep) and full != os.path.realpath(root): raise ValueError("path escapes repo")
    return full

def tool_impl(root, name, args):
    try:
        if name == "list_files":
            out = []
            for dp, dn, fn in os.walk(root):
                dn[:] = [x for x in dn if x not in (".git", "__pycache__")]
                for f in fn: out.append(os.path.relpath(os.path.join(dp, f), root))
            return "\n".join(sorted(out))
        if name == "read_file": return open(safe(root, args["path"]), encoding="utf-8").read()[:60000]
        if name == "write_file":
            p = safe(root, args["path"]); os.makedirs(os.path.dirname(p), exist_ok=True); open(p, "w", encoding="utf-8").write(args["content"]); return f"wrote {len(args['content'])} chars to {args['path']}"
        if name == "run_shell":
            r = subprocess.run(["bash", "-c", args["command"]], cwd=root, capture_output=True, text=True, timeout=60)
            return (r.stdout + r.stderr)[-8000:] + f"\n[exit {r.returncode}]"
    except subprocess.TimeoutExpired: return "[timeout after 60 s]"
    except Exception as e: return f"[tool error] {e!r}"
    return "[unknown tool]"

def call(body):
    req = urllib.request.Request("https://openrouter.ai/api/v1/chat/completions", data=json.dumps(body).encode(), headers={"Authorization": f"Bearer {KEY}", "content-type": "application/json", "X-Title": "muse-agentic-bakeoff"})
    try:
        with urllib.request.urlopen(req, timeout=900) as r: return json.loads(r.read())
    except urllib.error.HTTPError as e:
        try: return json.loads(e.read())
        except Exception: return {"error": {"message": str(e)}}
    except Exception as e: return {"error": {"message": repr(e)}}

def run_seat(name, model, effort, run_idx, max_turns):
    d = os.path.join(RUNS, f"{name}__{effort}__{run_idx}"); shutil.rmtree(d, ignore_errors=True); shutil.copytree(TPL, d)
    tsha = hashlib.sha256(open(os.path.join(d, "tests/test_core.py"), "rb").read()).hexdigest()
    msgs = [{"role": "system", "content": SYSTEM}, {"role": "user", "content": TASK}]
    tot = dict(in_tok=0, out_tok=0, reason_tok=0, cost=0.0, turns=0, tool_calls=0, shell=0, writes=0); log = []; t0 = time.time(); err = None; final = ""
    for turn in range(max_turns):
        body = {"model": model, "messages": msgs, "tools": TOOLS, "usage": {"include": True}}; body.update(FIXED.get(model, {}))
        if effort != "default": body["reasoning"] = {"effort": effort}
        d0 = call(body); tot["turns"] += 1
        if "error" in d0:
            err = json.dumps(d0["error"])[:300]; log.append({"error": err})
            if "429" in err or "503" in err or "502" in err: time.sleep(10); continue
            break
        u = d0.get("usage") or {}; tot["in_tok"] += u.get("prompt_tokens", 0) or 0; tot["out_tok"] += u.get("completion_tokens", 0) or 0; tot["reason_tok"] += (u.get("completion_tokens_details") or {}).get("reasoning_tokens", 0) or 0; tot["cost"] += u.get("cost", 0) or 0
        m = d0["choices"][0]["message"]; tcs = m.get("tool_calls") or []
        am = {"role": "assistant", "content": m.get("content")}
        if tcs: am["tool_calls"] = tcs
        if m.get("reasoning"): am["reasoning"] = m["reasoning"]
        if m.get("reasoning_details"): am["reasoning_details"] = m["reasoning_details"]
        msgs.append(am)
        if not tcs: final = m.get("content") or ""; log.append({"final": final[:500]}); break
        for tc in tcs:
            fn = tc["function"]["name"]
            try: args = json.loads(tc["function"].get("arguments") or "{}")
            except Exception: args = {}
            res = tool_impl(d, fn, args); tot["tool_calls"] += 1; tot["shell"] += fn == "run_shell"; tot["writes"] += fn == "write_file"
            log.append({"tool": fn, "args": {k: (v[:200] if isinstance(v, str) else v) for k, v in args.items()}, "result": res[:300]})
            msgs.append({"role": "tool", "tool_call_id": tc["id"], "content": res})
    wall = time.time() - t0
    tests_ok = os.path.exists(os.path.join(d, "tests/test_core.py")) and hashlib.sha256(open(os.path.join(d, "tests/test_core.py"), "rb").read()).hexdigest() == tsha
    r = subprocess.run([sys.executable, "-m", "unittest", "discover", "-s", "tests"], cwd=d, capture_output=True, text=True, timeout=60)
    mm = re.search(r"Ran (\d+) tests", r.stderr); n = int(mm.group(1)) if mm else 0; fails = len(re.findall(r"^(FAIL|ERROR):", r.stderr, re.M)); passed = n - fails if n else 0
    json.dump(log, open(os.path.join(d, "trace.json"), "w"), indent=1)
    rec = dict(ts=time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()), harness="miniagent", seat=name, model=model, effort=effort, run=run_idx, wall_s=round(wall, 1), passed=passed, total=n, tests_unmodified=tests_ok, **{k: (round(v, 4) if isinstance(v, float) else v) for k, v in tot.items()}, error=err, final=final[:300])
    with open(os.path.join(HERE, "results_miniagent.jsonl"), "a") as f: f.write(json.dumps(rec) + "\n")
    print(f"{name:10s} {effort:8s} pass={passed}/{n} tests_ok={tests_ok} {wall:.0f}s turns={tot['turns']} tools={tot['tool_calls']} sh={tot['shell']} w={tot['writes']} in={tot['in_tok']} out={tot['out_tok']} r={tot['reason_tok']} ${tot['cost']:.3f} err={err}", flush=True)
    return rec

if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("--seats", required=True); ap.add_argument("--runs", type=int, default=1); ap.add_argument("--workers", type=int, default=4); ap.add_argument("--max-turns", type=int, default=40)
    a = ap.parse_args(); seats = [s.split(":") for s in a.seats.split(",")]
    jobs = [(n, m, e, r, a.max_turns) for r in range(a.runs) for n, m, e in seats]
    with cf.ThreadPoolExecutor(a.workers) as ex: list(ex.map(lambda j: run_seat(*j), jobs))
