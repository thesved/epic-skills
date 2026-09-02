#!/bin/bash
# train_desc.sh: optimize a skill DESCRIPTION with Anthropic's skill-creator run_loop, isolated from
# user-level skills (no live skill is moved). Usage:
#   bash train_desc.sh <skill-dir> <eval.json> <sealed.json> [work-dir] [model]
# Isolation = a PATH shim that adds `--setting-sources project` to every `claude -p`, run from a scratch
# project dir whose .claude/commands/ receives the candidate. User skills never load, so the installed
# original cannot shadow the candidate (which otherwise reads as 0% recall for every candidate).
set -euo pipefail
SKILL_DIR="${1:?skill dir}"; EVAL="${2:?eval.json}"; SEALED="${3:?sealed.json}"
WORK="${4:-$(mktemp -d)}"; MODEL="${5:-sonnet}"
P="$HOME/.claude/plugins/marketplaces/claude-plugins-official/plugins/skill-creator/skills/skill-creator"
PY="${PYTHON:-/opt/homebrew/bin/python3.11}"
[ -f "$P/scripts/run_loop.py" ] || { echo "skill-creator plugin not in marketplace cache: $P" >&2; exit 1; }
mkdir -p "$WORK/bin" "$WORK/proj/.claude/commands"
REAL="$(command -v claude)"
printf '#!/bin/bash\nexec "%s" --setting-sources project "$@"\n' "$REAL" > "$WORK/bin/claude"; chmod +x "$WORK/bin/claude"
export PATH="$WORK/bin:$PATH" PYTHONPATH="$P"
cd "$WORK/proj"
ORIG="$($PY - "$SKILL_DIR/SKILL.md" <<'PYEOF'
import re,sys
s=open(sys.argv[1],encoding="utf-8").read()
m=re.search(r'^description:\s*>-?\s*\n((?:[ \t]+.*\n)+)',s,re.M) or re.search(r'^description:\s*(.*)$',s,re.M)
print(" ".join(l.strip() for l in m.group(1).splitlines()))
PYEOF
)"
echo "== sealed BEFORE (original description)"
$PY -m scripts.run_eval --eval-set "$SEALED" --skill-path "$SKILL_DIR" --description "$ORIG" --model "$MODEL" --runs-per-query 3 --num-workers 5 --timeout 60 > "$WORK/sealed_before.json" 2>"$WORK/sealed_before.log"
$PY -c "import json;d=json.load(open('$WORK/sealed_before.json'));print(d['summary'])"
echo "== run_loop"
$PY -m scripts.run_loop --eval-set "$EVAL" --skill-path "$SKILL_DIR" --model "$MODEL" --max-iterations 5 --runs-per-query 3 --num-workers 6 --timeout 60 --report none --results-dir "$WORK/results" --verbose > "$WORK/run_loop.log" 2>&1 || true
grep -n "Train:\|Test:" "$WORK/run_loop.log" | cut -c1-140 || true
BEST="$($PY - "$WORK/results" <<'PYEOF'
import json,glob,sys
fs=sorted(glob.glob(sys.argv[1]+"/*/results.json")); d=json.load(open(fs[-1])) if fs else {}
print(d.get("best_description",""))
PYEOF
)"
printf '%s' "$BEST" > "$WORK/best_description.txt"
echo "== sealed AFTER (best description, ${#BEST} chars)"
if [ -n "$BEST" ]; then
  $PY -m scripts.run_eval --eval-set "$SEALED" --skill-path "$SKILL_DIR" --description "$BEST" --model "$MODEL" --runs-per-query 3 --num-workers 5 --timeout 60 > "$WORK/sealed_after.json" 2>"$WORK/sealed_after.log"
  $PY -c "import json;d=json.load(open('$WORK/sealed_after.json'));print(d['summary'])"
  grep -nP "\x{2014}|\x{2013}" "$WORK/best_description.txt" >/dev/null && echo "LINT: best description contains an em/en dash; strip before accepting" || true
fi
rm -f "$WORK"/proj/.claude/commands/*-skill-*.md
echo "work dir: $WORK  (accept only if sealed passes rise by >= 2/10)"
