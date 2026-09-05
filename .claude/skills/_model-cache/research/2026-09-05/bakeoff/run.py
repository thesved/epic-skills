#!/usr/bin/env python3
"""OpenRouter bakeoff runner. Usage: run.py --models a,b --tasks t1,t2 [--effort low|medium|high|xhigh] [--tag x] [--runs 1] [--workers 6]
Records wall time, tokens (prompt/completion/reasoning), OpenRouter-reported cost, provider, finish_reason, score, note -> results.jsonl; raw output -> out/."""
import argparse, json, os, sys, time, subprocess, re, concurrent.futures as cf
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import tasks as T
import urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))
KEY = subprocess.run(["bash", "-c", "source ~/.claude/skills/_model-cache/lib.sh; resolve_key OPENROUTER_API_KEY"], capture_output=True, text=True).stdout.strip()
URL = "https://openrouter.ai/api/v1/chat/completions"

# model-specific fixed settings (from _model-cache rules)
FIXED = {
 "z-ai/glm-5.3-flash": {"reasoning": {"effort": "high"}, "provider": {"order": ["Baseten"], "allow_fallbacks": True}},
 "deepseek/deepseek-v4-pro-0813": {"reasoning": {"effort": "high"}},
 "z-ai/glm-5.3": {"reasoning": {"effort": "high"}},
}

def call(body, timeout=900):
    req = urllib.request.Request(URL, data=json.dumps(body).encode(), headers={"Authorization": f"Bearer {KEY}", "content-type": "application/json", "HTTP-Referer": "https://github.com/thesved/epic-skills", "X-Title": "muse-bakeoff"})
    t0 = time.time()
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            d = json.loads(r.read())
    except urllib.error.HTTPError as e:
        try: d = json.loads(e.read())
        except Exception: d = {"error": {"message": str(e)}}
    except Exception as e:
        d = {"error": {"message": repr(e)}}
    return d, time.time() - t0

def run_one(model, task_id, effort, tag, run_idx):
    task = T.TASKS[task_id]
    prompt = task["prompt"] if task.get("prompt") else task["builder"]()
    if task["kind"] == "vision":
        content = [{"type": "text", "text": prompt}, {"type": "image_url", "image_url": {"url": "data:image/png;base64," + task["image"]()}}]
    else:
        content = prompt
    messages = [{"role": "user", "content": content}]
    body = {"model": model, "messages": messages, "usage": {"include": True}}
    body.update(FIXED.get(model, {}))
    if effort != "default":
        body["reasoning"] = {"effort": effort}
    if task.get("schema"):
        body["response_format"] = {"type": "json_schema", "json_schema": {"name": "extract", "strict": True, "schema": task["schema"]}}
    if task.get("tools"):
        body["tools"] = task["tools"]
    ctx = {"tool_calls": []}
    total = {"wall": 0.0, "in": 0, "out": 0, "reason": 0, "cost": 0.0, "turns": 0}
    text = ""; provider = None; finish = None; err = None; schema_mode = "strict" if task.get("schema") else None
    for turn in range(14):
        d, wall = call(body)
        total["wall"] += wall; total["turns"] += 1
        if "error" in d:
            msg = json.dumps(d["error"])[:300]
            if task.get("schema") and schema_mode == "strict":
                schema_mode = "fallback_prompt"; body.pop("response_format", None); continue
            err = msg; break
        u = d.get("usage", {}) or {}
        total["in"] += u.get("prompt_tokens", 0) or 0; total["out"] += u.get("completion_tokens", 0) or 0
        total["reason"] += (u.get("completion_tokens_details") or {}).get("reasoning_tokens", 0) or 0
        total["cost"] += u.get("cost", 0) or 0
        provider = d.get("provider"); ch = d["choices"][0]; finish = ch.get("finish_reason"); msg = ch["message"]
        text = msg.get("content") or ""
        tcs = msg.get("tool_calls") or []
        if tcs and task.get("tools"):
            body["messages"].append({"role": "assistant", "content": msg.get("content"), "tool_calls": tcs, **({"reasoning": msg["reasoning"]} if msg.get("reasoning") else {})})
            for tc in tcs:
                name = tc["function"]["name"]
                try: args = json.loads(tc["function"].get("arguments") or "{}")
                except Exception: args = {"_raw": tc["function"].get("arguments")}
                ctx["tool_calls"].append((name, args))
                body["messages"].append({"role": "tool", "tool_call_id": tc["id"], "content": json.dumps(task["impl"](name, args))})
            continue
        break
    if err:
        score, note = 0.0, "ERROR " + err
    else:
        try: score, note = task["grade"](text, ctx)
        except Exception as e: score, note = 0.0, "grader exception " + repr(e)[:200]
    safe = re.sub(r"[^A-Za-z0-9._-]", "_", model)
    outp = os.path.join(HERE, "out", f"{task_id}__{safe}__{effort}__{tag}__{run_idx}.txt")
    open(outp, "w").write(text if not err else "ERROR: " + err)
    rec = dict(ts=time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()), tag=tag, run=run_idx, model=model, task=task_id, effort=effort, provider=provider, finish=finish,
               wall_s=round(total["wall"], 1), turns=total["turns"], in_tok=total["in"], out_tok=total["out"], reason_tok=total["reason"], cost_usd=round(total["cost"], 5),
               score=round(score, 3), note=note[:400], schema_mode=schema_mode, error=err)
    with open(os.path.join(HERE, "results.jsonl"), "a") as f: f.write(json.dumps(rec) + "\n")
    print(f"{task_id:12s} {model:40s} {effort:8s} score={score:.2f} {total['wall']:.0f}s in={total['in']} out={total['out']} r={total['reason']} ${total['cost']:.4f} {provider} {note[:90]}", flush=True)
    return rec

if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("--models", required=True); ap.add_argument("--tasks", default=",".join(T.TASKS)); ap.add_argument("--effort", default="default"); ap.add_argument("--tag", default="main"); ap.add_argument("--runs", type=int, default=1); ap.add_argument("--workers", type=int, default=6)
    a = ap.parse_args()
    jobs = [(m, t, a.effort, a.tag, r) for r in range(a.runs) for m in a.models.split(",") for t in a.tasks.split(",")]
    with cf.ThreadPoolExecutor(a.workers) as ex:
        list(ex.map(lambda j: run_one(*j), jobs))
