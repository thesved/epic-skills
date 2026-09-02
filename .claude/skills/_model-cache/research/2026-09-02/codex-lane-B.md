# Lane B: Claude Fable 5.1 practitioner evidence

**Research cutoff:** 2026-09-02, Asia/Bangkok  
**Release date:** 2026-09-01  
**Scope:** Hacker News, Reddit, X mirrors, newsletters, blogs, GitHub issues, benchmark operators, and Anthropic staff responses.

## Evidence labels

- **OFFICIAL | DEMONSTRATED:** Anthropic documentation, status records, product behavior, or published measurements.
- **OFFICIAL | ASSERTION:** Anthropic or an identified employee describes behavior without reproducible supporting material.
- **UNOFFICIAL | DEMONSTRATED:** A practitioner supplies logs, screenshots, outputs, test counts, or numeric comparisons. This does not imply independent replication.
- **UNOFFICIAL | ASSERTION:** Anecdote, impression, or unverified claim.

## TLDR: 10 decision-relevant findings

1. **Do not make `max` the fable-max default.** Simon Willison's single-prompt effort sweep jumped from about $0.10 and 23 seconds at `medium` to $1.83 and 7:51 at `xhigh`, then $3.30 and 13:54 at `max`. Quality improved, but cost and latency increased nonlinearly. Start at `high`, benchmark `medium`, and reserve `xhigh` or `max` for demonstrated hard cases. **[UNOFFICIAL | DEMONSTRATED]** [Simon Willison, 2026-09-01](https://simonwillison.net/2026/Sep/1/claude-fable-5-1/).

2. **Cheaper cache reads do not guarantee cheaper completed tasks.** Artificial Analysis reportedly measured $3.76 per task for Fable 5.1 `max`, about 20 percent above Fable 5, because 5.1 generated roughly 1.7 times as many output tokens. Its `xhigh` result was $2.72 with nearly the same index score. Atomic Agent's three-prompt loop saved only 7.5 percent, $7.65 to $7.08. **[UNOFFICIAL | DEMONSTRATED]** [Latent Space, 2026-09-02](https://www.latent.space/p/ainews-claude-fablemythos-51-new); [Atomic Agent, 2026-09-01](https://atomicagent.io/blog/claude-fable-5-1/); [GapNew4766, Reddit, 2026-09-02](https://www.reddit.com/r/AI_Agents/comments/1w4uqxn/for_agent_loops_the_cache_read_discount_is_the/).

