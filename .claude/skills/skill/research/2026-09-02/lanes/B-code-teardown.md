# SkillOpt code teardown at `db46cd9`

## 1. Execution harnesses

### `claude_chat`

The exact command template is:

```text
claude -p
  --output-format json
  --permission-mode <CLAUDE_PERMISSION_MODE, default dontAsk>
  --add-dir <temporary-directory>
  [--model <model>]
  [--setting-sources <CLAUDE_SETTING_SOURCES, default user,project>]
  [--append-system-prompt-file <tmp>/system_prompt.txt]
  [--effort low|medium|high|xhigh|max]
  [--schema <compatibility-tool JSON schema>]
```

The user prompt is sent on stdin; the skill/system prompt is written to `system_prompt.txt` and passed with `--append-system-prompt-file`. It does not create `CLAUDE.md`, install a skill, or append the skill to the user prompt. Attachments are copied into the temporary directory. (`skillopt/model/claude_backend.py:17-25`, `skillopt/model/claude_backend.py:244-278`)

`--schema` is emitted only for the compatibility-tool/structured-message path. On Claude Code 2.1.258, the public flag is `--json-schema`; the repository’s other Claude Code backend already uses that spelling and tests that `--schema` is absent. Thus compatibility-tool calls through `claude_chat` will fail, while ordinary optimizer and SearchQA text calls avoid this flag. (`skillopt/model/claude_backend.py:270-272`, `tests/test_claude_code_backend.py:378-406`)

The compatibility tool schemas are embedded as text with an instruction not to execute them. Assistant/tool history is flattened into the next prompt. Claude Code’s own built-in tools are not explicitly disabled, and user/project settings are loaded, but `dontAsk` usually prevents unapproved operations. (`skillopt/model/claude_backend.py:83-142`, `skillopt/model/claude_backend.py:254-278`)

Each SearchQA turn starts a fresh `claude -p`; only the previous final answer is inserted into the next task prompt. Internal Claude tool events are not retained because output is single-result JSON, not `stream-json`. SkillOpt parses JSON lines from stdout and extracts the final `result` and usage. Its saved trajectory is therefore an application-level conversation, not Claude’s complete internal loop. (`skillopt/model/claude_backend.py:278-294`, `skillopt/envs/searchqa/rollout.py:267-317`)

Timeout is the supplied value or 300 seconds. Model calls default to five retries with sleeps of 1, 2, 4, 8, then 15 seconds. `max_completion_tokens` is ignored. (`skillopt/model/claude_backend.py:278-278`, `skillopt/model/claude_backend.py:309-334`)

The harness is synchronous. SearchQA parallelizes tasks in a thread pool; its adapter defaults to 64 workers, while the shipped SearchQA config overrides this to 24. A target exception or timeout becomes `hard=0`, `soft=0` with a failure reason. If every rollout fails, the batch raises. (`skillopt/envs/searchqa/adapter.py:16-42`, `skillopt/envs/searchqa/rollout.py:351-354`, `skillopt/envs/searchqa/rollout.py:360-493`, `skillopt/envs/searchqa/rollout.py:29-38`)

### Codex optimizer/chat harness

Optimizer calls build:

```text
codex exec --json --ephemeral
  -c approval_policy="<policy>"
  --sandbox <sandbox>
  --skip-git-repo-check
  --cd <working-directory>
  --model <model>
  --output-last-message <tmp>/last_message.txt
  [-c sandbox_workspace_write.network_access=true|false]
  [-c web_search="live"|"disabled"]
  [--profile <profile>]
  [-c model_reasoning_effort="<effort>"]
  [--output-schema <tmp>/schema.json]
  [--image <path>]...
  -
```

The complete system prompt, history, compatibility-tool description, and user request are concatenated and sent on stdin. There is no Codex system-prompt flag or installed skill. `--json` stdout is parsed for `item.completed` and `turn.completed`, while the final answer is read from `--output-last-message`. (`skillopt/model/codex_backend.py:108-210`, `skillopt/model/codex_backend.py:284-377`, `skillopt/model/backend_config.py:347-365`)

