#!/usr/bin/env python3
import json, collections
print("## Agentic repo task (ledger: 5 bugs + 1 feature, 11 unit tests, tests locked)\n")
print("### Identical mini agent harness over OpenRouter (read/write/list/shell tools)\n")
print("| seat | model | effort | run | pass | wall s | turns | tool calls | shell | in tok | out tok | reason tok | cost $ |"); print("|---|---|---|---|---|---|---|---|---|---|---|---|---|")
rows=[json.loads(l) for l in open('results_miniagent.jsonl')]
for r in sorted(rows,key=lambda r:(r['seat'],r['run'])):
    print(f"| {r['seat']} | {r['model']} | {r['effort']} | {r['run']} | {r['passed']}/{r['total']}{'' if r['tests_unmodified'] else ' (tests edited!)'} | {r['wall_s']} | {r['turns']} | {r['tool_calls']} | {r['shell']} | {r['in_tok']} | {r['out_tok']} | {r['reason_tok']} | {r['cost']:.3f} |")
print("\n### Native Codex CLI harness (ChatGPT Pro sub, workspace-write sandbox)\n")
print("| seat | model | effort | run | pass | wall s | commands | in tok | cached in | out tok | reason tok |"); print("|---|---|---|---|---|---|---|---|---|---|---|")
for l in open('results_agentic.jsonl'):
    r=json.loads(l)
    if r['wall_s']<1: continue
    u=r['usage'] or {}
    print(f"| {r['seat']} | {r['model']} | {r['effort']} | {r['run']} | {r['passed']}/{r['total']} | {r['wall_s']} | {r['commands']} | {u.get('input_tokens')} | {u.get('cached_input_tokens')} | {u.get('output_tokens')} | {u.get('reasoning_output_tokens')} |")
