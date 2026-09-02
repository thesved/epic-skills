import argparse, json, sys, importlib.util, types
from pathlib import Path
spec = importlib.util.spec_from_file_location("train_sop", "train_sop.py"); ts = importlib.util.module_from_spec(spec); sys.modules["train_sop"] = ts; spec.loader.exec_module(ts)
p = argparse.ArgumentParser(); p.add_argument("--judge", required=True); p.add_argument("--label", required=True); a = p.parse_args()
args = types.SimpleNamespace(mock=False, seed=42, target="codex", judge=a.judge, proposer="codex", out="out-real")
backends = ts.Backends(args)
seed_sop = ts.read_text(Path("sop-seed.md")); rubric = ts.read_text(Path("rubric.md"))
ops = json.load(open("out-real/rejected.json"))[0]["operations"]; cand = ts.apply_operations(seed_sop, ops)
split = ts.load_split(); inputs = ts.load_inputs(split["selection"])
cur = ts.run_targets(backends, seed_sop, inputs, "calib current (cached)"); can = ts.run_targets(backends, cand, inputs, "calib candidate (cached)")
res = ts.run_comparisons(backends, rubric, inputs, can, cur, "candidate", "current", f"calib-{a.label}")
w = sum(1 for c in res.values() if c.winner == "candidate"); l = sum(1 for c in res.values() if c.winner == "current"); u = sum(1 for c in res.values() if c.winner is None)
aa = 0
for c in res.values():
    rv = getattr(c, "raw_verdicts", None) or {}
    picks = [ (str(v).split("WINNER:")[1].strip()[:1] if "WINNER:" in str(v) else "?") for v in (rv.values() if isinstance(rv, dict) else rv) ]
    if picks and all(x == picks[0] and x in "AB" for x in picks): aa += 1
print(json.dumps({"judge": a.label, "wins": w, "losses": l, "undecided": u, "same_letter_both_orders": aa, "calls": backends.counts if hasattr(backends, "counts") else None}))