Optimizer calls default to five retries, although reflection/update stages commonly request three. Backoff caps at 30 seconds. No timeout is applied when the caller passes `None`, which the optimizer stages do. (`skillopt/model/codex_backend.py:424-473`)

`--ephemeral` means optimizer calls should not persist Codex sessions. Authentication and subscription state are inherited from the CLI process; the code neither reads nor requires `OPENAI_API_KEY`. (`skillopt/model/codex_backend.py:299-315`, `skillopt/model/codex_backend.py:338-347`)

### Codex target exec harness

The skill is rendered as Agent Skill YAML and written to `.agents/skills/skillopt-target/SKILL.md`; the task goes to `task.md`. `prepare_workspace` deletes and recreates the selected work directory, so never point it at a directory containing user work. (`skillopt/model/codex_harness.py:48-74`, `skillopt/model/codex_harness.py:96-118`)

CLI mode builds:

```text
codex exec
  --skip-git-repo-check
  --color never
  -C <work-dir>
  [-p <profile>]
  [-c model_reasoning_effort="<value>"]
  --sandbox <mode>
  [-c approval_policy="<policy>"]
  [-c network/search overrides]...
  [-m <model>]
  [-i <image>]...
  --output-last-message <work-dir>/codex_last_message.txt
  "<prompt telling Codex to read task.md and SKILL.md>"
```

The prompt is an argv argument, not stdin. It forbids asking permission and normally forbids file edits. `data_dirs` are validated but never added to the CLI command, so extra data directories work only through the SDK path. (`skillopt/model/codex_harness.py:701-715`, `skillopt/model/codex_harness.py:1340-1420`)

Defaults are `workspace-write`, approval `never`, network off, web search off, SDK mode `auto`, and one empty-response retry, giving at most two outer attempts. In `auto`, each attempt can try SDK and then CLI. A nonzero CLI exit raises immediately rather than becoming an empty retry. (`skillopt/model/backend_config.py:51-69`, `skillopt/model/backend_config.py:127-133`, `skillopt/model/codex_harness.py:1423-1495`)

SDK mode requests strict `{"answer": string}` output and retains the SDK turn’s full item list. CLI mode does not use `--json`; it saves stdout/stderr and parses textual `user`, `codex`, and `exec` markers into a trace summary capped at 4,000 characters. Multi-turn artifacts are joined with `TURN BREAK`. (`skillopt/model/codex_harness.py:1270-1337`, `skillopt/model/codex_harness.py:319-370`, `skillopt/model/codex_harness.py:383-460`)

Codex 0.146 supports the emitted public flags. Use `gpt-5.6-sol` or `gpt-5.6-terra` explicitly on your account. A bare `gpt-5.6` failure is treated as a generic backend error and retried because the research harness has no unsupported-model fail-fast rule. (`skillopt/model/codex_backend.py:299-346`, `skillopt/model/codex_backend.py:467-473`)

## 2. Optimizer model backend

The default optimizer is Azure OpenAI `gpt-5.5`, not the target CLI. Both optimizer and target default to `openai_chat`. (`configs/_base_/default.yaml:4-10`)

Relevant YAML keys are:

```yaml
model:
  backend:
  optimizer:
  target:
  optimizer_backend:
  target_backend:
  reasoning_effort:
  codex_exec_path:
  codex_exec_profile:
  codex_exec_sandbox:
  codex_exec_reasoning_effort:
  codex_exec_use_sdk:
  codex_exec_network_access:
  codex_exec_web_search:
  codex_exec_approval_policy:
  claude_code_exec_path:
  claude_code_exec_profile:
  claude_code_exec_use_sdk:
  claude_code_exec_effort:
  claude_code_exec_max_thinking_tokens:
```

These are defined in the base config and flattened by the configuration layer. (`configs/_base_/default.yaml:4-25`, `skillopt/config.py:53-66`)

`model.backend: codex` maps both roles to `codex_exec`. `claude_chat` also maps both roles. `claude_code_exec` maps only the target to Claude Code and leaves the optimizer as `openai_chat`, so subscription-only Claude runs must explicitly set `optimizer_backend: claude_code_exec`. (`scripts/train.py:641-684`)

