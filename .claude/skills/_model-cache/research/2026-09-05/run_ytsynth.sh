#!/bin/bash
D=$HOME/.claude/skills/_model-cache/research/2026-09-05
while [ ! -f $D/yt/retry.done ]; do sleep 20; done
for N in muse astra; do
  ( cd $D/yt; echo "start $(date -u +%FT%TZ)" > $D/logs/ytsynth_$N.log; codex exec --json -m gpt-5.6-sol -c model_reasoning_effort=high -s read-only --skip-git-repo-check -C $D/yt -o $D/yt/youtube-evidence-$N.md < $D/prompts/ytsynth_$N.md >> $D/logs/ytsynth_$N.log 2>&1; echo "exit=$? end $(date -u +%FT%TZ)" >> $D/logs/ytsynth_$N.log ) &
done
wait; echo SYNTHDONE > $D/yt/synth.done
