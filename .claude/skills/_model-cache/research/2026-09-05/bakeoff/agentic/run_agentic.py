#!/usr/bin/env python3
"""Agentic repo bakeoff through the Codex CLI harness. Each model gets a fresh copy of template/, must make the unit tests pass without editing tests.
Usage: run_agentic.py --seats "spark13:openrouter:meta/muse-spark-1.3:default,astra:native:gpt-6-astra:high,..." [--runs 1] [--workers 3]
Records: pass count, tests-unmodified check, wall, tokens, turns/tool calls (from --json events)."""
import argparse, json, os, shutil, subprocess, sys, time, hashlib, tempfile, concurrent.futures as cf
HERE = os.path.dirname(os.path.abspath(__file__)); TPL = os.path.join(HERE, "template"); RUNS = os.path.join(HERE, "runs")
TASK = """You are working in a small Python repository (see README.md for the spec). The unit tests in tests/ are the contract and currently fail.
Goal: make `python3 -m unittest discover -s tests -v` pass completely.
Rules: do not modify or delete anything under tests/; keep the public API names; fix root causes, do not special-case the tests; no new dependencies; do not commit. When the suite passes, print the final test summary line and stop."""
KEY = subprocess.run(["bash", "-c", "source ~/.claude/skills/_model-cache/lib.sh; resolve_key OPENROUTER_API_KEY"], capture_output=True, text=True).stdout.strip()

def sha(p):
    return hashlib.sha256(open(p, "rb").read()).hexdigest()

def run_seat(name, provider, model, effort, run_idx):
    d = os.path.join(RUNS, f"{name}__{effort}__{run_idx}"); shutil.rmtree(d, ignore_errors=True); shutil.copytree(TPL, d)
    subprocess.run(["git", "init", "-q"], cwd=d); subprocess.run(["git", "add", "-A"], cwd=d); subprocess.run(["git", "-c", "user.email=a@b", "-c", "user.name=a", "commit", "-qm", "init"], cwd=d)
    tsha = sha(os.path.join(d, "tests", "test_core.py"))
    args = ["codex", "exec", "--json", "-m", model, "-s", "workspace-write", "-C", d, "-o", os.path.join(d, "FINAL.md")]
    if effort != "default": args += ["-c", f"model_reasoning_effort={effort}"]
    env = dict(os.environ)
    if provider == "openrouter":
        env["OPENROUTER_API_KEY"] = KEY
        args += ["-c", 'model_providers.openrouter.name="OpenRouter"', "-c", 'model_providers.openrouter.base_url="https://openrouter.ai/api/v1"', "-c", 'model_providers.openrouter.env_key="OPENROUTER_API_KEY"', "-c", 'model_providers.openrouter.wire_api="chat"', "-c", "model_provider=openrouter"]
    t0 = time.time()
    try:
        p = subprocess.run(args, input=TASK, capture_output=True, text=True, timeout=2400, env=env)
        timeout = False
    except subprocess.TimeoutExpired as e:
        p = e; timeout = True
    wall = time.time() - t0
    out = (p.stdout if isinstance(p.stdout, str) else (p.stdout or b"").decode()) if not timeout else (e.stdout or b"").decode() if isinstance(e.stdout, bytes) else (e.stdout or "")
    open(os.path.join(d, "events.jsonl"), "w").write(out)
    usage = None; cmds = 0; errs = []
    for line in out.splitlines():
        try: ev = json.loads(line)
        except Exception: continue
        t = ev.get("type", "")
        if t == "turn.completed": usage = ev.get("usage")
        if t == "item.completed" and (ev.get("item") or {}).get("type") == "command_execution": cmds += 1
        if t == "error" or t == "turn.failed": errs.append(str(ev)[:200])
    tests_ok = sha(os.path.join(d, "tests", "test_core.py")) == tsha and os.path.exists(os.path.join(d, "tests", "test_core.py"))
    r = subprocess.run([sys.executable, "-m", "unittest", "discover", "-s", "tests"], cwd=d, capture_output=True, text=True, timeout=60)
    ran = r.stderr.strip().splitlines()
    summary = ran[-1] if ran else ""; import re
    m = re.search(r"Ran (\d+) tests", r.stderr); n = int(m.group(1)) if m else 0
    fails = len(re.findall(r"^(FAIL|ERROR):", r.stderr, re.M))
    passed = n - fails if n else 0
    diff = subprocess.run(["git", "diff", "--stat"], cwd=d, capture_output=True, text=True).stdout.strip().splitlines()[-1:] 
    rec = dict(ts=time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()), seat=name, provider=provider, model=model, effort=effort, run=run_idx, wall_s=round(wall, 1), timeout=timeout,
               passed=passed, total=n, tests_unmodified=tests_ok, commands=cmds, usage=usage, errors=errs[:3], diffstat=diff[0] if diff else "", rc=getattr(p, "returncode", None))
    with open(os.path.join(HERE, "results_agentic.jsonl"), "a") as f: f.write(json.dumps(rec) + "\n")
    print(f"{name:12s} {effort:8s} pass={passed}/{n} tests_ok={tests_ok} {wall:.0f}s cmds={cmds} usage={usage} err={errs[:1]} {diff}", flush=True)
    return rec

if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("--seats", required=True); ap.add_argument("--runs", type=int, default=1); ap.add_argument("--workers", type=int, default=3)
    a = ap.parse_args()
    seats = [s.split(":") for s in a.seats.split(",")]
    jobs = [(n, p, m, e, r) for r in range(a.runs) for n, p, m, e in seats]
    with cf.ThreadPoolExecutor(a.workers) as ex: list(ex.map(lambda j: run_seat(*j), jobs))
