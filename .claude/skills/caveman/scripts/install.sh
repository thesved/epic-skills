#!/usr/bin/env bash
# caveman install: idempotent upsert of the communication block into a project CLAUDE.md.
# Usage: install.sh [path/to/CLAUDE.md]   (default: ./CLAUDE.md)
# Re-run any time: refreshes the marker-delimited block to the latest version, never duplicates.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BLOCK_FILE="$SCRIPT_DIR/../assets/claude-md-block.md"
TARGET="${1:-./CLAUDE.md}"
START="<!-- caveman:install:start -->"
END="<!-- caveman:install:end -->"

[ -f "$BLOCK_FILE" ] || { echo "ERROR: block asset missing: $BLOCK_FILE" >&2; exit 1; }

python3 - "$TARGET" "$BLOCK_FILE" "$START" "$END" << 'PY'
import sys, os
target, block_file, start, end = sys.argv[1:5]
block = open(block_file).read().strip()
wrapped = f"{start}\n{block}\n{end}\n"

if not os.path.exists(target):
    open(target, "w").write(wrapped)
    print(f"installed: created {target}")
    sys.exit(0)

text = open(target).read()
if start in text and end in text:
    pre, rest = text.split(start, 1)
    _, post = rest.split(end, 1)
    new = pre + wrapped.rstrip("\n") + post
    if new == text:
        print(f"unchanged: {target} already current")
    else:
        open(target, "w").write(new)
        print(f"updated: refreshed block in {target}")
elif start in text or end in text:
    print(f"ERROR: {target} has one marker but not the other; fix manually", file=sys.stderr)
    sys.exit(1)
else:
    sep = "" if text.endswith("\n\n") else ("\n" if text.endswith("\n") else "\n\n")
    open(target, "a").write(sep + wrapped)
    print(f"installed: appended block to {target}")
PY