OpenAI-compatible mode supports role-specific environment variables:

```text
OPTIMIZER_OPENAI_COMPATIBLE_BASE_URL
OPTIMIZER_OPENAI_COMPATIBLE_API_KEY
OPTIMIZER_OPENAI_COMPATIBLE_MODEL
OPTIMIZER_OPENAI_COMPATIBLE_TIMEOUT_SECONDS
OPTIMIZER_OPENAI_COMPATIBLE_MAX_TOKENS
OPTIMIZER_OPENAI_COMPATIBLE_TEMPERATURE
```

There are corresponding `TARGET_*` variables and shared `OPENAI_COMPATIBLE_*` fallbacks. The backend calls standard `/chat/completions`; OpenRouter is explicitly intended. Gemini is usable only if its OpenAI-compatible endpoint accepts the standard fields SkillOpt sends. Reasoning effort is not forwarded. (`skillopt/model/openai_compatible_backend.py:1-23`, `skillopt/model/openai_compatible_backend.py:73-121`, `skillopt/model/openai_compatible_backend.py:166-237`)

The trainer does not wire base URL/API key YAML fields for this backend, so set these environment variables before starting Python. (`skillopt/model/openai_compatible_backend.py:364-417`, `skillopt/config.py:53-66`)

## 3. Custom environment interface

A custom adapter must implement `build_train_env`, `build_eval_env`, `rollout`, and `get_task_types`. `setup` and `get_dataloader` are optional; inherited `reflect` invokes the shared optimizer reflection implementation. (`skillopt/envs/base.py:37-56`, `skillopt/envs/base.py:171-276`)

A loader implements `build_train_batch` and `build_eval_batch`. `SplitDataLoader` already implements both, reads `train/`, `val/`, and `test/`, aliases `valid_seen` to `val` and `valid_unseen` to `test`, and loads the first JSON array in each directory. Ratio mode deterministically materializes all three splits. (`skillopt/datasets/base.py:72-145`, `skillopt/datasets/base.py:150-161`, `skillopt/datasets/base.py:225-292`, `skillopt/datasets/base.py:330-407`)

There is no separate scorer class or scorer protocol. `rollout` returns `list[dict]` containing at least string `id`, numeric `hard`, and numeric `soft`. Both are averaged as floats, and `hard` may be continuous. (`skillopt/envs/base.py:216-232`, `skillopt/utils/scoring.py:7-23`)

The template adapter is not working because its rollout deliberately returns zero placeholders. The smallest working implementation to copy is SearchQA’s adapter plus `SearchQADataLoader`. Custom adapters are not dynamically discovered; they must be imported and added to `_ENV_REGISTRY`. (`skillopt/envs/_template/adapter.py:95-128`, `skillopt/envs/searchqa/adapter.py:13-96`, `skillopt/envs/searchqa/dataloader.py:34-42`, `scripts/train.py:43-125`)

Minimal shell-scored adapter, 57 lines:

