# Gemini text/reasoning - prompt examples

Verified 2026-06-13. Models: `gemini-3.5-flash` (collect), `gemini-3.1-pro-preview` (reason). Call shapes → `../gemini.md`. `[off]`=official, `[com]`=community.

## Gemini 3.x rules (load-bearing) [off]
- **Do NOT set temperature/top_p/top_k** - leave default 1.0; lowering causes looping/degradation.
- Delete 2.x-era boilerplate; put the **core ask + negative constraints on the LAST line** (Gemini 3 weights the tail most).
- `thinkingLevel` (3.x) and legacy `thinkingBudget` (2.5/lite) are **mutually exclusive** → 400 if both.

## Thinking control (thinking tokens bill as output → cheapest lever) [off]
```python
ThinkingConfig(thinking_level="high")    # 3.1-Pro default - hard math/coding/data
ThinkingConfig(thinking_level="low")     # fact lookup / chat - cuts spend 50-70%
ThinkingConfig(thinking_level="minimal") # batch extract/classify/route - near-zero thinking
ThinkingConfig(thinking_level="high", include_thoughts=True)  # debug + meter thoughts_token_count
# Flash-lite/2.5 only: thinking_budget=0 (off) | -1 (dynamic)
```
REST is camelCase: `generationConfig.thinkingConfig.thinkingLevel` (verified working on gemini-3.5-flash).

## System-instruction style - "use ONLY provided context" beats long negative lists; 3-line scaffold > rambling [off/com]
```
ROLE: Senior financial analyst.
RULES:
- Use ONLY the provided documents for any figure or claim.
- Cite the source section for every number as [Section X].
Do not use outside knowledge; if a figure is absent, say "not in source".
```

## Structured output - Gemini 3 infers shape from one cue; explicit `null` rule kills hallucinated fields [com]
```
Extract Q3 2025 revenue, operating expenses, net profit margin from the report.
Return JSON {revenue, expenses, margin}; use null if a field is absent.
```
Strict path: `response_format.text.schema = MyModel.model_json_schema()` - guarantees parseable JSON even with Search grounding.

## Long-context (1M) - query FIRST then haystack in XML sections; decompose multi-needle [com]
```
Find every clause mentioning termination rights; quote verbatim with [Section X]; flag conflicts.
<documents><section id="1">…</section><section id="2">…</section></documents>
```
Multi-needle: ask each sub-question independently with its own [Section X] cite, then list which aren't present.
> Recall drops (~85% @128k → ~26% @1M). For accuracy-critical retrieval, pre-chunk to 50-100k focused sections.

Sources: ai.google.dev/gemini-3 · /thinking · Gemini 3 Prompting Guide (Google Cloud) · DigitalApplied long-context 2026 · Apiyi thinking-error fix.