3. **Per-step efficiency and total-session consumption are separate.** Every measured comparable Opus 5 agent output at under half the tokens and about 60 percent of the time, but also put 1.8 billion tokens through a single Fable 5.1 day when `xhigh` kept spawning subagents. This reconciles reports of efficient calls with reports of rapidly exhausted plan limits. **[UNOFFICIAL | DEMONSTRATED]** [Katie Parrott and Dan Shipper, 2026-09-01](https://every.to/vibe-check/fable-5-1-vibe-check).

4. **Subscription burn is highly variable and currently unpredictable.** Users reported exhausting a five-hour window in 12 to 60 minutes, while others reported seven hours of work consuming only about 20 percent. Workload size, initial uncached context, effort, subagents, plan type, and parallel sessions differ, so none of these anecdotes supports a universal conversion rate. **[UNOFFICIAL | DEMONSTRATED plus ASSERTION]** [ClaudeAI launch hub, 2026-09-01](https://www.reddit.com/r/ClaudeAI/comments/1w4qgue/fable_51_and_mythos_51_release_discussion_hub/); [Anthropic usage thread, 2026-09-02](https://www.reddit.com/r/Anthropic/comments/1w5508t/fable_51_is_really_fantastic_but_its_burning/); [51-transcript report, 2026-09-02](https://www.reddit.com/r/ClaudeAI/comments/1w4zyr5/1st_impressions_i_burned_an_entire_claude_max_20x/).

5. **5.1 is better at long, repository-wide execution for some users, but new failure modes are visible.** Positive reports cite better intent-to-implementation, large-context navigation, one-shot applications, and multi-hour autonomy. Negative reports cite repeated rereading, subagent loops, stopping after partial work, asking permission for already-authorized steps, and editing while a reviewer subagent is still active. **[UNOFFICIAL | mixed DEMONSTRATED and ASSERTION]** [Every, 2026-09-01](https://every.to/vibe-check/fable-5-1-vibe-check); [51-transcript report, 2026-09-02](https://www.reddit.com/r/ClaudeAI/comments/1w4zyr5/1st_impressions_i_burned_an_entire_claude_max_20x/); [stumpyinc mirror, 2026-09-01](https://www.reddit.com/r/Claude_reports/comments/1w4qe34/rclaudeai_fable_51_first_impressions_after_a_few/); [stuck report, 2026-09-02](https://www.reddit.com/r/Anthropic/comments/1w4v674/fable_51_keeps_getting_stuck/).

6. **The operating guide needs explicit instructions for surgical edits, complete delivery, scope boundaries, tool batching, and search at low effort.** These are not speculative optimizations. Anthropic's own 5.1 prompt guide documents whole-file rewrites, premature stopping, sequential tool calls, scope expansion, sparse progress updates, and reduced search triggering at `low`. **[OFFICIAL | ASSERTION with supplied mitigations]** [Anthropic prompting guide, accessed 2026-09-02](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1).

7. **Safeguard false positives are lower, not gone.** Anthropic staff said cyber fallbacks were down about 40 percent from Fable 5 immediately before launch and 55 percent from Fable 5's launch state. Every's testers also saw fewer refusals. Current practitioners nevertheless reported refusals involving theoretical mathematics phrased as a "military campaign," REST signed cookies, test-password login, reverse engineering, authentication code, and some medical work. **[OFFICIAL | ASSERTION and UNOFFICIAL | ASSERTION]** [Claude Developers mirror, 2026-09-01](https://twstalker.com/ClaudeDevs); [Every, 2026-09-01](https://every.to/vibe-check/fable-5-1-vibe-check); [Kyle Russell mirror, 2026-09-01](https://mobile.twstalker.com/kylebrussell); [HN launch thread, 2026-09-01](https://news.ycombinator.com/item?id=49525378).

8. **Do not treat an unexpected Opus answer as evidence that Fable itself completed the task.** Fable applications can route flagged cyber requests to Opus 4.8 and biology requests to Opus 5. An older Fable 5 issue demonstrates a `model_refusal_fallback` transcript event and a session remaining pinned to Opus. The 5.1 guide should log the returned model and refusal/fallback events. **[OFFICIAL | DEMONSTRATED and UNOFFICIAL | DEMONSTRATED]** [Anthropic fallback help, accessed 2026-09-02](https://support.claude.com/en/articles/15363606-why-claude-switched-models-in-your-conversation-with-fable-5-or-fable-5-1); [GitHub issue #76518, 2026-07-10](https://github.com/anthropics/claude-code/issues/76518).

9. **Verified `/goal` and unattended overnight evidence is still thin.** Every documented day-long `xhigh` sessions and one-shot delegated builds, and a Reddit commenter claimed an overnight milestone workflow succeeded. I found no public raw `/goal` transcript, reproducible overnight comparison, or failure-rate series specifically for 5.1. Mark `/goal` guidance provisional. **[UNOFFICIAL | partial DEMONSTRATED plus ASSERTION]** [Every, 2026-09-01](https://every.to/vibe-check/fable-5-1-vibe-check); [ClaudeAI launch hub, 2026-09-01](https://www.reddit.com/r/ClaudeAI/comments/1w4qgue/fable_51_and_mythos_51_release_discussion_hub/).

10. **The pre-release story did not provide reliable proof of early public routing.** daily.dev published a page titled "Claude Fable 5.1 is already live for some users before Anthropic said a word," but its accessible page exposed no article body, author, test record, or model-response evidence. An August 27 Reddit thread relied on self-identification prompts and perceived behavior while another commenter noted that the harness had changed twice. The allegation remains **NOT VERIFIED**. **[UNOFFICIAL | ASSERTION]** [daily.dev pre-release page, accessed 2026-09-02](https://preview3.app.daily.dev/posts/claude-fable-5-1-is-already-live-for-some-users-before-anthropic-said-a-word-ylqmkv8yy); [Reddit pre-release thread, 2026-08-27](https://www.reddit.com/r/ClaudeAI/comments/1w05cv6/did_anthropic_release_fable_51/).

---

## 1. Effort settings

### Controlled evidence

Simon Willison ran the same SVG pelican prompt across all five effort settings:

| Effort | Output tokens | Time | Cost | Observation |
|---|---:|---:|---:|---|
| `low` | 1,998 | 23.8 s | $0.10017 | No reasoning summary |
| `medium` | 1,977 | 23.0 s | $0.09912 | No reasoning summary |
| `high` | 2,612 | 29.6 s | $0.13087 | Some summarized reasoning |
| `xhigh` | 36,767 | 7:51 | $1.83 | Large jump in reasoning |
| `max` | 65,927 | 13:54 | $3.30 | Best Anthropic pelican in his subjective review |

**[UNOFFICIAL | DEMONSTRATED]** [Simon Willison, 2026-09-01](https://simonwillison.net/2026/Sep/1/claude-fable-5-1/).

The result is one prompt with stochastic outputs, not a general benchmark. It does demonstrate that higher effort can change cost by more than an order of magnitude without changing the requested artifact's nominal size. **[UNOFFICIAL | DEMONSTRATED]** [Simon Willison, 2026-09-01](https://simonwillison.net/2026/Sep/1/claude-fable-5-1/).

CodeRabbit's 45-task review evaluation found the opposite of "higher is always better":

| Setting | Recall | Precision | Comments | Nitpicks | Average time |
|---|---:|---:|---:|---:|---:|
| `low` | 61.0% | 37.3% | 166 | 79 | 18:38 |
| `high` | 57.1% | 36.4% | 165 | 88 | 21:36 |

Both settings completed 45 tasks with 92 review-file calls. CodeRabbit concluded that `high` took longer while finding fewer known issues. **[UNOFFICIAL | DEMONSTRATED]** [Juan Pablo Flores and Gowtham Kishore Vijay, 2026-09-01](https://www.coderabbit.ai/blog/fable-5-1-model-review).

Every's team found `low`, `medium`, and `high` all "super good" for Kieran Klaassen's tasks, while extra-high "rips" but delegates too aggressively. Most of Every's team chose `high` when remaining in the loop. **[UNOFFICIAL | ASSERTION]** [Every, 2026-09-01](https://every.to/vibe-check/fable-5-1-vibe-check).

### Recommendation for fable-max

Use this decision rule:

- `medium`: default for bounded implementation, review, and research after a project eval confirms parity.
- `high`: default for unfamiliar repositories, judgment-heavy work, or when a human is monitoring.
- `xhigh`: long autonomous work where a prior `high` attempt failed for reasoning depth.
- `max`: exception path only, with a hard time, token, and subagent budget.
- `low`: inexpensive routing, extraction, and mechanically verifiable work. Explicitly require search when freshness matters.

Anthropic says effort names do not map to the same thinking amounts as Fable 5, recommends starting at `high`, and says `medium` roughly matches Fable 5 at lower cost. **[OFFICIAL | ASSERTION]** [Anthropic prompting guide, accessed 2026-09-02](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1).

---

## 2. Long-horizon coding and agent behavior

### Demonstrated positive reports

Every tested 5.1 for approximately one week:

- Kieran Klaassen rebuilt Every's Proof editor from one prompt and found the result deeper and more opinionated than the Fable 5 attempt. A screenshot was provided. **[UNOFFICIAL | DEMONSTRATED]** [Every, 2026-09-01](https://every.to/vibe-check/fable-5-1-vibe-check).
- Mike Taylor moved a blog from Webflow in one prompt, then generated a 25-character AI-town simulation with memories, routines, conversations, and information spread. A screenshot was provided. **[UNOFFICIAL | DEMONSTRATED]** [Every, 2026-09-01](https://every.to/vibe-check/fable-5-1-vibe-check).
- Kieran ran `xhigh` sessions that lasted about a day. Every reports 1.8 billion tokens processed in one day, but does not publish the raw transcript. **[UNOFFICIAL | DEMONSTRATED self-report]** [Every, 2026-09-01](https://every.to/vibe-check/fable-5-1-vibe-check).

One Reddit user published aggregate statistics from 51 transcripts:

- 14 parent sessions and 37 subagents.
- 1,192 turns, including 881 Fable 5.1 turns.
- About 1.32 million Fable output tokens and 698,000 reasoning tokens.
- 118.6 million cached Fable tokens.
- Effort mix: 452 `max`, 288 `high`, 101 `xhigh`, and 40 `medium`.
- 2,260 tool calls.

The user called it the best model they had used for intent-to-implementation, but also disclosed unusually strong project scaffolding: a 39,800-character `AGENTS.md` acting as a semantic map to subsystem documentation. No raw transcript archive or repository was linked, so the counts are self-reported rather than independently audited. **[UNOFFICIAL | DEMONSTRATED self-report]** [Reddit OP, handle NOT FOUND in accessible rendering, 2026-09-02](https://www.reddit.com/r/ClaudeAI/comments/1w4zyr5/1st_impressions_i_burned_an_entire_claude_max_20x/).

A separate Reddit practitioner said 5.1 handled a messy context, traced behavior across approximately 40 files, pushed back on an incorrect diagnosis, and answered small questions more concisely. They also found that it needed explicit search instructions for changing web facts and multiple style examples to reproduce a voice. **[UNOFFICIAL | ASSERTION]** [Reddit OP, handle NOT FOUND, 2026-09-01](https://www.reddit.com/r/claude/comments/1w4mrqs/used_fable_51_all_day_heres_whats_actually/).

### Negative or mixed reports

u/stumpyinc wrote:

> "the weird laziness now of only doing part of a task and then wanting to write follow up issues instead of closing something out completely."

They also reported that 5.1 sometimes announced an action and stopped before performing it. **[UNOFFICIAL | ASSERTION]** [stumpyinc mirror, 2026-09-01](https://www.reddit.com/r/Claude_reports/comments/1w4qe34/rclaudeai_fable_51_first_impressions_after_a_few/).

One user supplied a screenshot and said 5.1 spent two hours repeatedly reading the same code without progressing. There is no comparative transcript or exact prompt. **[UNOFFICIAL | DEMONSTRATED screenshot, causal claim ASSERTION]** [Reddit, 2026-09-02](https://www.reddit.com/r/Anthropic/comments/1w4v674/fable_51_keeps_getting_stuck/).

Another user reported a loop in which the lead repeatedly spawned subagents, then edited a file while a reviewer subagent was still inspecting it. Commenter BrennanFlentge added that a simple task made 14 API calls and read more than six million cached tokens, but did not attach raw usage records. **[UNOFFICIAL | ASSERTION]** [ClaudeCode thread, 2026-09-02](https://www.reddit.com/r/ClaudeCode/comments/1w4xyxh/fable_51_is_opus_5_second_face/).

Every encountered a related high-effort control problem. Kieran said that after interrupting a session to ask what it was doing, the model ignored the interruption and continued spawning subagents. **[UNOFFICIAL | ASSERTION]** [Every, 2026-09-01](https://every.to/vibe-check/fable-5-1-vibe-check).

### Operating implication

The model appears capable of materially longer autonomous execution, but "keeps working" is not equivalent to "keeps working efficiently." fable-max should add three independent budgets:

1. Wall-clock deadline.
2. Aggregate token or subscription budget.
3. Maximum active and cumulative subagents.

A progress checkpoint should report completed artifacts, remaining acceptance criteria, current blockers, token use, and active subagents. This recommendation is an inference from the demonstrated long runs and loop reports above.

---

## 3. Prompting and `CLAUDE.md` changes

### Changes supported by both official guidance and practitioner reports

#### A. Force complete delivery

Anthropic explicitly says 5.1 can stop after describing the next action or ask "Shall I apply this?" for work already authorized. Its recommended system instruction begins:

> "You are operating autonomously. The user is not watching in real time and cannot answer questions mid-task..."

It also tells the model to inspect its last paragraph and execute any unfinished plan before ending. **[OFFICIAL | ASSERTION with exact mitigation]** [Anthropic prompting guide, accessed 2026-09-02](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1).

This directly matches u/stumpyinc's partial-task report. **[UNOFFICIAL | ASSERTION]** [stumpyinc, 2026-09-01](https://www.reddit.com/r/Claude_reports/comments/1w4qe34/rclaudeai_fable_51_first_impressions_after_a_few/).

#### B. Require surgical edits

Anthropic says 5.1 is more likely than Fable 5 to rewrite entire files and recommends:

> "The number of tokens used to edit files is best minimized, all else being equal. Therefore, when it will not affect the end result, try to surgically edit a file rather than rewrite the entire thing."

**[OFFICIAL | ASSERTION with exact mitigation]** [Anthropic prompting guide, accessed 2026-09-02](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1).

Reddit commenter u/marfzzz independently suggested:

> "Do not rewrite entire files or modules. Provide targeted patches or unified diffs showing only the modified lines with 3 lines of context."

**[UNOFFICIAL | ASSERTION]** [Reddit usage thread, 2026-09-02](https://www.reddit.com/r/Anthropic/comments/1w5508t/fable_51_is_really_fantastic_but_its_burning/).

#### C. Control scope and test proliferation

Anthropic says 5.1 may fix nearby code, extend unspecified behavior, or commit more tests than requested. It recommends reporting pre-existing bugs rather than fixing them and keeping roughly one focused test per stated behavior where the repository already uses tests. **[OFFICIAL | ASSERTION with measured internal claim]** [Anthropic prompting guide, accessed 2026-09-02](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1).

This conflicts somewhat with CodeRabbit, which found greater restraint under underspecified coding prompts. The likely explanation is workload dependence: CodeRabbit's separate coding demonstrations and Anthropic's internal evaluations were not the same tasks. **[UNOFFICIAL | DEMONSTRATED]** [CodeRabbit, 2026-09-01](https://www.coderabbit.ai/blog/fable-5-1-model-review).

#### D. Batch independent tools

Anthropic says 5.1 may issue implied independent tool calls one per turn in coding and computer-use loops. Its exact nudge is:

> "First privately list what you need next; then request every item that doesn't depend on another's result in this one response."

**[OFFICIAL | ASSERTION with exact mitigation]** [Anthropic prompting guide, accessed 2026-09-02](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1).

#### E. Explicitly trigger search at `low`

Anthropic says `low` searches less frequently than Fable 5 and more often answers from memory. This matches the practitioner who found 5.1 weak on changed web information unless told to search. **[OFFICIAL | ASSERTION and UNOFFICIAL | ASSERTION]** [Anthropic prompting guide, accessed 2026-09-02](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1); [Reddit, 2026-09-01](https://www.reddit.com/r/claude/comments/1w4mrqs/used_fable_51_all_day_heres_whats_actually/).

#### F. Preserve exact history on the API

Fable 5.1 conversations should be append-only, including thinking blocks. For accounts created on or after 2026-08-31, replaying a thinking block after changing its prefix can return HTTP 400 or require `prefix_mismatch_behavior: "drop_block"`. Earlier-turn edits also restart the prompt cache. **[OFFICIAL | DEMONSTRATED API contract]** [Anthropic prompting guide, accessed 2026-09-02](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1).

This matters for custom fable-max API harnesses, but Claude Code manages its own message history.

#### G. Remove inherited style suppressors

Anthropic says 5.1 uses fewer headings, bullets, bold markers, and quotation marks than earlier Claude models. Existing anti-format instructions can overcorrect. It also warns that 5.1 is more likely to reproduce source text without marking it as a quote. **[OFFICIAL | ASSERTION]** [Anthropic prompting guide, accessed 2026-09-02](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1).

HN Anthropic employee Felix Rieseberg said:

> "I think Fable 5.1 is a big improvement in writing style."

He also said it responded more reliably to his style instructions. **[OFFICIAL employee | ASSERTION]** [felixrieseberg, HN launch thread, 2026-09-01](https://news.ycombinator.com/item?id=49525378); [HN profile identifying Anthropic role](https://news.ycombinator.com/user?id=felixrieseberg).

### Suggested compact `CLAUDE.md` addition

The evidence supports adding a compact block like this, then evaluating it on the reader's own repository:

```text
Complete the full requested task before ending. Do not stop after stating a plan
or ask permission for reversible steps already authorized.

Keep changes within the request. Report unrelated bugs as follow-ups. Prefer
surgical edits or targeted patches over rewriting whole files.

Batch independent tool calls. Keep working while independent subagents run, but
do not modify files being actively reviewed by a subagent.

For current or fast-changing facts, search before answering, including at low
effort. Preserve source wording only as clearly marked quotations.

Before finishing, verify the requested behavior, summarize changed files and
tests, and name anything blocked or incomplete.
```

This is an analyst synthesis, not a verbatim Anthropic template.

---

## 4. Plan limits, API cost, and outages

### Subscription reports

u/Creative-Ganache1086 reported that two parallel `max` prompts asking for bug audits exhausted a Max 5x five-hour window in approximately 12 minutes. The same user said GPT-5.6 Sol Max Fast completed both tasks with about a 4 percent weekly-plan reduction. Different providers, harnesses, caches, and quota formulas make this illustrative rather than controlled. **[UNOFFICIAL | DEMONSTRATED screenshot/self-report]** [Reddit, 2026-09-02](https://www.reddit.com/r/Anthropic/comments/1w5508t/fable_51_is_really_fantastic_but_its_burning/).

Another commenter reported asking for an implementation plan for GLM-5.3 and exhausting a Max 5x window in about 27 minutes while using Opus subagents. **[UNOFFICIAL | ASSERTION]** [Reddit warning thread, 2026-09-02](https://www.reddit.com/r/ClaudeCode/comments/1w4qs4p/warning_read_the_fable_51_docs_fable_51_is/).

u/dogecountant posted a screenshot after reviewing merged pull requests and said the session reached its 100 percent marker after about 30 minutes. **[UNOFFICIAL | DEMONSTRATED screenshot]** [Reddit, 2026-09-02](https://www.reddit.com/r/ClaudeCode/comments/1w4x69z/fable_51_review/).

Counterexamples include:

- One commenter said seven hours of continuous work used about 20 percent of Fable allocation and 11 percent of weekly allocation. **[UNOFFICIAL | ASSERTION]** [51-transcript thread, 2026-09-02](https://www.reddit.com/r/ClaudeAI/comments/1w4zyr5/1st_impressions_i_burned_an_entire_claude_max_20x/).
- Another said a high-effort workflow with asset generation remained below 70 percent of the five-hour window and 14 percent weekly. **[UNOFFICIAL | ASSERTION]** [same thread, 2026-09-02](https://www.reddit.com/r/ClaudeAI/comments/1w4zyr5/1st_impressions_i_burned_an_entire_claude_max_20x/).
- A user reported Fable 5.1 `low` using 24 percent of the five-hour allowance in 20 minutes, with screenshots, but said the initial context load was disproportionately expensive and later cache reuse improved the rate. **[UNOFFICIAL | DEMONSTRATED screenshot]** [Anthropic launch thread, 2026-09-01](https://www.reddit.com/r/Anthropic/comments/1w4juwx/introducing_claude_fable_51_and_claude_mythos_51/).

### Official explanation

Anthropic's developer account said:

> "In Claude Code, cache reads count at a reduced rate toward subscription usage, which remains unchanged."

It also said long API-billed sessions could be 25 to 45 percent cheaper and reset users' five-hour and weekly limits at launch. **[OFFICIAL | ASSERTION and observable account action]** [Claude Developers X mirror, 2026-09-01](https://twstalker.com/ClaudeDevs).

Anthropic employee CJ Avilla separately wrote that 5.1 cache reads were already discounted against subscription limits and that overall Max usage "should be overall ~same as Fable 5." **[OFFICIAL employee | ASSERTION]** [CJ Avilla X mirror, 2026-09-01](https://w.twstalker.com/cjav_dev).

### Outages

There was no official launch-day Fable 5.1 core-inference outage recorded. Anthropic did record:

- Degraded `platform.claude.com`, documentation, and Microsoft Office behavior from 17:05 to 18:07 UTC on 2026-09-01. The status page explicitly said core inference and API were unaffected.
- Delayed availability of newly purchased credits from 12:10 to 21:35 UTC, causing erroneous "credit balance is too low" API errors.
- A Claude Code web, Slack, and Code Review incident on 2026-08-31.

**[OFFICIAL | DEMONSTRATED]** [Anthropic status history, 2026-08-31 to 2026-09-01](https://anthropic.statuspage.io/).

Therefore, the launch-day reports of fast quota consumption should not be described as a confirmed Fable inference outage. Some apparent failures may have been credit or front-end incidents, but that causal link is **NOT FOUND**.

---

## 5. Safeguards, refusals, and fallback behavior

### Evidence that safeguards improved

Every says Dan Shipper could run security work that Fable refused in June, and both Dan and Kieran saw fewer ordinary-engineering false positives. Kieran's single reported refusal involved logging into a test environment with a test password. **[UNOFFICIAL | ASSERTION]** [Every, 2026-09-01](https://every.to/vibe-check/fable-5-1-vibe-check).

HN user nottorp said an earlier project had been rejected because "virology" appeared in Git history, while 5.1 could use it without a first-prompt rejection. **[UNOFFICIAL | ASSERTION]** [HN launch thread, 2026-09-01](https://news.ycombinator.com/item?id=49525378).

Anthropic's developer account claimed cyber fallback rates had fallen approximately 40 percent relative to current Fable 5 and 55 percent relative to the initial Fable 5 deployment. **[OFFICIAL | ASSERTION]** [Claude Developers X mirror, 2026-09-01](https://twstalker.com/ClaudeDevs).

### Current false-positive reports

- @kylebrussell said a "military campaign" metaphor adopted during theoretical math work triggered cyber safeguards. Exact excerpt: "Day One safeguards for Fable 5.1 have been more annoying so far." **[UNOFFICIAL | ASSERTION]** [X mirror, 2026-09-01](https://mobile.twstalker.com/kylebrussell).
- @GregKamradt reportedly could not complete an evaluation because version-three requests were interpreted as reverse engineering. **[UNOFFICIAL | ASSERTION reported through newsletter]** [Latent Space, 2026-09-02](https://www.latent.space/p/ainews-claude-fablemythos-51-new); [original X URL](https://x.com/GregKamradt/status/2094894689325560172).
- HN user rplnt said basic signed-cookie REST work was flagged as cryptography. **[UNOFFICIAL | ASSERTION]** [HN launch thread, 2026-09-01](https://news.ycombinator.com/item?id=49525378).
- HN user elevation said a Windows-to-Linux port proceeded until it reached authentication code, then refused. **[UNOFFICIAL | ASSERTION]** [HN launch thread, 2026-09-01](https://news.ycombinator.com/item?id=49525378).
- Several Reddit users claiming biotechnology, pharmacokinetic, and nursing work reported forced downgrade behavior or stricter responses. No transcripts or request IDs were supplied. **[UNOFFICIAL | ASSERTION]** [Reddit practitioner thread, 2026-09-01](https://www.reddit.com/r/claude/comments/1w4mrqs/used_fable_51_all_day_heres_whats_actually/).

### Workarounds supported by Anthropic

Anthropic identifies three false-positive triggers and mitigations:

- Ask "Are there any bugs in this program?" instead of compile-check wording.
- Explain unfamiliar programming languages and supply their documentation.
- Remove base64-encoded tool output from context.

**[OFFICIAL | ASSERTION]** [Anthropic prompting guide, accessed 2026-09-02](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1).

For monitoring, the strongest public implementation evidence is still the earlier Fable 5 issue from luckymikey999-coder. It includes nine request IDs, the `model_refusal_fallback` transcript event, and a cron watcher that greps session logs and sends an alert. **[UNOFFICIAL | DEMONSTRATED, Fable 5 baseline rather than 5.1]** [GitHub issue #76518, 2026-07-10](https://github.com/anthropics/claude-code/issues/76518).

Whether 5.1 still pins a Claude Code session to the fallback model after the triggering turn is **NOT FOUND**.

---

## 6. Quantitative comparisons

### Fable 5.1 vs Fable 5

CodeRabbit tested 45 review tasks covering 105 known issues:

| Model | Recall | Precision | Final comments | Nitpick comments | Time/task |
|---|---:|---:|---:|---:|---:|
| Fable 5 | 61.9% | 32.8% | 253 | 265 | 12:32 |
| Fable 5.1 | 61.0% | 37.3% | 166 | 79 | 18:38 |

5.1 produced 34.4 percent fewer final comments and 70.2 percent fewer nitpicks, but took 48.7 percent longer. CodeRabbit warns that the two runs used different pipeline versions, so this is directional, not a clean same-day head-to-head. **[UNOFFICIAL | DEMONSTRATED]** [CodeRabbit, 2026-09-01](https://www.coderabbit.ai/blog/fable-5-1-model-review).

Atomic Agent used the same three prompts and reported $7.65 for Fable 5 versus $7.08 for 5.1, a 7.5 percent saving. It says the long task produced the saving while the short tasks converged. One run per model is too small to establish an average. **[UNOFFICIAL | DEMONSTRATED]** [Atomic Agent, 2026-09-01](https://atomicagent.io/blog/claude-fable-5-1/); [GapNew4766, Reddit, 2026-09-02](https://www.reddit.com/r/AI_Agents/comments/1w4uqxn/for_agent_loops_the_cache_read_discount_is_the/).

### Fable 5.1 vs Opus 5

Every ran both models at `medium` using prompts tuned for Opus 5. Marcus judged task completion comparable, while 5.1 used under half the tokens and about 60 percent of the time. However, he warned that 5.1 "can perform worse on heavy multi-tool tasks." **[UNOFFICIAL | DEMONSTRATED internal test, raw table not publicly downloadable]** [Every, 2026-09-01](https://every.to/vibe-check/fable-5-1-vibe-check).

CodeRabbit's cross-snapshot review results were:

- Fable 5.1: 61.0 percent recall, 37.3 percent precision, 166 comments.
- Opus 5: 55.2 percent recall, 39.3 percent precision, 166 comments.

CodeRabbit explicitly warns against reading the table as one leaderboard because configurations and pipeline snapshots differed. **[UNOFFICIAL | DEMONSTRATED]** [CodeRabbit, 2026-09-01](https://www.coderabbit.ai/blog/fable-5-1-model-review).

### Fable 5.1 vs GPT-5.6 Sol

Artificial Analysis numbers relayed by Latent Space were:

| Model and effort | Intelligence Index | Average cost/task | Reported output tokens |
|---|---:|---:|---:|
| Fable 5.1 `max` | 66 | $3.69 to $3.76 | 140M |
| Fable 5 `max` | 62 | $3.14 | 83M |
| GPT-5.6 Sol `max` | 61 | $0.95 | 70M |

The spread reflects slightly different snapshots or calculations quoted in the newsletter. Fallback reportedly accounted for about 4 percent of 5.1 output tokens. **[UNOFFICIAL | DEMONSTRATED secondary reporting]** [Latent Space, 2026-09-02](https://www.latent.space/p/ainews-claude-fablemythos-51-new); [Artificial Analysis X post, 2026-09-01](https://x.com/ArtificialAnlys/status/2094881171066978525).

Every's writing bench found Fable 5.1 strongest at extending long-form arguments and GPT-5.6 Sol strongest at compression and short X-style posts. 5.1 outputs were reportedly one reading grade below Fable 5 and two below Sol. **[UNOFFICIAL | DEMONSTRATED internal bench]** [Every, 2026-09-01](https://every.to/vibe-check/fable-5-1-vibe-check).

CodeRabbit's non-comparable snapshots showed Sol with higher recall, 69.7 versus 61.0 percent, but lower precision, 31.6 versus 37.3 percent. Sol's 231 count was raw model comments, while Fable's 166 count was processed output, making direct volume comparison invalid. **[UNOFFICIAL | DEMONSTRATED]** [CodeRabbit, 2026-09-01](https://www.coderabbit.ai/blog/fable-5-1-model-review).

### Fable 5.1 vs Gemini 3.1 Pro

I found benchmark aggregators, but no credible practitioner-controlled Claude Code comparison dated 2026-08-25 or later.

AI Benchy lists Gemini 3.1 Pro Preview `medium` at score 9.2 and $1.352 versus Fable 5.1 `high` at score 9.0 and $3.364. Its detailed task set and judging reliability require separate validation. **[UNOFFICIAL | DEMONSTRATED aggregator, methodology not audited here]** [AI Benchy, updated 2026-09-02](https://aibenchy.com/compare/anthropic-claude-fable-5-1-high/google-gemini-3-1-pro-preview-medium/).

A release tracker claims Fable leads several published benchmarks, but appears to combine vendor-reported numbers rather than a shared independent run. **[UNOFFICIAL | ASSERTION from aggregated vendor metrics]** [AI Release Tracker, accessed 2026-09-02](https://aireleasetracker.com/compare/anthropic/claude-fable-5.1/google/gemini-3.1-pro).

**Practitioner head-to-head in Claude Code: NOT FOUND.**

---

## 7. Writing, research, and factual reliability

Every found that 5.1:

- Produced clearer prose and fewer perceived AI tells.
- Scored best on its missing-passage long-form task.
- Performed poorly on its short X-post task relative to Sol.
- Continued to exceed requested word counts.
- Produced 43 purported quotes after being asked for 8 to 12, with several absent from the source material.

**[UNOFFICIAL | DEMONSTRATED internal bench]** [Every, 2026-09-01](https://every.to/vibe-check/fable-5-1-vibe-check).

Every's most decision-relevant conclusion is that 5.1 can be a strong source-bound drafter and a risky reporter when allowed to elaborate. Its article says:

> "It can see the edit; it just doesn't trust itself enough to show you, which is the reverse of its drafting problem."

**[UNOFFICIAL | DEMONSTRATED internal editing test]** [Every, 2026-09-01](https://every.to/vibe-check/fable-5-1-vibe-check).

Anthropic independently warns that 5.1 more readily reproduces retrieved text without marking it as quotation and recommends adding a full worked example of correct paraphrasing and quotation. **[OFFICIAL | ASSERTION]** [Anthropic prompting guide, accessed 2026-09-02](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1).

For fable-max research workflows, require a quote audit that checks each exact quote against source text before delivery. The Every result makes this a release-critical update.

---

## 8. `/goal`, unattended, and overnight operation

### What was found

Every documented day-long `xhigh` sessions, enormous token volume, one-shot builds, and long delegated programming work. These were unattended or lightly monitored agent sessions, but Every did not identify them as Claude Code `/goal` runs or publish complete transcripts. **[UNOFFICIAL | DEMONSTRATED self-report]** [Every, 2026-09-01](https://every.to/vibe-check/fable-5-1-vibe-check).

A commenter in the ClaudeAI release hub said they left the model working through a ticket list overnight, returned to a completed milestone, and then assigned another. The accessible search rendering did not preserve the commenter's handle or raw logs. **[UNOFFICIAL | ASSERTION, handle NOT FOUND]** [ClaudeAI release hub, 2026-09-01](https://www.reddit.com/r/ClaudeAI/comments/1w4qgue/fable_51_and_mythos_51_release_discussion_hub/).

A claude-skills commenter said the cache-read reduction looked attractive for goal prompts but had only begun evaluations and posted no result. **[UNOFFICIAL | ASSERTION]** [Reddit, 2026-09-01](https://www.reddit.com/r/claudeskills/comments/1w4ke3e/fable_51_vs_fable_5/).

### What was not found

- Raw `/goal` transcript for a 5.1 overnight run: **NOT FOUND**.
- Controlled Fable 5 versus 5.1 `/goal` completion comparison: **NOT FOUND**.
- Failure rate across multiple unattended runs: **NOT FOUND**.
- Evidence that automatic continuation reliably resumes after plan exhaustion: **NOT FOUND**.
- Reproduction of @kimmonismus's claim that automatic continuation is broken: **NOT FOUND**. The exact public assertion was: "Fable’s automatic continuation is bugged and doesn’t even work." **[UNOFFICIAL | ASSERTION]** [X mirror, 2026-09-01](https://ngntipkolamrenang.twstalker.com/kimmonismus).

### Provisional overnight checklist

Until better evidence exists:

- Use `high` before `xhigh`.
- State acceptance tests and stop conditions.
- Add hard limits for aggregate tokens, retries, and subagents.
- Require checkpoint commits or recoverable artifacts.
- Log returned model IDs and fallback events.
- Make the lead continue useful work while independent subagents run.
- Instruct the agent to finish reversible steps without waiting for permission.
- Add a final independent verifier pass.

---

## 9. GitHub issues and regressions

### Anthropic repositories

A search of `anthropics/claude-code` and the Anthropic Agent SDK repositories found **no 5.1-specific issue with a public reproduction of model-quality regression** as of 2026-09-02.

The closest launch-day issue is #91284. Reporter ShlackBaum says Fable 5.1 requires a newer Claude Code release, but their Windows environment remains pinned because previous versions silently lost session transcripts. The issue supplies detailed reproduction history and says a full day across three sessions was lost. This is an upgrade blocker, not evidence that 5.1 caused the bug. **[UNOFFICIAL | DEMONSTRATED]** [GitHub #91284, 2026-09-01](https://github.com/anthropics/claude-code/issues/91284).

Older issues worth retaining as regression probes, but not labeling 5.1 failures:

- Fable 5 routine web work triggered cyber fallback eight times, with nine request IDs and transcript evidence. **[UNOFFICIAL | DEMONSTRATED, old model]** [#76518, 2026-07-10](https://github.com/anthropics/claude-code/issues/76518).
- Agent SDK `subscription_oauth` could return HTTP 200 while serving a model different from the one requested; the reporter detected it through `result.modelUsage`. **[UNOFFICIAL | DEMONSTRATED, old SDK behavior]** [Agent SDK TypeScript #355, 2026-06-23](https://github.com/anthropics/claude-agent-sdk-typescript/issues/355).
- Other older reports cover incorrect context-window display, silent model switching, lost background-agent text, and subagent model-selection ambiguity. Their 5.1 status is **NOT FOUND**.

### Third-party compatibility

CLIProxyAPI issue #5402 reported that v7.2.147 did not recognize the 5.1 provider/model and returned an `invalid_request` error. This is a third-party routing compatibility issue, not an Anthropic model bug. **[UNOFFICIAL | DEMONSTRATED]** [CLIProxyAPI #5402, 2026-09-01](https://github.com/router-for-me/CLIProxyAPI/issues/5402).

---

## 10. Anthropic staff statements on HN and X

### Hacker News

Felix Rieseberg, whose HN profile identifies him as Anthropic's head of Claude.ai engineering, said 5.1 had a more natural writing style and followed style instructions more reliably. **[OFFICIAL employee | ASSERTION]** [launch thread, 2026-09-01](https://news.ycombinator.com/item?id=49525378); [profile](https://news.ycombinator.com/user?id=felixrieseberg).

The HN thread also contained practitioner claims that:

- 5.1 reasoned at least seven times longer than Fable 5 `max` during a limited two-hour project test. **[UNOFFICIAL | ASSERTION, @glub]** [HN, 2026-09-01](https://news.ycombinator.com/item?id=49525378).
- Fable 5.1 `high` or `xhigh` could offer a better price-performance point than 5.1 `max`, based on Artificial Analysis results. **[UNOFFICIAL | DEMONSTRATED secondary interpretation, @nsingh2]** [HN, 2026-09-01](https://news.ycombinator.com/item?id=49525378).
- Artificial Analysis's higher total 5.1 evaluation cost might partly reflect fewer cheaper Opus fallback turns, rather than only more expensive native completion. **[UNOFFICIAL | ASSERTION, @dannyw]** [HN, 2026-09-01](https://news.ycombinator.com/item?id=49525378).

Because direct HN rendering was intermittent, I cross-checked indexed copies at [paulowe.com](https://paulowe.com/hn/49525378), [mulan.sh](https://www.mulan.sh/hn/items/49525378), and [gaojixiao.com](https://gaojixiao.com/item?id=49525378), all accessed 2026-09-02.

### X

The official Claude Developers account said 5.1:

> "gets a lot further into a long task before it needs your input, is better at telling you when it's stuck, and its writing style is more natural."

**[OFFICIAL | ASSERTION]** [X mirror, 2026-09-01](https://www30.twstalker.com/ClaudeDevs/status/2094851238219403582).

Anthropic's CJ Avilla confirmed mid-conversation effort changes, tool changes, and system messages for 5.1. He also advised users with unexpected safeguard triggers to inspect skills and `CLAUDE.md` files for security-research context loaded at initialization. **[OFFICIAL employee | ASSERTION]** [X mirror, 2026-09-01](https://w.twstalker.com/cjav_dev).

Mike Krieger said:

> "Give it a target and it works until it gets there, and when it's stuck it says so instead of reporting success."

**[OFFICIAL employee | ASSERTION]** [Claude feed mirror, 2026-09-01](https://clauder-navi.com/claude-feed).

Boris Cherny highlighted the $0.25 cache-read price and claimed up to 38 percent lower cost for a typical Claude Code session. **[OFFICIAL employee | ASSERTION]** [Claude feed mirror, 2026-09-01](https://clauder-navi.com/claude-feed).

Direct X pages returned access errors during this research. Quotes were verified through indexed mirrors and Latent Space's link-preserving digest. This limitation reduces confidence in reply ordering and deleted-post status, but not in the captured text.

---

## 11. Pre-release and leaked-access story

daily.dev's accessible page verifies that the headline existed:

> "Claude Fable 5.1 is already live for some users before Anthropic said a word"

The page exposed "Last updated Today" and a claim of 68 sources, but no accessible author, article body, screenshots, requests, or source list. **[UNOFFICIAL | ASSERTION only]** [daily.dev, accessed 2026-09-02](https://preview3.app.daily.dev/posts/claude-fable-5-1-is-already-live-for-some-users-before-anthropic-said-a-word-ylqmkv8yy).

The August 27 Reddit thread reported:

- More concise two-to-three-sentence answers.
- A user obtaining a claimed "Fable 5.1 session" after repeatedly asking the model about its identity.
- Suspected stealth routing.
- A counterpoint that the harness had changed twice in four days.

No server-returned model ID, API response, release artifact, or account UI screenshot conclusively demonstrates that Fable 5.1 weights were served. Model self-identification is not reliable evidence. **[UNOFFICIAL | ASSERTION]** [Reddit, 2026-08-27](https://www.reddit.com/r/ClaudeAI/comments/1w05cv6/did_anthropic_release_fable_51/).

Axios reported on August 19 that Anthropic was testing a successor across some accounts, but did not establish that general users were knowingly receiving the final 5.1 model. **[UNOFFICIAL news report | ASSERTION from unnamed sources]** [Axios, 2026-08-19](https://www.axios.com/2026/08/19/ai-models-astra-mythos-release-rumors).

### What held up

- A 5.1 release was imminent: held up.
- Some kind of pre-release testing existed: supported by Axios and Every's week-long early access.
- Public users were definitely being stealth-routed to final Fable 5.1 before announcement: **NOT FOUND**.
- The brief style shift proved 5.1 routing: **NOT SUPPORTED**.
- daily.dev's "already live" wording: **NOT VERIFIED from its accessible evidence**.

---

## 12. Contradictions and likely explanations

### "Much cheaper" vs "more expensive"

- Every measured less than half Opus 5's tokens on comparable `medium` agent tasks. **[UNOFFICIAL | DEMONSTRATED]** [Every, 2026-09-01](https://every.to/vibe-check/fable-5-1-vibe-check).
- Artificial Analysis measured Fable 5.1 `max` approximately 20 percent more expensive per task than Fable 5 `max`. **[UNOFFICIAL | DEMONSTRATED secondary report]** [Latent Space, 2026-09-02](https://www.latent.space/p/ainews-claude-fablemythos-51-new).
- Atomic Agent measured only 7.5 percent savings. **[UNOFFICIAL | DEMONSTRATED]** [Atomic Agent, 2026-09-01](https://atomicagent.io/blog/claude-fable-5-1/).

**Resolution:** Cache reads and tokens per step are cheaper, but `max`, long reasoning, additional output, and subagent proliferation can increase the number and size of steps.

### "More restrained" vs "scope creep"

- CodeRabbit found 5.1 stopped at stated requirements when details were omitted. **[UNOFFICIAL | DEMONSTRATED]** [CodeRabbit, 2026-09-01](https://www.coderabbit.ai/blog/fable-5-1-model-review).
- Anthropic warns of nearby fixes, unrequested extensions, and excess tests. **[OFFICIAL | ASSERTION]** [prompting guide, accessed 2026-09-02](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1).
- Every praised useful details that were not requested. **[UNOFFICIAL | DEMONSTRATED]** [Every, 2026-09-01](https://every.to/vibe-check/fable-5-1-vibe-check).

**Resolution:** "Useful initiative" and "scope creep" are the same behavior under different acceptance criteria. State permitted initiative explicitly.

### "Works until done" vs "stops early"

- Anthropic staff and Every describe unusually persistent execution. **[OFFICIAL | ASSERTION; UNOFFICIAL | DEMONSTRATED]** [Claude Developers mirror, 2026-09-01](https://twstalker.com/ClaudeDevs); [Every, 2026-09-01](https://every.to/vibe-check/fable-5-1-vibe-check).
- Anthropic's prompt guide and Reddit users document premature stopping and permission requests. **[OFFICIAL | ASSERTION; UNOFFICIAL | ASSERTION]** [prompting guide, accessed 2026-09-02](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1); [stumpyinc, 2026-09-01](https://www.reddit.com/r/Claude_reports/comments/1w4qe34/rclaudeai_fable_51_first_impressions_after_a_few/).

**Resolution:** Clear-goal autonomous runs and ambiguous human-in-the-loop turns likely trigger different stopping behavior. Anthropic's recommended autonomous-delivery prompt should be part of unattended configurations.

### "Safeguards fixed" vs continuing refusals

- Official rate claims and several practitioners indicate fewer false positives. **[OFFICIAL | ASSERTION; UNOFFICIAL | ASSERTION]** [Claude Developers mirror, 2026-09-01](https://twstalker.com/ClaudeDevs); [Every, 2026-09-01](https://every.to/vibe-check/fable-5-1-vibe-check).
- Current math, reverse-engineering, authentication, cookie, and medical reports show remaining false positives. **[UNOFFICIAL | ASSERTION]** [Kyle Russell mirror, 2026-09-01](https://mobile.twstalker.com/kylebrussell); [HN, 2026-09-01](https://news.ycombinator.com/item?id=49525378).

**Resolution:** A relative rate reduction does not imply elimination, and trigger rates vary sharply by domain and context loaded through skills or repository files.

### "Normal plan usage" vs five-hour window gone in minutes

- Anthropic staff said overall Max usage should be roughly the same as Fable 5. **[OFFICIAL | ASSERTION]** [CJ Avilla mirror, 2026-09-01](https://w.twstalker.com/cjav_dev).
- Multiple screenshots and reports show very rapid launch-day consumption. Other users report modest burn. **[UNOFFICIAL | mixed DEMONSTRATED and ASSERTION]** [Anthropic usage thread, 2026-09-02](https://www.reddit.com/r/Anthropic/comments/1w5508t/fable_51_is_really_fantastic_but_its_burning/); [51-transcript report, 2026-09-02](https://www.reddit.com/r/ClaudeAI/comments/1w4zyr5/1st_impressions_i_burned_an_entire_claude_max_20x/).

**Resolution:** "Overall" is not a guaranteed workload-specific rate. Initial context, cache state, effort, parallelism, subagent model choice, and quota display timing all matter.

---

## 13. Source-sweep ledger

### Substantive evidence found

- Hacker News launch and reply threads: **FOUND**.
- r/ClaudeAI: **FOUND, extensive**.
- r/ClaudeCode: **FOUND, extensive**.
- r/Anthropic: **FOUND, extensive**.
- r/LocalLLaMA: release discussion found, but **no substantive operator evidence**.
- r/singularity: release discussion found, but **no substantive operator evidence**.
- r/cursor: **no credible Fable 5.1 practitioner report found**.
- X/Twitter: **FOUND through mirrors and newsletter indexing; direct X access blocked**.
- Personal blogs: Simon Willison, Atomic Agent, CodeRabbit, Every: **FOUND**.
- Anthropic Claude Code GitHub: **no 5.1 model-regression reproduction found**.
- Anthropic Agent SDK GitHub: **no 5.1-specific issue found**.
- Third-party GitHub compatibility: **FOUND**.
- Independent Discord summaries: **NOT FOUND**. Latent Space explicitly reported no additional Discord sources in its sweep.
- `/goal` raw transcripts: **NOT FOUND**.
- Reproducible overnight comparison: **NOT FOUND**.

### Named newsletters and sites

- latent.space: **FOUND**, substantive digest with original X links.
- the-decoder: **FOUND**, primarily official-claim reporting rather than practitioner testing.
- daily.dev: **FOUND**, pre-release headline but inaccessible underlying evidence.
- Simon Willison: **FOUND**, controlled effort sweep.
- roo.beehiiv: **NOT FOUND** for a dated substantive 5.1 practitioner report.
- aidailycheck: **NOT FOUND**.
- knightli: **NOT FOUND**.
- kenhuangus Substack: **NOT FOUND**.
- wavect.io: **NOT FOUND**.
- Medium: **no substantive controlled report found**.
- Alex McFarland Substack: found, but the author explicitly said it was not yet a review, so it was excluded as practitioner evidence.
- Handyai Substack: found, but mostly repeated announcement and model-card claims, so it was excluded from the practitioner conclusions.

---

## 14. Recommended fable-max update

The evidence supports changing the guide as follows:

1. Default to `high`, not `max`.
2. Add a required per-repository effort sweep, including `medium`.
3. Require explicit freshness/search instructions at `low`.
4. Add hard aggregate budgets for subagents, retries, wall time, and output tokens.
5. Add the autonomous completion instruction for unattended work.
6. Add surgical-edit and strict-scope instructions.
7. Batch independent tools and keep the lead productive while subagents run.
8. Prevent the lead from editing a file currently assigned to a reviewer subagent.
9. Preserve API histories byte-for-byte and append-only.
10. Log actual returned model, fallback events, effort, cache reads, reasoning tokens, subagent count, and task result.
11. Treat every exact quote as untrusted until checked against source text.
12. Keep `/goal` and overnight claims labeled experimental until raw 5.1 runs exist.
13. Separate "cost per model step" from "cost per completed task" in every evaluation.
14. Remove inherited anti-formatting rules unless the desired output really requires minimal structure.
15. Retest security-sensitive repositories with neutral, precise terminology and without base64 tool output.

---

# Full source list

## Official Anthropic sources

1. Anthropic, [Fable 5.1 model overview](https://platform.claude.com/docs/en/models/fable-5-1/overview), 2026-09-01.
2. Anthropic, [Prompting Claude Fable 5.1](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02.
3. Anthropic, [Why Claude switched models with Fable](https://support.claude.com/en/articles/15363606-why-claude-switched-models-in-your-conversation-with-fable-5-or-fable-5-1), accessed 2026-09-02.
4. Anthropic, [Fable models on your plan](https://support.claude.com/en/articles/15424964-claude-fable-models-on-your-plan), updated 2026-09-02.
5. Anthropic, [Claude Code model configuration](https://support.claude.com/en/articles/11940350-claude-code-model-configuration), updated 2026-09-02.
6. Anthropic, [service status](https://anthropic.statuspage.io/), incidents dated 2026-08-31 and 2026-09-01.
7. Claude Developers, [X mirror](https://twstalker.com/ClaudeDevs), 2026-09-01.
8. CJ Avilla, [X mirror](https://w.twstalker.com/cjav_dev), 2026-09-01.
9. Anthropic staff feed mirror, [Claude feed](https://clauder-navi.com/claude-feed), 2026-09-01.
10. Felix Rieseberg, [HN profile](https://news.ycombinator.com/user?id=felixrieseberg), accessed 2026-09-02.

## Hacker News

11. [Fable 5.1 launch thread](https://news.ycombinator.com/item?id=49525378), 2026-09-01.
12. [paulowe.com HN mirror](https://paulowe.com/hn/49525378), accessed 2026-09-02.
13. [mulan.sh HN mirror](https://www.mulan.sh/hn/items/49525378), accessed 2026-09-02.
14. [gaojixiao.com HN mirror](https://gaojixiao.com/item?id=49525378), accessed 2026-09-02.

## Independent tests and newsletters

15. Simon Willison, [Claude Fable 5.1 effort tests](https://simonwillison.net/2026/Sep/1/claude-fable-5-1/), 2026-09-01.
16. Katie Parrott and Dan Shipper, [Every Vibe Check](https://every.to/vibe-check/fable-5-1-vibe-check), 2026-09-01.
17. Dan Shipper, [X-post mirror](https://zamantika.com/hi/danshipper/status/2094848951568474186), 2026-09-01.
18. Juan Pablo Flores and Gowtham Kishore Vijay, [CodeRabbit review](https://www.coderabbit.ai/blog/fable-5-1-model-review), 2026-09-01.
19. Nadya Dudka and Andrew Dyuzhov, [Atomic Agent](https://atomicagent.io/blog/claude-fable-5-1/), 2026-09-01.
20. Latent Space, [AI News Fable and Mythos 5.1 digest](https://www.latent.space/p/ainews-claude-fablemythos-51-new), 2026-09-02.
21. AI Benchy, [Fable 5.1 vs Gemini 3.1 Pro](https://aibenchy.com/compare/anthropic-claude-fable-5-1-high/google-gemini-3.1-pro-preview-medium/), updated 2026-09-02.
22. AI Release Tracker, [Fable 5.1 vs Gemini 3.1 Pro](https://aireleasetracker.com/compare/anthropic/claude-fable-5.1/google/gemini-3.1-pro), accessed 2026-09-02.

## Reddit

23. [Used Fable 5.1 all day](https://www.reddit.com/r/claude/comments/1w4mrqs/used_fable_51_all_day_heres_whats_actually/), 2026-09-01.
24. [Anthropic launch thread](https://www.reddit.com/r/Anthropic/comments/1w4juwx/introducing_claude_fable_51_and_claude_mythos_51/), 2026-09-01.
25. [ClaudeAI release discussion hub](https://www.reddit.com/r/ClaudeAI/comments/1w4qgue/fable_51_and_mythos_51_release_discussion_hub/), 2026-09-01.
26. [51-transcript Max 20x report](https://www.reddit.com/r/ClaudeAI/comments/1w4zyr5/1st_impressions_i_burned_an_entire_claude_max_20x/), 2026-09-02.
27. u/GapNew4766, [Atomic-agent cache comparison](https://www.reddit.com/r/AI_Agents/comments/1w4uqxn/for_agent_loops_the_cache_read_discount_is_the/), 2026-09-02.
28. [Fable 5.1 usage burn thread](https://www.reddit.com/r/Anthropic/comments/1w5508t/fable_51_is_really_fantastic_but_its_burning/), 2026-09-02.
29. [Fable 5.1 still too expensive](https://www.reddit.com/r/Anthropic/comments/1w5421c/fable_51_is_still_too_expensive_i_dont_see_any/), 2026-09-02.
30. [Fable 5.1 stuck rereading](https://www.reddit.com/r/Anthropic/comments/1w4v674/fable_51_keeps_getting_stuck/), 2026-09-02.
31. u/dogecountant, [Fable 5.1 review](https://www.reddit.com/r/ClaudeCode/comments/1w4x69z/fable_51_review/), 2026-09-02.
32. [Fable 5.1 subagent-loop report](https://www.reddit.com/r/ClaudeCode/comments/1w4xyxh/fable_51_is_opus_5_second_face/), 2026-09-02.
33. u/stumpyinc mirror, [first impressions](https://www.reddit.com/r/Claude_reports/comments/1w4qe34/rclaudeai_fable_51_first_impressions_after_a_few/), 2026-09-01.
34. u/___positive___, [prompt-guide warning thread](https://www.reddit.com/r/ClaudeCode/comments/1w4qs4p/warning_read_the_fable_51_docs_fable_51_is/), 2026-09-02.
35. [Claude skills comparison](https://www.reddit.com/r/claudeskills/comments/1w4ke3e/fable_51_vs_fable_5/), 2026-09-01.
36. [Pre-release routing discussion](https://www.reddit.com/r/ClaudeAI/comments/1w05cv6/did_anthropic_release_fable_51/), 2026-08-27.

## X mirrors

37. @kylebrussell, [profile mirror](https://mobile.twstalker.com/kylebrussell), 2026-09-01.
38. @kimmonismus, [profile mirror](https://ngntipkolamrenang.twstalker.com/kimmonismus), 2026-09-01.
39. @theo, [profile mirror](https://www.techtwitter.com/profiles/theo), 2026-09-01.
40. @ArtificialAnlys, [original X URL](https://x.com/ArtificialAnlys/status/2094881171066978525), 2026-09-01.
41. @GregKamradt, [original X URL](https://x.com/GregKamradt/status/2094894689325560172), 2026-09-01.

## GitHub

42. Anthropic Claude Code, [issue #91284](https://github.com/anthropics/claude-code/issues/91284), opened 2026-09-01.
43. Anthropic Claude Code, [issue #76518](https://github.com/anthropics/claude-code/issues/76518), opened 2026-07-10.
44. Anthropic Agent SDK TypeScript, [issue #355](https://github.com/anthropics/claude-agent-sdk-typescript/issues/355), opened 2026-06-23.
45. CLIProxyAPI, [issue #5402](https://github.com/router-for-me/CLIProxyAPI/issues/5402), opened 2026-09-01.

## Pre-release reporting

46. daily.dev, [pre-release page](https://preview3.app.daily.dev/posts/claude-fable-5-1-is-already-live-for-some-users-before-anthropic-said-a-word-ylqmkv8yy), accessed 2026-09-02.
47. Axios, [model-release rumors](https://www.axios.com/2026/08/19/ai-models-astra-mythos-release-rumors), 2026-08-19.