```python
import json, os, subprocess
from skillopt.datasets.base import SplitDataLoader, BatchSpec
from skillopt.envs.base import EnvAdapter
from skillopt.model import chat_target, get_target_backend
from skillopt.model import azure_openai as deployment
from skillopt.model.codex_harness import (
    prepare_workspace, render_skill_md, run_target_exec,
)

class Loader(SplitDataLoader):
    pass

class ShellScoreEnv(EnvAdapter):
    def __init__(self, split_dir, exec_timeout=120, analyst_workers=4,
                 minibatch_size=8, edit_budget=4):
        self.loader = Loader(split_dir=split_dir, split_mode="split_dir")
        self.exec_timeout = exec_timeout
        self.analyst_workers = analyst_workers
        self.minibatch_size = minibatch_size
        self.edit_budget = edit_budget
        self.failure_only = False

    def setup(self, cfg):
        super().setup(cfg)
        self.loader.setup(cfg)

    def get_dataloader(self):
        return self.loader

    def build_env_from_batch(self, batch: BatchSpec, **kwargs):
        return list(batch.payload or [])

    def build_train_env(self, batch_size, seed, **kwargs):
        return self.build_env_from_batch(
            self.loader.build_train_batch(batch_size, seed))

    def build_eval_env(self, env_num, split, seed, **kwargs):
        return self.build_env_from_batch(
            self.loader.build_eval_batch(env_num, split, seed))

    def rollout(self, items, skill_content, out_dir, **kwargs):
        results = []
        for item in items:
            pred = os.path.join(out_dir, "predictions", str(item["id"]))
            os.makedirs(pred, exist_ok=True)
            if get_target_backend().endswith("_exec"):
                work = os.path.join(pred, "agent")
                prepare_workspace(work_dir=work,
                    skill_md=render_skill_md(skill_content),
                    task_text=item["prompt"])
                answer, _ = run_target_exec(
                    work_dir=work, prompt=item["prompt"],
                    model=deployment.TARGET_DEPLOYMENT,
                    timeout=self.exec_timeout)
            else:
                answer, _ = chat_target(
                    system=skill_content, user=item["prompt"],
                    timeout=self.exec_timeout)
            scored = subprocess.run(
                item["score_cmd"], shell=True, input=answer, text=True,
                capture_output=True, timeout=30, check=True)
            score = float(scored.stdout.strip())
            with open(os.path.join(pred, "conversation.json"), "w") as f:
                json.dump({"messages": [{"role": "assistant",
                    "content": answer}]}, f)
            results.append({"id": str(item["id"]), "hard": score,
                "soft": score, "response": answer,
                "task_description": item["prompt"], "fail_reason": "",
                "n_turns": 1})
        return results

    def get_task_types(self):
        return ["shell_scored"]
```

Register `ShellScoreEnv` in `_ENV_REGISTRY`. Treat `score_cmd` as trusted input because `shell=True` gives it arbitrary local command execution. (`scripts/train.py:43-125`)

## 4. Optimization loop

There are `ceil(train_size / (batch_size * accumulation))` update steps per epoch. Each step rolls out the current skill, reflects, merges/ranks edits, creates a candidate, evaluates the candidate on the selection split, then gates it. (`skillopt/engine/trainer.py:891-920`, `skillopt/engine/trainer.py:1510-1643`)

The gate accepts only `candidate_score > current_score`; it becomes best only when also strictly greater than `best_score`. Ties reject. There is no epsilon, resampling, confidence interval, or statistical noise treatment. Selection results are cached by skill hash. (`skillopt/evaluation/gate.py:189-225`, `skillopt/engine/trainer.py:1041-1046`)

“Learning rate” is the maximum number of skill edits, not a model parameter rate. Constant, linear, cosine, and unlimited value 999 are implemented; linear/cosine evaluate the first point at `1/total_steps`, round to an integer, and clamp to the minimum. (`skillopt/optimizer/scheduler.py:1-12`, `skillopt/optimizer/scheduler.py:27-110`)

The per-epoch rejected buffer stores failure patterns and rejected candidate edits, is included in subsequent reflection prompts, and resets at the next epoch. (`skillopt/engine/trainer.py:1149-1165`, `skillopt/engine/trainer.py:1645-1677`)

Slow update is skipped in epoch 1 except for inserting an empty protected field. From epoch 2 it samples 20 tasks, rolls out previous/current skills, compares outcomes, asks the optimizer for momentum guidance, and by default force-injects it without selection gating. The meta update reuses these comparison pairs and writes optimizer memory, not target instructions. (`skillopt/engine/trainer.py:1730-2027`, `skillopt/engine/trainer.py:2050-2161`, `skillopt/optimizer/meta_skill.py:1-7`)

With the default `longitudinal_pair_policy: mixed`, no top-up occurs. `changed` can scan remaining training tasks and add two target calls per task until enough changed pairs are found. (`configs/_base_/default.yaml:98-102`, `skillopt/engine/trainer.py:260-329`)

Resume is automatic when the same `out_root` contains `runtime_state.json` or history. It restores current/best skills, scores, next step, and scheduler position; there is no separate `--resume` requirement. State/history writes are ordinary JSON writes, not atomic checkpoints. (`skillopt/engine/trainer.py:354-412`, `skillopt/engine/trainer.py:948-1038`)

