#!/usr/bin/env python3
"""Codex CLI bakeoff runner (ChatGPT sub billed): pipes the same task prompts into `codex exec -m <model>` and grades with the same graders.
Usage: run_codex.py --models gpt-6-astra,gpt-5.6-sol --tasks t1_iso,... [--effort high] [--tag codex] [--workers 3]"""
import argparse, json, os, sys, time, subprocess, re, tempfile, concurrent.futures as cf
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import tasks as T
HERE = os.path.dirname(os.path.abspath(__file__))

def run_one(model, task_id, effort, tag, run_idx):
    task = T.TASKS[task_id]
    if task["kind"] in ("tools",):
        return None
    prompt = task["prompt"] if task.get("prompt") else task["builder"]()
    if task.get("schema"):
        prompt = prompt  # schema is already in the prompt text
    args = ["codex", "exec", "--json", "-m", model, "-c", f"model_reasoning_effort={effort}", "-s", "read-only", "--skip-git-repo-check"]
    d = tempfile.mkdtemp()
    outp = os.path.join(d, "final.md")
    args += ["-C", d, "-o", outp]
    if task["kind"] == "vision":
        import base64
        img = os.path.join(d, "table.png"); open(img, "wb").write(base64.b64decode(task["image"]()))
        args += ["-i", img]
    prompt = "Answer the task below directly in your final message. Do not create or edit files, do not run commands unless the task requires computation you cannot do in your head.\n\n" + prompt
    t0 = time.time()
    p = subprocess.run(args, input=prompt, capture_output=True, text=True, timeout=1800)
    wall = time.time() - t0
    text = open(outp).read() if os.path.exists(outp) else ""
    tokens = None; err = None
    for line in p.stdout.splitlines():
        try: ev = json.loads(line)
        except Exception: continue
        if ev.get("type") == "turn.completed":
            tokens = ev.get("usage")
        if ev.get("type") == "error": err = str(ev)[:300]
    if p.returncode != 0 and not text:
        err = (err or "") + " rc=" + str(p.returncode) + " " + (p.stderr[-300:] if p.stderr else "")
    ctx = {"tool_calls": []}
    if err and not text: score, note = 0.0, "ERROR " + err
    else:
        try: score, note = task["grade"](text, ctx)
        except Exception as e: score, note = 0.0, "grader exception " + repr(e)[:200]
    safe = re.sub(r"[^A-Za-z0-9._-]", "_", model)
    open(os.path.join(HERE, "out", f"{task_id}__codex-{safe}__{effort}__{tag}__{run_idx}.txt"), "w").write(text or ("ERROR: " + str(err)))
    u = tokens or {}
    rec = dict(ts=time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()), tag=tag, run=run_idx, model="codex/" + model, task=task_id, effort=effort, provider="codex-cli", finish=None,
               wall_s=round(wall, 1), turns=1, in_tok=u.get("input_tokens"), out_tok=u.get("output_tokens"), reason_tok=u.get("reasoning_output_tokens"), cost_usd=None, cached_in=u.get("cached_input_tokens"),
               score=round(score, 3), note=note[:400], schema_mode=None, error=err)
    with open(os.path.join(HERE, "results.jsonl"), "a") as f: f.write(json.dumps(rec) + "\n")
    print(f"{task_id:12s} codex/{model:20s} {effort:6s} score={score:.2f} {wall:.0f}s tok={u} {note[:90]}", flush=True)
    return rec

if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("--models", required=True); ap.add_argument("--tasks", default="t1_iso,t2_bugfix,t3_extract,t4_reason,t5_needle,t6_format,t7_hungarian,t8_vision"); ap.add_argument("--effort", default="high"); ap.add_argument("--tag", default="codex"); ap.add_argument("--runs", type=int, default=1); ap.add_argument("--workers", type=int, default=3)
    a = ap.parse_args()
    jobs = [(m, t, a.effort, a.tag, r) for r in range(a.runs) for m in a.models.split(",") for t in a.tasks.split(",")]
    with cf.ThreadPoolExecutor(a.workers) as ex:
        list(ex.map(lambda j: run_one(*j), jobs))
