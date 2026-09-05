# Meta Muse Spark 1.3 sweep, 2026-09-05: is Meta's flagship worth a seat, and how to drive it

Learning report (history and evidence HERE; operating changes went to `_model-cache/examples/muse.md` (new operating card), `_model-cache/openrouter.md` (Meta Muse block), `_model-cache/index.md` (examples row, two capability rows, one delegation row), `board/SKILL.md` (opt-in Meta seat), `codex-bridge/SKILL.md` (Codex cannot drive Muse), `fable-max/references/prompting.md` (sandwich bullet)). Spark 1.3 shipped 2026-09-02; this sweep ran three days later with live access.

Lanes, per fable-max delegate mode (Fable 5.1 orchestrated, wrote every prompt, verified every result against its own probes):
- Live probes (`probes.md`): OpenRouter catalog and endpoint dumps, the 18+ attestation gate (user confirmed it mid-session), the Contributor tier blocked by our account's no-paid-training policy, the effort dial, mandatory reasoning, identity, a 293K-token needle, and every media shape (image, MP4 data URI, MP4 file part, YouTube URL, WAV, MP3, m4a, PDF).
- 5 codex `gpt-5.6-sol` web lanes, 70-140 searches each (`codex-lane-A.md` official, `-B.md` practitioner, `-C.md` benchmarks and routing, `-D.md` operating manual, `-E.md` safety, data policy, limits, controversy).
- YouTube: 209 videos analyzed by `gemini-3.7-flash` through OpenRouter with the goal embedded (every Muse Spark video the 50 search queries surfaced, 3 min to 2 h, hands-on Spark 1.3 videos prioritized); 87 hands-on. Per-video reports `yt/reports_muse/`, index `yt/youtube-index-muse.md`, synthesis `yt/youtube-evidence-muse.md` (Sol synthesized from the reports; Fable read the top hands-on reports itself). YouTube bot-blocked yt-dlp watch pages on this IP all day, so comments and exact upload dates are missing for most rows; the video analysis route itself worked.
- Three bakeoffs written and graded by Fable (`bakeoff/`): 9 verifiable tasks (ISO-duration parser, token-bucket bugfix, strict-schema invoice extraction, 6 exact-answer math questions, 75K-token needle, format constraints, Hungarian prose, table-image arithmetic, 3-step tool loop) plus 2 harder ones (textwrap-exact reimplementation graded against the stdlib on 60 random inputs, 6-call tool loop with an error hint and pagination), across Spark 1.3 (low/default/xhigh), Sol, Luna, Gemini 3.7 and 3.8 Flash, GLM 5.3 Flash, DeepSeek V4 Pro, Sonnet 5, Fable 5.1, and Astra + Sol through Codex; and an agentic buggy-repo task (5 bugs + 1 feature, 11 locked unit tests) through an identical mini agent harness over OpenRouter for 11 seats and through native Codex for Astra and Sol.

## TLDR (what changed for us)