`best_skill.md` is updated during training, after slow updates, at completion, and after possible final-validation promotion. (`skillopt/engine/trainer.py:1696-1712`, `skillopt/engine/trainer.py:2041-2043`, `skillopt/engine/trainer.py:2163-2166`, `skillopt/engine/trainer.py:2223-2239`)

## 5. Plugins

### `plugins/claude-code`

It installs two slash commands, one skill, one SessionEnd hook, and three scripts. The manifest itself contains only metadata. (`plugins/claude-code/.claude-plugin/plugin.json:1-22`)

- `/skillopt-sleep` executes the runner for `status`, `harvest`, `dry-run`, `run`, `adopt`, `schedule`, or `unschedule`. (`plugins/claude-code/commands/skillopt-sleep.md:1-48`)
- `/skillopt-sleep-handoff` runs the handoff backend, reads pending prompt files, delegates answers to isolated agents, writes replies, and repeats for at most eight rounds. (`plugins/claude-code/commands/skillopt-sleep-handoff.md:1-49`)
- `hooks/on-session-end.sh` runs asynchronously after every session and appends UTC time plus current directory to `~/.skillopt-sleep/session-end.log`; it makes no model call. (`plugins/claude-code/hooks/hooks.json:1-16`, `plugins/claude-code/hooks/on-session-end.sh:1-18`)
- `sleep.sh` is a wrapper, `run-sleep.sh` locates the engine/Python and `exec`s `python -m skillopt_sleep`, and `install-cron.sh` only prints a crontab entry. (`plugins/claude-code/scripts/sleep.sh:1-30`, `plugins/claude-code/scripts/run-sleep.sh:1-79`, `plugins/claude-code/scripts/install-cron.sh:1-30`)
- `skills/skillopt-sleep/SKILL.md` contains operational instructions and does not execute independently. (`plugins/claude-code/skills/skillopt-sleep/SKILL.md:1-48`)

The plugin itself does not modify `~/.claude`. The hook modifies `~/.skillopt-sleep`; an explicitly adopted sleep proposal may later modify a configured skill and project `CLAUDE.md`. (`plugins/claude-code/hooks/on-session-end.sh:10-16`, `skillopt_sleep/staging.py:3021-3154`)

### `plugins/codex`

There are no Codex hooks or slash-command files. It installs one user skill into `~/.agents/skills/skillopt-sleep/SKILL.md`; its shell/PowerShell installers also back up a legacy `~/.codex/prompts/sleep.md`. They print, but do not append, an optional `AGENTS.md` hint. (`plugins/codex/install.sh:6-44`, `plugins/codex/install.ps1:1-52`)

The shared sleep engine does not write `AGENTS.md`; a Codex target skill must be explicitly selected. (`plugins/codex/skills/skillopt-sleep/SKILL.md:16-20`)

## 6. `skillopt_sleep`

Claude harvesting reads `~/.claude/projects/**/*.jsonl`, excluding subagents and headless sessions. Although `~/.claude/history.jsonl` is represented in configuration, the active source dispatcher does not read it: history harvesting is not implemented. Codex harvesting reads only `~/.codex/archived_sessions/*.jsonl`, not active `sessions/`. (`skillopt_sleep/config.py:133-140`, `skillopt_sleep/config.py:175-176`, `skillopt_sleep/harvest_sources.py:16-86`, `skillopt_sleep/harvest.py:325-377`)

Harvest reduces sessions to user prompts, recent final responses, tool names, and touched-file keys. Mine converts these into recurring task records, with optional LLM-produced checks. Replay sends task, current skill, and memory to the target backend, then asks the optimizer/judge for numeric hard/soft scores. Consolidate reflects on failures, proposes bounded skill/memory edits, and accepts only strict held-out improvement. (`skillopt_sleep/harvest.py:231-309`, `skillopt_sleep/mine.py:151-217`, `skillopt_sleep/llm_miner.py:33-173`, `skillopt_sleep/replay.py:30-113`, `skillopt_sleep/consolidate.py:180-308`, `skillopt_sleep/consolidate.py:369-426`)

