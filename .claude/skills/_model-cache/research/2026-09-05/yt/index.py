#!/usr/bin/env python3
"""Build a markdown index of per-video reports: index.py <reports_dir> [filter-regex-on-title]. Prints table sorted hands-on first, then views."""
import sys, os, re, json
d = sys.argv[1]; flt = re.compile(sys.argv[2], re.I) if len(sys.argv) > 2 else None
rows = []
for f in os.listdir(d):
    t = open(os.path.join(d, f)).read()
    title = re.search(r"^## Video: (.*)$", t, re.M); title = title.group(1) if title else "?"
    if flt and not flt.search(title): continue
    g = lambda k: (re.search(r"\*\*" + k + r":\*\*\s*(.*)", t) or [None, ""])[1].strip()
    views = (re.search(r"\*\*Views:\*\* (\S+)", t) or [None, "?"])[1]; date = (re.search(r"\*\*Date:\*\* (\S+)", t) or [None, "?"])[1]; length = (re.search(r"\*\*Length:\*\* (\S+)", t) or [None, "?"])[1]
    hands = g("HANDS-ON")[:3].lower(); addr = g("ADDRESSES GOAL")[:40]; conf = g("CONFIDENCE")[:1]; up = g("UPLOAD DATE")[:30]
    err = "yt.sh ERR" in t or len(t) < 500
    rows.append(dict(id=f[:-3], title=title, views=int(views) if views.isdigit() else -1, date=date if date != "unknown" else (up or "?"), length=length, hands=hands, addr=addr, conf=conf, err=err))
rows.sort(key=lambda r: (r["err"], r["hands"] != "yes", -r["views"]))
print(f"{len(rows)} reports, hands-on yes: {sum(1 for r in rows if r['hands']=='yes')}, errors: {sum(1 for r in rows if r['err'])}")
print("| views | date | len | hands-on | addresses goal | conf | title | id |"); print("|---|---|---|---|---|---|---|---|")
for r in rows: print(f"| {r['views']} | {r['date']} | {r['length']} | {'ERR' if r['err'] else r['hands']} | {r['addr']} | {r['conf']} | {r['title'][:95]} | {r['id']} |")