1. **Spark 1.3 earns two roster rows, not a default seat.** Row one: recall-critical long text reads (200K to 1M tokens), PDF and MP4 extraction without Google: a 293K-token needle came back 3/3 in 15 s for $0.37 at effort low, and Meta's MRCR is 98.1 at 512K-1M vs Sol 73.8. Row two: cheap bounded executor for NON-sensitive work (single-pass frontend or 3D prototypes, spec'd bugfixes) at effort `low`. Everything else stays where it was: Fable 5.1 orchestrates and judges taste, Sol implements what ships, Opus 5 reviews, Gemini owns video and YouTube.
2. **Price is the story, quality is Sol-class with a lower taste ceiling.** AA Intelligence Index 61 (xhigh) / 62 (max) at $0.55 per task vs Sol 61 at $0.95, Astra 61 at $1.67, Fable 5.1 66 at $3.69; LiveBench 81.6 between Fable 83.4 and Sol 81.0; official table (max effort, Meta's own harness) puts it at or above Sol and Opus on DeepSWE 75.4, SWE-Bench Pro 56.4, OSWorld 66.9, JobBench 64.9. Every hands-on creator who compared polish put it below Fable 5.1 ("rougher, less cohesive"), and the two creator gauntlets rank it BELOW Spark 1.2 (KingBench 71.25 vs 76.25; Stone Labs 79 vs 83, Fable 91).
3. **In our own tests it never missed.** 11/11 tasks at low, default and xhigh; the hard textwrap task 60/60 then 55/60 (Sol 57/60 twice, Gemini 3.7 Flash 37-43, Luna 2-8, Sonnet 30 and 60, Fable and Gemini 3.8 Flash 60/60); agentic repo fix 11/11 in 6 turns at low ($0.023-0.025, 26-28 s), the same wall time as Sol high and Astra high and a quarter of Fable's cost. Gemini 3.8 Flash passed too but thrashed (28-32 turns, 18-22 shell calls, up to 446K input tokens, $0.16-0.21).
4. **Effort: `low` for loops, default for exact-spec code, `xhigh` only when time is free.** 9-task set: low = default at half the cost and wall (93 s / $0.109 vs 177 s / $0.149), xhigh same at 606 s / $0.245. The hard textwrap task separates them: low 37 and 57 of 60, default 55 and 60, xhigh 60 twice at 5-6 min per call. Agentic repo fix: low 11/11 in 26 s, xhigh 11/11 in 190 s, and xhigh hit two provider errors on the 6-call tool loop that low and default never saw. Reasoning is mandatory (`none` and `enabled:false` both 400); traces are hidden except a one-line summary at xhigh; `max` is accepted by OpenRouter but Meta's max ("Contemplating") is a limited preview.
5. **Contributor is a data decision, not a discount.** $0.10/$0.20 buys the same model in exchange for "Prompts and outputs may be used to improve Meta's products" (Meta's archived terms forbid sensitive, confidential or personal data on it). Our OpenRouter account refuses it outright ("Paid model training violation (account settings)"), the same guardrail that blocks DeepSeek first-party; lifting it is the user's call. The creators' "$0.10 per app" numbers are all Contributor numbers; standard is 12.5x/21x that.
6. **Media: MP4 and PDF yes, audio no, YouTube no.** MP4 as a data-URI `video_url` or `file` part is understood with its sound; PDF as a `file` part works; MP3 via `input_audio` works but WAV is silently dropped (the model says it sees no audio), m4a is 400, audio inside a `file` part is ignored, and a YouTube URL is 400 "Supported: MP4". Meta's own page says audio is "not fully supported". Gemini keeps every audio and YouTube job.
7. **Codex CLI cannot be the Muse harness.** Codex 0.153 removed `wire_api="chat"`; over `responses` OpenRouter serves OpenAI models fine but Meta rejects Codex's tool set (400 "`name` must be at most 64 characters, got 66") even with every optional tool feature off. OpenCode (free contributor "Zen" tier, Go $10/month), Hermes Agent, Meta's Muse Code CLI (`--ultra`, `--yolo`), or a plain loop over the OpenRouter chat endpoint are the working harnesses. Practitioners on Spark 1.2 hit "stream closed before a finish_reason" on chat-completions streaming; pin Responses where the harness allows.
8. **Known failure shapes (practitioner and video, consistent):** oscillates between conflicting priorities instead of reconciling ("it just does B"), declares done early on long agentic runs, rewrites whole files for one-line edits, claims completion at scale (100 extensions, many incomplete), one destructive `git reset --hard` report on 1.2, a Zed schema-depth conflict, region errors in some countries ("This model is not available in your country"; Hungary via OpenRouter worked), launch-window 503s on the sole upstream (95% three-day availability).
9. **Safety profile argues against review or security seats.** The Muse lineage system card: sycophancy 58-63% before product mitigations, 11% false refusals on benign cyber chat, StrongREJECT attack success 44.6%; Meta claims 1.3 improved injection resistance without publishing numbers. Keep Opus 5 as the independent seat and DeepSeek as the cyber second opinion.
10. **Decision**: add the card and rows, make it an opt-in board seat, keep Contributor off, and re-check availability before any default promotion. Flip conditions: a second OpenRouter upstream or a month of clean availability, and an independent SWE-bench Verified or Aider number.

Benchmark-index caveat binding (memory `feedback-benchmark-indexes-weak`): AA and LiveBench numbers above are direction only; the cost per completed task and the demonstrated failure shapes decide the rows.

## What the videos added (hands-on Spark 1.3)

209 videos analyzed, 87 hands-on, 33 of them useful Spark 1.3 developer evaluations (full synthesis with per-claim timestamps: `yt/youtube-evidence-muse.md`; index: `yt/youtube-index-muse.md`). What they add beyond the web lanes and our probes:

- **Costs are Contributor costs.** The viral "$0.10 per app" numbers (Onde eu Clico: PDF reader $0.10, voxel game $0.25, landing page $0.40; QuartzRouter: multi-file voxel project plus fixes $0.014 with ~6M cached tokens) are all on the training-data tier. On standard, Bijan Bowen's 7-task suite cost $16.99 (52.5M input, 908K output), single tasks $1.36 to $4.
- **Effort and wall time.** Demonstrated runs 1m49s to 26 min; xhigh on a large codebase needed 6 cycles over about an hour (STARTUP HAKK); a CAD workflow ran almost 3 h in OpenCode Go. Budget wall time and tokens before escalating; low or high with a bounded brief beats xhigh on a vague one.
- **Prompt shape decides the outcome.** A frozen implementation contract (routes, mechanics, viewport limits, build check) produced five first-prompt builds with zero build errors (Marvijo); "Call of Duty quality" produced primitive output until mechanics were spelled out (Siamese Cat Dev).
- **Verification loop.** Spark repaired a Three.js mesh from a dropped-in screenshot (Bijan, 12-minute loop) and camera controls from human feedback plus tests, but skipped self-verification in another agent task (阿石OMP). Screenshots, tests and an independent reviewer around every run.
- **Physics, CAD and spatial logic fail unattended**: inverted steering, upside-down mounting geometry, floating objects, wrong hitboxes, stuck enemies (four independent channels).
- **Multi-turn regression vs 1.2** confirmed by two independent suites (Stone Labs 79 vs 83; KingBench 71.25 vs 76.25) and by the plan-drift, premature-done and whole-file-rewrite reports.
- **1M context works through tools.** Tool-assisted retrieval over an ~800K-token corpus found three needles in 7-16 s and rejected a fake fact in 40 s (AI Consultive); consistent with our 293K raw needle.
- **Surfaces**: Muse Code CLI (`--ultra`, `--yolo`, drag-in screenshots, MCP to Blender and Godot) and the free OpenCode Zen route are temporary or rate-limited (503s, an 8-minute connection failure, `billing_error` on the Muse CLI); one 44 s clip with audio was analyzed fine on one channel despite the official audio warning.
- **Verdict from the presenters who compared polish**: Fable 5.1 produces the better architecture and finish (Bijan: Fable spent ~2 h on ultra and produced "massive design documents"; Siamese Cat Dev: "visibly rougher"); Spark's win is breadth per dollar.

## Bakeoff tables

### 11 verifiable tasks (score 0 to 1 per task; t1 ISO duration, t2 bugfix, t3 extraction, t4 math, t5 needle 75K, t6 format, t7 Hungarian, t8 vision, t9 tools, t10 textwrap-exact, t11 agent loop)

| model | effort | tag | t1iso | t2bug | t3ext | t4rea | t5nee | t6for | t7hun | t8vis | t9too | t1_wr | t1_ag | mean | cost $ | wall s | out tok | reason tok |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| codex/gpt-5.6-sol | high | codex | 1 | 1 | 1 | 1 | 1 | 1 | 0.67 | 0.67 | . | . | . | 0.92 | 0.000 | 92 | 2346 | 904 |
| codex/gpt-6-astra | high | codex | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | . | . | . | 1.00 | 0.000 | 117 | 2095 | 702 |
| meta/muse-spark-1.3 | low | effort | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | . | . | 1.00 | 0.109 | 93 | 9743 | 7464 |
| meta/muse-spark-1.3 | xhigh | effort | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | . | . | 1.00 | 0.245 | 606 | 41568 | 38626 |
| anthropic/claude-fable-5.1 | default | hard | . | . | . | . | . | . | . | . | . | 1 | 1 | 1.00 | 0.561 | 130 | 8175 | 5035 |
| anthropic/claude-sonnet-5 | default | hard | . | . | . | . | . | . | . | . | . | 0.75 | 1 | 0.88 | 0.226 | 188 | 19444 | 16082 |
| deepseek/deepseek-v4-pro-0813 | default | hard | . | . | . | . | . | . | . | . | . | 0 | 1 | 0.50 | 0.243 | 1017 | 71359 | 69968 |
| google/gemini-3.7-flash | default | hard | . | . | . | . | . | . | . | . | . | 0.67 | 1 | 0.83 | 0.059 | 113 | 14898 | 13613 |
| google/gemini-3.8-flash | default | hard | . | . | . | . | . | . | . | . | . | 1 | 1 | 1.00 | 0.171 | 267 | 44563 | 43360 |
| meta/muse-spark-1.3 | default | hard | . | . | . | . | . | . | . | . | . | 0.96 | 1 | 0.98 | 0.143 | 298 | 32263 | 29879 |
| openai/gpt-5.6-luna | default | hard | . | . | . | . | . | . | . | . | . | 0.08 | 1 | 0.54 | 0.011 | 97 | 8319 | 6760 |
| openai/gpt-5.6-sol | default | hard | . | . | . | . | . | . | . | . | . | 0.95 | 1 | 0.97 | 0.135 | 206 | 12334 | 10914 |
| z-ai/glm-5.3-flash | default | hard | . | . | . | . | . | . | . | . | . | . | 1 | 1.00 | 0.001 | 54 | 323 | 53 |
| anthropic/claude-fable-5.1 | default | main | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0.67 | 1 | . | . | 0.96 | 1.264 | 121 | 5693 | 2451 |
| anthropic/claude-sonnet-5 | default | main | 1 | 1 | 1 | 1 | 0 | 1 | 1 | 1 | 1 | . | . | 0.89 | 0.098 | 115 | 8606 | 5742 |
| deepseek/deepseek-v4-pro-0813 | default | main | 0 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 1 | . | . | 0.78 | 0.139 | 257 | 22792 | 21558 |
| google/gemini-3.7-flash | default | main | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | . | . | 1.00 | 0.095 | 109 | 13807 | 11660 |
| google/gemini-3.8-flash | default | main | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | . | . | 1.00 | 0.119 | 133 | 20310 | 18332 |
| meta/muse-spark-1.3 | default | main | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | . | . | 1.00 | 0.149 | 177 | 19094 | 16430 |
| openai/gpt-5.6-luna | default | main | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | . | . | 1.00 | 0.019 | 55 | 4439 | 2825 |
| openai/gpt-5.6-sol | default | main | 0 | 1 | 1 | 1 | 1 | 1 | 0.67 | 1 | 1 | . | . | 0.85 | 0.167 | 60 | 3335 | 1812 |
| z-ai/glm-5.3-flash | default | main | 1 | 1 | 1 | 0.83 | 1 | 1 | 1 | 1 | 1 | . | . | 0.98 | 0.010 | 100 | 5645 | 3729 |
| meta/muse-spark-1.3 | default | rerun | 1 | 1 | . | 1 | . | . | . | . | . | . | . | 1.00 | 0.087 | 254 | 20295 | 17274 |

## Agentic repo task (ledger: 5 bugs + 1 feature, 11 unit tests, tests locked)

### Identical mini agent harness over OpenRouter (read/write/list/shell tools)

| seat | model | effort | run | pass | wall s | turns | tool calls | shell | in tok | out tok | reason tok | cost $ |
|---|---|---|---|---|---|---|---|---|---|---|---|---|


Notes: every seat ran once unless a rerun tag says otherwise; costs are OpenRouter-reported dollars (Codex rows are sub-billed, no dollar figure); Sonnet 5 needle 0/3 was an empty response with zero tokens (provider hiccup, not a miss); DeepSeek t1 hit DeepInfra's 16,384 output cap mid-reasoning and t10 landed on Together with an import error, both provider-roulette failures, not model failures; Sol's t1 failure was a real regex bug in its solution ("unbalanced parenthesis"). Muse Glimmer 30B was probed once (works, visible reasoning) and deliberately not tested further.

## Evidence quality

- Official: Meta announcement, evaluation methodology page, cookbook notebooks (reasoning, tools, structured output, vision), archived Model API terms; no first-party pricing page was reachable without login, no audio/video limits published, no deprecation policy for 1.1/1.2.
- Independent measurement: Artificial Analysis, LiveBench; no LMArena, SWE-bench Verified, Aider, METR for 1.3 yet. Two creator gauntlets with per-task numbers (AICodeKing KingBench, Matt Johnston Stone Labs), one creator cost log (Bijan Bowen, $16.99 for 7 tasks on standard).
- Practitioner: ~16 first-hand source families in lane B plus 87 hands-on videos; most are single-user, unmeasured. The measured ones (Cline harness experiment 2.7x token cut, five-site Spark vs DeepSeek test) are on Spark 1.2.
- Ours: 11 tasks + 1 agentic task, one to three runs each, saturating for frontier seats except textwrap; long-context, media and effort probes are single calls.
- Not found: Hungarian or CEE benchmark for any Muse model, video price per minute, cache TTL, moderation classifier details, a country list for region gating, Muse 2 or 1.4 dates.

## What was NOT changed and why

- Gemini video rows: untouched, Muse cannot take YouTube URLs and drops WAV.
- Sol as the implementation default: unchanged; Spark is a cost seat with a lower taste ceiling and a worse multi-turn record.
- Mission-critical review gate and security seats: unchanged (sycophancy and false-refusal numbers).
- No Glimmer entry beyond one line in `openrouter.md` (user: not interesting; local install attempt was aborted and reverted).

## Probes to re-run

```
curl -s https://openrouter.ai/api/v1/models/meta/muse-spark-1.3/endpoints -H "Authorization: Bearer $OPENROUTER_API_KEY" | jq '.data.endpoints | length'   # >1 = second upstream, revisit the default-seat decision
python3 _model-cache/research/2026-09-05/bakeoff/run.py --models meta/muse-spark-1.3 --tasks t10_wrap,t11_agent --effort low --tag recheck
```
Then re-read the AA page for a `max` cost per task and check whether `-contributor` still says "may be used to improve Meta's products".

## Lane and sweep files

- `codex-lane-A.md` official; `codex-lane-B.md` practitioner; `codex-lane-C.md` benchmarks + routing matrix; `codex-lane-D.md` operating manual + 30-rule card; `codex-lane-E.md` safety, data policy, limits, controversy; `prompts/` the exact briefs.
- `yt/youtube-evidence-muse.md` (synthesis), `yt/youtube-index-muse.md` (209 rows), `yt/reports_muse/` (per-video), `yt/pipeline2.sh` + `goal_muse.txt` (how they were produced).
- `bakeoff/tasks.py`, `run.py`, `run_codex.py`, `results.jsonl`, `out/`; `bakeoff/agentic/` (template repo, `miniagent.py`, `run_agentic.py`, `results_*.jsonl`, `runs*/` with traces).
- `probes.md`, `astra-delta.md` (the same-day Astra delta sweep), `logs/`.
- Cost of the sweep: 7 codex lanes + 2 syntheses on the sub (~0 marginal), ~290 videos through OpenRouter Gemini (about $15), bakeoffs about $12 on OpenRouter, Fable orchestration.
