#!/usr/bin/env python3
"""validate.py - deterministic linter for a Claude Code skill.

Usage:
  python3 validate.py <skill-dir-or-SKILL.md> [--json] [--strict]

Reports ERROR (objective spec violations) and WARN (real but not fatal). Style
opinions are NOT the script's job; the rubric judges prose. Exit 1 on any ERROR
(or any WARN under --strict), else 0.

Suppress a rule for one skill with an HTML comment anywhere in SKILL.md:
  <!-- skill-lint: ignore em-dash,body-too-long -->
"""
import sys, os, re, json

KNOWN_KEYS = {
    "name", "description", "when_to_use", "argument-hint", "arguments",
    "disable-model-invocation", "user-invocable", "allowed-tools",
    "disallowed-tools", "model", "effort", "context", "agent", "hooks",
    "paths", "shell", "license", "compatibility", "metadata",
}


def frontmatter(text):
    m = re.match(r"^---\s*\n(.*?)\n---\s*\n", text, re.DOTALL)
    if not m:
        return None, None
    block = m.group(1)
    try:
        import yaml
        return yaml.safe_load(block) or {}, block
    except Exception:
        pass
    # minimal fallback: inline scalars + folded (>-, >, |) blocks
    fm, lines, i = {}, block.split("\n"), 0
    while i < len(lines):
        line = lines[i]
        km = re.match(r"^([A-Za-z0-9_-]+):\s*(.*)$", line)
        if km:
            key, val = km.group(1), km.group(2).strip()
            if val in (">-", ">", "|", "|-"):
                buf, i = [], i + 1
                while i < len(lines) and (lines[i].startswith("  ") or not lines[i].strip()):
                    buf.append(lines[i].strip()); i += 1
                fm[key] = " ".join(b for b in buf if b); continue
            fm[key] = val.strip("'\"")
        i += 1
    return fm, block


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    flags = {a for a in sys.argv[1:] if a.startswith("--")}
    if not args:
        print("usage: validate.py <skill-dir-or-SKILL.md> [--json] [--strict]"); return 2
    target = args[0]
    skill_dir = target if os.path.isdir(target) else os.path.dirname(target) or "."
    md = os.path.join(skill_dir, "SKILL.md")
    findings = []

    def add(sev, rule, msg, line=0, f="SKILL.md"):
        findings.append({"severity": sev, "rule": rule, "file": f, "line": line, "msg": msg})

    if not os.path.isfile(md):
        add("ERROR", "no-skill-md", f"no SKILL.md in {skill_dir}")
        return report(findings, flags)

    text = open(md, encoding="utf-8").read()
    body_lines = text.split("\n")
    suppress = set()
    sm = re.search(r"skill-lint:\s*ignore\s+([a-z0-9,\- ]+)", text)
    if sm:
        suppress = {r.strip() for r in sm.group(1).replace(" ", ",").split(",") if r.strip()}

    fm, block = frontmatter(text)
    if fm is None:
        add("ERROR", "bad-frontmatter", "missing or malformed YAML frontmatter (--- ... ---)")
        return report(findings, flags, suppress)

    dirname = os.path.basename(os.path.abspath(skill_dir))
    name = str(fm.get("name", "") or "")
    if name:
        if len(name) > 64:
            add("ERROR", "name-format", f"name is {len(name)} chars (max 64)")
        if not re.fullmatch(r"[a-z0-9-]+", name):
            add("ERROR", "name-format", f"name '{name}' must be lowercase a-z, 0-9, hyphen only")
        if re.search(r"claude|anthropic", name):
            add("ERROR", "name-reserved", f"name '{name}' contains a reserved word")
        if name != dirname:
            add("ERROR", "name-dir-mismatch", f"name '{name}' must match directory '{dirname}'")

    desc = str(fm.get("description", "") or "")
    if not desc.strip():
        add("ERROR", "desc-missing", "description is required and must be non-empty")
    else:
        if len(desc) > 1024:
            add("ERROR", "desc-too-long", f"description is {len(desc)} chars (max 1024)")
        if re.search(r"\b(I|I'll|I can|I will|let me|you can use this|you can)\b", desc[:120], re.I):
            add("WARN", "desc-person", "description should be third person, not first/second")
        combined = desc + " " + str(fm.get("when_to_use", "") or "")
        if len(combined) > 1536:
            add("WARN", "listing-cap", f"description + when_to_use is {len(combined)} chars; listing truncates at 1536")

    for k in fm:
        if k not in KNOWN_KEYS:
            add("WARN", "unknown-key", f"frontmatter key '{k}' is not a known field")

    body = text[len(block) + 8:] if block else text
    n_body = len(body.split("\n"))
    if n_body > 500:
        add("WARN", "body-too-long", f"SKILL.md body is ~{n_body} lines (keep under 500; split into references/)")

    # examples gate
    if not re.search(r"^#+\s*Examples?\b", body, re.M | re.I):
        add("WARN", "no-examples", "no '## Examples' section; add at least one real Input to Output pair")
    if re.search(r"\b(foo|bar|baz|example\.com|your[_ -]?(input|text)|<[a-z ]+here>)\b", body, re.I):
        add("WARN", "placeholder-example", "looks like placeholder example data (foo/example.com/<...>); use a real example")

    # house style + paths, scanned across skill files
    for root, _, files in os.walk(skill_dir):
        for fn in files:
            if not fn.endswith((".md", ".sh", ".py")):
                continue
            rel = os.path.relpath(os.path.join(root, fn), skill_dir)
            ftext = open(os.path.join(root, fn), encoding="utf-8", errors="ignore").read()
            for i, ln in enumerate(ftext.split("\n"), 1):
                if "\u2014" in ln or "\u2013" in ln:
                    add("WARN", "em-dash", "em/en dash; use commas, parentheses, or colons", i, rel)
                if re.search(r"(scripts|references|assets)\\[a-z]", ln):
                    add("ERROR", "windows-path", "Windows backslash path; use forward slashes", i, rel)

    # referenced bundled paths must exist
    for m in re.finditer(r"(?:\]\(|`|\$\{CLAUDE_SKILL_DIR\}/)((?:references|scripts|assets)/[A-Za-z0-9_./-]+)", text):
        p = m.group(1)
        if not os.path.exists(os.path.join(skill_dir, p)):
            add("ERROR", "missing-ref", f"referenced path does not exist: {p}")

    # ToC for long reference files; nested references
    refdir = os.path.join(skill_dir, "references")
    if os.path.isdir(refdir):
        for fn in os.listdir(refdir):
            fp = os.path.join(refdir, fn)
            if not fn.endswith(".md"):
                continue
            rtext = open(fp, encoding="utf-8", errors="ignore").read()
            if len(rtext.split("\n")) > 100 and not re.search(r"(?i)^#+\s*(contents|table of contents)", rtext, re.M):
                add("WARN", "toc-missing", f"{fn} is over 100 lines and has no Contents section", 1, f"references/{fn}")
            if re.search(r"\]\(\.?/?references/", rtext):
                add("WARN", "nested-ref", f"{fn} links to another reference file; keep references one level deep", 1, f"references/{fn}")

    return report(findings, flags, suppress)


def report(findings, flags, suppress=frozenset()):
    findings = [f for f in findings if f["rule"] not in suppress]
    if "--json" in flags:
        for f in findings:
            print(json.dumps(f))
    else:
        if not findings:
            print("OK: no issues")
        for f in sorted(findings, key=lambda x: 0 if x["severity"] == "ERROR" else 1):
            loc = f"{f['file']}:{f['line']}" if f["line"] else f["file"]
            print(f"{f['severity']:5} {f['rule']:18} {loc}: {f['msg']}")
    errors = [f for f in findings if f["severity"] == "ERROR"]
    warns = [f for f in findings if f["severity"] == "WARN"]
    if errors or ("--strict" in flags and warns):
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
