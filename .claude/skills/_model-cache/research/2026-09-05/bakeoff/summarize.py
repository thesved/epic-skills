#!/usr/bin/env python3
"""Aggregate results.jsonl into markdown tables: per model x task score, plus cost/latency/tokens per model."""
import json, collections, sys
rows=[json.loads(l) for l in open('results.jsonl')]
tasks=["t1_iso","t2_bugfix","t3_extract","t4_reason","t5_needle","t6_format","t7_hungarian","t8_vision","t9_tools","t10_wrap","t11_agent"]
def key(r): return (r['model'], r['effort'], r['tag'])
by=collections.defaultdict(dict)
for r in rows:
    k=key(r); by[k].setdefault(r['task'],[]).append(r)
print("| model | effort | tag | " + " | ".join(t[:2]+t[3:6] for t in tasks) + " | mean | cost $ | wall s | out tok | reason tok |")
print("|---|---|---|" + "---|"*len(tasks) + "---|---|---|---|---|")
for k in sorted(by, key=lambda k:(k[2],k[0],k[1])):
    d=by[k]; cells=[]; scores=[]; cost=0; wall=0; out=0; rs=0
    for t in tasks:
        rr=d.get(t)
        if not rr: cells.append("."); continue
        s=sum(x['score'] for x in rr)/len(rr); scores.append(s)
        cells.append(("%.2f"%s).rstrip('0').rstrip('.') if s<1 else "1")
        for x in rr:
            cost+=x.get('cost_usd') or 0; wall+=x.get('wall_s') or 0; out+=x.get('out_tok') or 0; rs+=x.get('reason_tok') or 0
    n=sum(len(v) for v in d.values())
    print(f"| {k[0]} | {k[1]} | {k[2]} | " + " | ".join(cells) + f" | {(sum(scores)/len(scores) if scores else 0):.2f} | {cost:.3f} | {wall:.0f} | {out} | {rs} |")