Proposals go under `<project>/.skillopt-sleep/staging/<date>/` with proposed skill, memory, report, and manifest. Live files change only through `adopt` or explicitly enabled `auto_adopt`; adoption verifies pinned hashes, detects intervening changes, and creates backups. (`skillopt_sleep/staging.py:994-1141`, `skillopt_sleep/staging.py:2820-2906`, `skillopt_sleep/staging.py:3021-3154`, `skillopt_sleep/cli.py:628-779`)

With a real backend, mined prompts, answer excerpts, skill/memory content, replay requests, and reflection prompts leave the machine for the selected CLI/API provider. Codex harvesting applies secret redaction and removes sensitive payload fields; the Claude harvester does not invoke that shared redactor, so transcript content should be reviewed before real runs. (`skillopt_sleep/harvest_codex.py:1-6`, `skillopt_sleep/harvest_codex.py:62-88`, `skillopt_sleep/harvest.py:247-309`, `skillopt_sleep/replay.py:30-55`, `skillopt_sleep/backend.py:480-555`)

## 7. Dependencies and footguns

Core requires Python `>=3.10`, but classifiers and CI cover only 3.10 through 3.12 on Linux. Use Homebrew Python 3.12 for the lowest-surprise macOS setup; 3.13/3.14 are allowed by metadata but untested, while system 3.9 is rejected. (`pyproject.toml:11-23`, `.github/workflows/ci.yml:10-29`)

`run-sleep.sh` searches only `python3.12`, `3.11`, `3.10`, then generic `python3`; it will miss an installation available only as `python3.13` or `python3.14` and may fall onto system 3.9. Set `SKILLOPT_SLEEP_PYTHON` explicitly. (`plugins/claude-code/scripts/run-sleep.sh:29-48`, `plugins/claude-code/scripts/run-sleep.sh:61-74`)

Core installation always pulls OpenAI, NumPy, OpenPyXL, Azure Identity/Core, and HTTPX. ALFWorld/Gymnasium, Claude Agent SDK, datasets, Gradio, and vLLM are optional. vLLM is the main GPU-heavy dependency; Ray is initialized only for adapters declaring it, with `num_gpus=0`. (`pyproject.toml:26-64`, `skillopt/engine/trainer.py:845-855`)

Secret redaction is incomplete: only exact keys `azure_api_key`, `api_key`, and `openai_api_key` are redacted, while the shipped config uses `azure_openai_api_key`, `optimizer_azure_openai_api_key`, and `target_azure_openai_api_key`. Those values can therefore be written into `out_root/config.json`. (`skillopt/engine/trainer.py:334-352`, `skillopt/engine/trainer.py:909-911`, `configs/_base_/default.yaml:39-56`)

PR #249’s pre-fix diff is not present because this clone contains only the grafted merge commit. The current fix defaults the WebUI to `127.0.0.1` and warns that public binding has no authentication. The residual risk is real: Output Explorer accepts an arbitrary path and recursively reads YAML/JSONL results, while training controls can launch subprocesses with `.env` and `.secrets/*.env` loaded. Authentication is not implemented. (`skillopt_webui/app.py:67-101`, `skillopt_webui/app.py:195-227`, `skillopt_webui/app.py:591-645`, `skillopt_webui/app.py:664-684`, `tests/test_webui_security.py:27-57`)

Tests run on Linux 3.10-3.12 and mock the Claude/Codex subprocesses; no coverage percentage, coverage threshold, or macOS CI was found. (`.github/workflows/ci.yml:10-29`, `tests/test_claude_backend_tempdir.py:13-58`, `tests/test_codex_optimizer_backend.py:60-110`)

Claude Code target CLI mode emits `--max-thinking-tokens 16384` by default. Claude Code 2.1.258 does not expose that CLI flag, so set `claude_code_exec_max_thinking_tokens: 0`. SDK mode can avoid that CLI incompatibility if the optional SDK is installed. (`configs/_base_/default.yaml:21-25`, `skillopt/model/codex_harness.py:917-922`)

