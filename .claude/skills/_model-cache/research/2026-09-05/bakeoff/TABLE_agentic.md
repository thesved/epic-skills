## Agentic repo task (ledger: 5 bugs + 1 feature, 11 unit tests, tests locked)

### Identical mini agent harness over OpenRouter (read/write/list/shell tools)

| seat | model | effort | run | pass | wall s | turns | tool calls | shell | in tok | out tok | reason tok | cost $ |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| astra | openai/gpt-6-astra | high | 0 | 11/11 | 28.5 | 6 | 11 | 2 | 15757 | 1306 | 394 | 0.142 |
| fable51 | anthropic/claude-fable-5.1 | default | 0 | 11/11 | 63.9 | 6 | 11 | 2 | 21257 | 3085 | 216 | 0.367 |
| gem37 | google/gemini-3.7-flash | default | 0 | 11/11 | 70.0 | 12 | 19 | 6 | 106897 | 8130 | 6726 | 0.073 |
| gem37 | google/gemini-3.7-flash | default | 1 | 11/11 | 65.5 | 17 | 16 | 7 | 95732 | 5814 | 4684 | 0.067 |
| gem38 | google/gemini-3.8-flash | default | 0 | 11/11 | 125.2 | 28 | 27 | 18 | 328073 | 14099 | 11975 | 0.160 |
| gem38 | google/gemini-3.8-flash | default | 1 | 11/11 | 171.2 | 32 | 31 | 22 | 445887 | 20205 | 17278 | 0.207 |
| glmflash | z-ai/glm-5.3-flash | high | 0 | 11/11 | 46.0 | 5 | 10 | 1 | 8880 | 1437 | 230 | 0.001 |
| glmflash | z-ai/glm-5.3-flash | high | 1 | 11/11 | 31.0 | 8 | 11 | 2 | 16723 | 1482 | 38 | 0.003 |
| luna | openai/gpt-5.6-luna | default | 0 | 11/11 | 31.7 | 8 | 12 | 2 | 21957 | 2696 | 826 | 0.005 |
| luna | openai/gpt-5.6-luna | default | 1 | 11/11 | 25.1 | 7 | 9 | 1 | 14725 | 1836 | 580 | 0.004 |
| sol | openai/gpt-5.6-sol | high | 0 | 11/11 | 41.2 | 6 | 11 | 2 | 23955 | 2826 | 1434 | 0.048 |
| sol | openai/gpt-5.6-sol | high | 1 | 11/11 | 27.1 | 6 | 10 | 1 | 13144 | 1824 | 578 | 0.031 |
| sonnet5 | anthropic/claude-sonnet-5 | default | 0 | 11/11 | 28.8 | 7 | 11 | 2 | 25022 | 2233 | 324 | 0.072 |
| sonnet5 | anthropic/claude-sonnet-5 | default | 1 | 11/11 | 28.4 | 7 | 11 | 2 | 24157 | 2040 | 163 | 0.069 |
| spark13 | meta/muse-spark-1.3 | default | 0 | 11/11 | 61.0 | 6 | 10 | 1 | 24581 | 4606 | 2845 | 0.032 |
| spark13 | meta/muse-spark-1.3 | default | 1 | 11/11 | 50.2 | 7 | 11 | 2 | 38246 | 5581 | 3636 | 0.046 |
| spark13lo | meta/muse-spark-1.3 | low | 0 | 11/11 | 26.2 | 6 | 10 | 1 | 20585 | 3140 | 1558 | 0.023 |
| spark13lo | meta/muse-spark-1.3 | low | 1 | 11/11 | 28.4 | 6 | 10 | 1 | 20205 | 3032 | 1398 | 0.025 |
| spark13xh | meta/muse-spark-1.3 | xhigh | 0 | 11/11 | 190.6 | 11 | 15 | 6 | 107390 | 10820 | 7889 | 0.080 |
| spark13xh | meta/muse-spark-1.3 | xhigh | 1 | 11/11 | 182.9 | 13 | 16 | 5 | 110426 | 9379 | 6171 | 0.102 |

### Native Codex CLI harness (ChatGPT Pro sub, workspace-write sandbox)

| seat | model | effort | run | pass | wall s | commands | in tok | cached in | out tok | reason tok |
|---|---|---|---|---|---|---|---|---|---|---|
| astra | gpt-6-astra | high | 1 | 11/11 | 53.1 | 4 | 76043 | 65920 | 1109 | 88 |
| sol | gpt-5.6-sol | high | 0 | 11/11 | 55.1 | 3 | 95193 | 84352 | 2021 | 449 |
| astra | gpt-6-astra | high | 0 | 11/11 | 58.5 | 5 | 76598 | 66176 | 1352 | 123 |
| sol | gpt-5.6-sol | high | 1 | 11/11 | 97.1 | 4 | 133215 | 111104 | 3946 | 962 |