## 8. Concrete runbook

1. Create an isolated supported interpreter:

```bash
brew install python@3.12
/opt/homebrew/bin/python3.12 -m venv .venv
.venv/bin/pip install -e ./skillopt-src
```

Python 3.12 is both declared and CI-tested. (`pyproject.toml:11-23`, `.github/workflows/ci.yml:10-24`)

2. Create `data/{train,val,test}/items.json`. Each file is a JSON array. For the skeleton, items need `id`, `prompt`, and `score_cmd`; the loader maps `val` to selection and `test` to held-out evaluation. (`skillopt/datasets/base.py:19-28`, `skillopt/datasets/base.py:390-407`)

3. Add the adapter import and registry entry in `scripts/train.py`, then create `initial_skill.md`. (`scripts/train.py:43-125`)

4. Codex configuration:

```yaml
_base_: ./skillopt-src/configs/_base_/default.yaml
model:
  backend: codex
  optimizer_backend: codex_exec
  target_backend: codex_exec
  optimizer: gpt-5.6-sol
  target: gpt-5.6-terra
  codex_exec_use_sdk: cli
  codex_exec_sandbox: workspace-write
  codex_exec_network_access: false
  codex_exec_web_search: false
  codex_exec_approval_policy: never
train: {num_epochs: 4, train_size: 40, batch_size: 40, accumulation: 1}
env:
  name: shell_score
  skill_init: ./initial_skill.md
  split_mode: split_dir
  split_dir: ./data
  exec_timeout: 120
  out_root: ./out-codex
evaluation: {sel_env_num: 0, test_env_num: 0, eval_test: true}
```

Run:

```bash
.venv/bin/python skillopt-src/scripts/train.py --config codex.yaml
```

No OpenAI key is used by the Codex subprocess path. (`skillopt/model/codex_backend.py:299-347`)

5. Claude Code configuration:

```yaml
_base_: ./skillopt-src/configs/_base_/default.yaml
model:
  backend: claude_code_exec
  optimizer_backend: claude_code_exec
  target_backend: claude_code_exec
  optimizer: claude-sonnet-4-6
  target: claude-sonnet-4-6
  claude_code_exec_use_sdk: cli
  claude_code_exec_effort: medium
  claude_code_exec_max_thinking_tokens: 0
train: {num_epochs: 4, train_size: 40, batch_size: 40, accumulation: 1}
env:
  name: shell_score
  skill_init: ./initial_skill.md
  split_mode: split_dir
  split_dir: ./data
  exec_timeout: 120
  out_root: ./out-claude
evaluation: {sel_env_num: 0, test_env_num: 0, eval_test: true}
```

Run:

```bash
.venv/bin/python skillopt-src/scripts/train.py --config claude.yaml
```

Explicit `optimizer_backend` is required because `backend: claude_code_exec` otherwise leaves the optimizer on OpenAI/Azure. (`scripts/train.py:658-663`)

6. Inspect `out-*/best_skill.md`, `history.json`, `runtime_state.json`, rollout predictions, and Codex/Claude raw trace files. Re-running the same config/output directory resumes automatically. (`skillopt/engine/trainer.py:948-1038`, `skillopt/model/codex_harness.py:319-370`)

For `T` training items, `S` selection items, and `Q` test items, defaults produce `N=ceil(T/40)` steps per epoch. Nominal target calls are:

```text
4T training
+ S baseline selection
+ 4NS candidate gates
+ 120 slow-update comparisons
+ 0 or S final selection
+ 2Q or 3Q test calls
```

For `T=40`, this is `280 + 5S` before final validation/test. With `S=10`, `Q=10`, and final equal to best, expect 350 target calls. If final differs from best, expect up to 370. Empty-response retry, SDK-to-CLI fallback, timeouts, and `changed` longitudinal top-ups can increase this. (`configs/_base_/default.yaml:79-111`, `skillopt/engine/trainer.py:891-920`, `skillopt/engine/trainer.py:1807-1839`, `skillopt/engine/trainer.py:2182-2357`, `skillopt/model/codex_harness.py:1423-1495`)