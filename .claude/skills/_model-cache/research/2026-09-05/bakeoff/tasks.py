"""Bakeoff tasks. Each task: id, kind, build() -> dict(messages=..., extra=...), grade(text, ctx) -> (score 0..1, note).
Deterministic, verifiable. Vision/tools tasks flagged. No em dashes anywhere."""
import json, re, os, subprocess, sys, tempfile, textwrap, base64, io, random

HERE = os.path.dirname(os.path.abspath(__file__))

def code_block(text):
    m = re.findall(r"```(?:python)?\s*\n(.*?)```", text, re.S)
    if m:
        return max(m, key=len)
    return text

def run_python(code, tests, timeout=20):
    d = tempfile.mkdtemp()
    open(os.path.join(d, "solution.py"), "w").write(code)
    open(os.path.join(d, "test_it.py"), "w").write(tests)
    try:
        p = subprocess.run([sys.executable, "-s", "test_it.py"], cwd=d, capture_output=True, text=True, timeout=timeout)
        out = (p.stdout + p.stderr)[-1500:]
        m = re.search(r"PASSED (\d+)/(\d+)", p.stdout)
        if m:
            return int(m.group(1)) / int(m.group(2)), f"{m.group(1)}/{m.group(2)} " + out[-300:].replace("\n", " | ")
        return 0.0, "no PASSED line: " + out.replace("\n", " | ")
    except subprocess.TimeoutExpired:
        return 0.0, "timeout"

# ---------- T1 ISO duration ----------
T1_PROMPT = """Implement a Python 3 function `parse_duration(s: str) -> float` that converts an ISO 8601 duration string to a number of seconds.

Rules:
- Format: P[nY][nM][nD][T[nH][nM][nS]] or P[nW]. The leading P is mandatory. T separates date and time parts and must be followed by at least one time component.
- Y = 365 days, M (date part) = 30 days, W = 7 days, D = 86400 s, H = 3600 s, M (time part) = 60 s.
- W cannot be combined with any other component.
- Only the LAST present component may carry a decimal fraction (dot or comma). A fraction anywhere else is invalid.
- Negative durations, empty strings, missing P, "P" alone, "PT" alone, unknown letters, repeated components, out-of-order components: raise ValueError.
- "P0D" and "PT0S" are valid and return 0.
- Always return a float.

Return ONLY one ```python code block containing the complete function (imports included), no tests, no prose."""

T1_TESTS = r'''
from solution import parse_duration as f
cases = [("PT1H",3600),("P1W",604800),("P1DT12H",129600),("PT0.5S",0.5),("PT1M30.25S",90.25),("P1Y",31536000),("P1M",2592000),("P2DT3H4M5S",183845),("PT36H",129600),("P0D",0),("PT0S",0),("PT1,5S",1.5)]
bad = ["P","PT","1H","PT1.5H30M","P1W1D","-P1D","","P1DT","P1H","PT1S1M","P1D1D","P1X"]
ok=0; n=0
for s,e in cases:
    n+=1
    try:
        r=f(s); 
        if abs(r-e)<1e-9 and isinstance(r,float): ok+=1
        else: print("FAIL",s,r)
    except Exception as ex: print("FAIL",s,repr(ex))
for s in bad:
    n+=1
    try:
        r=f(s); print("FAIL should raise",repr(s),r)
    except ValueError: ok+=1
    except Exception as ex: print("FAIL wrong exc",repr(s),repr(ex))
print(f"PASSED {ok}/{n}")
'''

# ---------- T2 bugfix ----------
T2_BUGGY = '''import time

class TokenBucket:
    """Token bucket rate limiter.
    capacity: max tokens. refill_per_sec: tokens added per second (float ok).
    now: injectable clock returning seconds (float)."""
    def __init__(self, capacity, refill_per_sec, now=time.monotonic):
        if capacity <= 0 or refill_per_sec <= 0:
            raise ValueError("capacity and refill_per_sec must be positive")
        self.capacity = capacity
        self.refill_per_sec = refill_per_sec
        self._now = now
        self.tokens = capacity
        self.last = now()

    def _refill(self):
        t = self._now()
        elapsed = int(t - self.last)
        self.tokens = min(self.capacity, self.tokens + elapsed * self.refill_per_sec)

    def try_acquire(self, n=1):
        """Take n tokens if available. Returns True/False. n > capacity must raise ValueError."""
        self._refill()
        if n < self.tokens:
            self.tokens -= n
            return True
        return False

    def time_until(self, n=1):
        """Seconds to wait until n tokens are available (0.0 if available now)."""
        self._refill()
        if self.tokens >= n:
            return 0.0
        return (n - self.tokens) * self.refill_per_sec
'''

T2_PROMPT = """The module below is a token-bucket rate limiter with several bugs. Its docstrings are the spec. Known symptoms reported by users:
1. With a fractional clock (e.g. 0.5 s elapsed at 2 tokens/s) no tokens get refilled.
2. After tokens were refilled once, calling try_acquire again without any time passing sometimes succeeds when it should fail (tokens seem to come back for free).
3. Acquiring exactly the number of tokens currently in the bucket fails, although it should succeed.
4. time_until returns wrong numbers (for 1 missing token at 2 tokens/s it should be 0.5).
5. try_acquire(n) with n larger than capacity should raise ValueError but does not.

Fix the module. Keep the class name, method names and constructor signature. Do not add dependencies. Return ONLY one ```python code block with the complete fixed module, no prose.

```python
""" + T2_BUGGY + "```"

T2_TESTS = r'''
from solution import TokenBucket
class Clock:
    def __init__(s): s.t=0.0
    def __call__(s): return s.t
ok=0;n=0
def check(cond,msg):
    global ok,n
    n+=1
    if cond: ok+=1
    else: print("FAIL",msg)
c=Clock(); b=TokenBucket(5,2.0,now=c)
check(b.try_acquire(5) is True, "acquire exactly all tokens")
check(b.try_acquire(1) is False, "empty bucket refuses")
c.t=0.5; check(b.try_acquire(1) is True, "fractional refill 0.5s*2=1 token")
check(b.try_acquire(1) is False, "no free tokens after refill without time passing")
c.t=1.0; check(b.try_acquire(1) is True, "second refill after last updated")
check(b.try_acquire(1) is False, "and empty again")
c.t=100.0; b._refill(); check(abs(b.tokens-5)<1e-9, "capped at capacity")
b.try_acquire(5); check(abs(b.time_until(1)-0.5)<1e-9, "time_until 1 token at 2/s = 0.5")
check(abs(b.time_until(3)-1.5)<1e-9, "time_until 3 tokens = 1.5")
c.t=100.25; check(abs(b.time_until(1)-0.25)<1e-9, "time_until accounts for partial refill")
try:
    b.try_acquire(6); print("FAIL n>capacity should raise")
except ValueError: ok+=1
n+=1
c.t=200; check(b.time_until(1)==0.0, "time_until 0.0 when available")
print(f"PASSED {ok}/{n}")
'''

# ---------- T3 extraction ----------
T3_TEXT = """Hi, attached is invoice INV-2026-0917 from Kovács & Fiai Kft. for the July work. Items: 3x 'Server maintenance' at 120 EUR each, and 1 'Emergency callout' at 450 EUR (they originally quoted 400 but we agreed 450). Subtotal 810 EUR, VAT 27% = 218.70, total 1028.70 EUR. Due 15 days after the issue date; it was issued on 2026-08-22. Not paid yet. Also, last month's invoice INV-2026-0850 was already settled, ignore that one. Thanks, Réka"""
T3_SCHEMA = {"type":"object","properties":{
    "invoice_number":{"type":"string"},"vendor":{"type":"string"},"total":{"type":"number"},
    "currency":{"type":"string","enum":["EUR","USD","HUF"]},"issue_date":{"type":"string"},"due_date":{"type":"string"},
    "line_items":{"type":"array","items":{"type":"object","properties":{"description":{"type":"string"},"quantity":{"type":"integer"},"unit_price":{"type":"number"}},"required":["description","quantity","unit_price"],"additionalProperties":False}},
    "paid":{"type":"boolean"},"notes":{"type":["string","null"]}},
    "required":["invoice_number","vendor","total","currency","issue_date","due_date","line_items","paid","notes"],"additionalProperties":False}
T3_PROMPT = "Extract the invoice data from the message below into JSON matching this schema exactly (dates as YYYY-MM-DD; due_date must be computed; only the invoice being sent, not other invoices mentioned). Output only the JSON object.\n\nSCHEMA:\n" + json.dumps(T3_SCHEMA) + "\n\nMESSAGE:\n" + T3_TEXT

def grade_t3(text, ctx):
    m = re.search(r"\{.*\}", text, re.S)
    if not m: return 0.0, "no json"
    try: d = json.loads(m.group(0))
    except Exception as e: return 0.0, "bad json " + str(e)[:80]
    checks = [d.get("invoice_number") == "INV-2026-0917", str(d.get("total")) in ("1028.7", "1028.70"), d.get("currency") == "EUR",
              d.get("issue_date") == "2026-08-22", d.get("due_date") == "2026-09-06", d.get("paid") is False,
              isinstance(d.get("line_items"), list) and sum(int(i.get("quantity", 0)) for i in d["line_items"]) == 4 and len(d["line_items"]) == 2,
              isinstance(d.get("line_items"), list) and any(abs(float(i.get("unit_price", 0)) - 450) < 1e-6 for i in d["line_items"])]
    try:
        import jsonschema; jsonschema.validate(d, T3_SCHEMA); checks.append(True)
    except Exception as e:
        checks.append(False)
    return sum(checks) / len(checks), f"{sum(checks)}/{len(checks)} due={d.get('due_date')} total={d.get('total')}"

# ---------- T4 reasoning ----------
T4_PROMPT = """Answer these six questions. Output ONLY a JSON array of six integers in order, nothing else.
1. The sum of all prime numbers below 100.
2. The number of trailing zeros in 125! (125 factorial).
3. The smallest positive integer that has exactly 12 positive divisors.
4. 2 to the power 20, modulo 1000.
5. The smaller angle in degrees between the hour and minute hands of an analog clock at 3:40.
6. The number of distinct arrangements of the letters of the word BANANA."""
T4_ANS = [1060, 31, 60, 576, 130, 60]
def grade_t4(text, ctx):
    m = re.search(r"\[[^\]]*\]", text)
    if not m: return 0.0, "no array"
    try: a = json.loads(m.group(0))
    except Exception: return 0.0, "bad array"
    ok = sum(1 for x, y in zip(a, T4_ANS) if x == y)
    return ok / 6, f"{ok}/6 got={a}"

# ---------- T5 needle ----------
def build_needle_doc(target_chars=300000, seed=7):
    rnd = random.Random(seed)
    subjects = ["The committee","A junior analyst","The night shift","Our supplier in Porto","The regional office","The audit team","A contractor","The board","The logistics desk","The intern"]
    verbs = ["reviewed","postponed","filed","questioned","approved","re-checked","archived","misplaced","forwarded","summarized"]
    objects = ["the quarterly inventory report","the revised shipping manifest","the vendor onboarding checklist","the maintenance schedule","the customs paperwork","the insurance addendum","the staffing rota","the budget variance memo","the safety inspection notes","the training attendance sheet"]
    tails = ["before the Thursday sync.","without noting the reason.","and asked for a second copy.","after the system outage.","despite the missing signature.","in the shared drive.","with two minor corrections.","ahead of the deadline.","during the site visit.","for the second time this year."]
    paras = []
    total = 0; i = 0
    while total < target_chars:
        sents = []
        for _ in range(rnd.randint(4, 7)):
            sents.append(f"{rnd.choice(subjects)} {rnd.choice(verbs)} {rnd.choice(objects)} {rnd.choice(tails)}")
        p = f"Entry {i}: " + " ".join(sents)
        paras.append(p); total += len(p) + 2; i += 1
    n = len(paras)
    paras.insert(int(n * 0.10), "Entry note: The access code for the Vasquez archive is 7183-KQ.")
    paras.insert(int(n * 0.50), "Entry note: Project Heron's launch window closes on 14 November.")
    paras.insert(int(n * 0.90), "Entry note: The Tallinn warehouse holds 4,271 crates.")
    return "\n\n".join(paras)
T5_Q = """\n\nBased ONLY on the log above, answer as a JSON object with keys "vasquez_code", "heron_close", "tallinn_crates" (values as strings). Output only the JSON."""
def grade_t5(text, ctx):
    t = text.replace(",", "")
    c = ["7183-KQ" in text, "14 November" in text or "November 14" in text, "4271" in t]
    return sum(c) / 3, f"{sum(c)}/3"

# ---------- T6 format ----------
T6_PROMPT = "Write exactly 7 bullet lines about why teams should keep configuration files under version control. Each line starts with '- ' and contains between 8 and 12 words. Everything lowercase. No digits anywhere. No other text before or after the bullets."
def grade_t6(text, ctx):
    lines = [l for l in text.strip().splitlines() if l.strip()]
    c = [len(lines) == 7, all(l.startswith("- ") for l in lines), all(8 <= len(l[2:].split()) <= 12 for l in lines if l.startswith("- ")),
         text == text.lower(), not re.search(r"\d", text)]
    return sum(c) / 5, f"{sum(c)}/5 lines={len(lines)}"

# ---------- T7 Hungarian ----------
T7_PROMPT = "Írj egy rövid, pontosan három bekezdéses magyarázatot egy nem műszaki cégvezetőnek arról, miért érdemes egy cégnek több mesterséges intelligencia modellt párhuzamosan használni egy helyett. Magyarul, természetes, hétköznapi nyelven, tegeződve. Kerüld az angol szakszavakat, ahol van jó magyar megfelelő. Csak a három bekezdés, semmi más."
def grade_t7(text, ctx):
    paras = [p for p in text.strip().split("\n\n") if p.strip()]
    hu = sum(text.count(ch) for ch in "őűáéíóöúüŐŰÁÉÍÓÖÚÜ")
    words = len(text.split())
    c = [len(paras) == 3, hu > words * 0.08, 120 <= words <= 450]
    return sum(c) / 3, f"{sum(c)}/3 paras={len(paras)} words={words} hu={hu}"

# ---------- T8 vision ----------
def build_table_image():
    from PIL import Image, ImageDraw, ImageFont
    rows = [("Item", "Qty", "Unit"), ("Bolts M6", "140", "0.12"), ("Washers", "85", "0.03"), ("Brackets", "12", "4.50"), ("Hinges", "9", "7.25"), ("Screws", "310", "0.05")]
    img = Image.new("RGB", (520, 260), "white"); d = ImageDraw.Draw(img)
    try: font = ImageFont.truetype("/System/Library/Fonts/Supplemental/Arial.ttf", 22)
    except Exception: font = ImageFont.load_default()
    for r, row in enumerate(rows):
        for c, cell in enumerate(row):
            d.text((20 + c * 170, 20 + r * 38), cell, fill="black", font=font)
    d.line((10, 55, 510, 55), fill="black", width=2)
    b = io.BytesIO(); img.save(b, "PNG"); return base64.b64encode(b.getvalue()).decode()
T8_PROMPT = "The image shows a parts table. Compute the total cost = sum over rows of Qty times Unit. Reply with ONLY a JSON object {\"rows\": <number of data rows>, \"total_qty\": <sum of Qty>, \"total_cost\": <total cost rounded to 2 decimals>}."
T8_ANS = {"rows": 5, "total_qty": 556, "total_cost": round(140*0.12 + 85*0.03 + 12*4.50 + 9*7.25 + 310*0.05, 2)}
def grade_t8(text, ctx):
    m = re.search(r"\{.*\}", text, re.S)
    if not m: return 0.0, "no json"
    try: d = json.loads(m.group(0))
    except Exception: return 0.0, "bad json"
    c = [d.get("rows") == 5, d.get("total_qty") == 556, abs(float(d.get("total_cost", -1)) - T8_ANS["total_cost"]) < 0.02]
    return sum(c) / 3, f"{sum(c)}/3 got={d} want={T8_ANS}"

# ---------- T9 tools ----------
T9_TOOLS = [
 {"type":"function","function":{"name":"get_weather","description":"Current weather for a city","parameters":{"type":"object","properties":{"city":{"type":"string"}},"required":["city"]}}},
 {"type":"function","function":{"name":"convert_c_to_f","description":"Convert Celsius to Fahrenheit","parameters":{"type":"object","properties":{"celsius":{"type":"number"}},"required":["celsius"]}}},
 {"type":"function","function":{"name":"send_report","description":"Send a one-line text report to the ops channel","parameters":{"type":"object","properties":{"text":{"type":"string"}},"required":["text"]}}}]
T9_PROMPT = "Get the current weather in Budapest, convert the temperature to Fahrenheit using the conversion tool (do not compute it yourself), then send a report with exactly this format: 'Budapest: <F> F' where <F> is the Fahrenheit value with one decimal. Then reply 'done'."
def t9_tool_impl(name, args):
    if name == "get_weather": return {"city": args.get("city"), "temp_c": 21, "sky": "clear"}
    if name == "convert_c_to_f": return {"fahrenheit": round(float(args.get("celsius", 0)) * 9 / 5 + 32, 1)}
    if name == "send_report": return {"status": "sent"}
    return {"error": "unknown tool"}
def grade_t9(text, ctx):
    calls = ctx.get("tool_calls", [])
    names = [c[0] for c in calls]
    sent = [c[1] for c in calls if c[0] == "send_report"]
    ok_seq = names[:3] == ["get_weather", "convert_c_to_f", "send_report"] or (len(names) >= 3 and "get_weather" in names and "convert_c_to_f" in names and "send_report" in names)
    ok_text = any(str(a.get("text", "")).strip() == "Budapest: 69.8 F" for a in sent)
    ok_conv = any(c[0] == "convert_c_to_f" and abs(float(c[1].get("celsius", -99)) - 21) < 1e-6 for c in calls)
    c = [ok_seq, ok_conv, ok_text]
    return sum(c) / 3, f"{sum(c)}/3 calls={[(n, a) for n, a in calls]}"

TASKS = {
 "t1_iso": dict(kind="code", prompt=T1_PROMPT, grade=lambda t, c: run_python(code_block(t), T1_TESTS)),
 "t2_bugfix": dict(kind="code", prompt=T2_PROMPT, grade=lambda t, c: run_python(code_block(t), T2_TESTS)),
 "t3_extract": dict(kind="text", prompt=T3_PROMPT, grade=grade_t3, schema=T3_SCHEMA),
 "t4_reason": dict(kind="text", prompt=T4_PROMPT, grade=grade_t4),
 "t5_needle": dict(kind="text", prompt=None, grade=grade_t5, builder=lambda: build_needle_doc() + T5_Q),
 "t6_format": dict(kind="text", prompt=T6_PROMPT, grade=grade_t6),
 "t7_hungarian": dict(kind="text", prompt=T7_PROMPT, grade=grade_t7),
 "t8_vision": dict(kind="vision", prompt=T8_PROMPT, grade=grade_t8, image=build_table_image),
 "t9_tools": dict(kind="tools", prompt=T9_PROMPT, grade=grade_t9, tools=T9_TOOLS, impl=t9_tool_impl),
}

# ---------- T10 textwrap-exact ----------
T10_PROMPT = """Implement a Python 3 function `fill(text: str, width: int) -> str` that reproduces EXACTLY the output of the standard library call `textwrap.fill(text, width)` with all default options (break_long_words=True, break_on_hyphens=True, expand_tabs=True, replace_whitespace=True, drop_whitespace=True, no initial or subsequent indent, fix_sentence_endings=False). You may NOT import or use the textwrap module or copy its source verbatim; write your own implementation of the same algorithm, including the word-splitting regex behavior for hyphenated words (compound words are split after hyphens, long words are chunked when they exceed the width). Return ONLY one ```python code block with the function and any helpers, no tests, no prose."""
T10_TESTS = r'''
import random, textwrap, re
from solution import fill
rnd = random.Random(11)
words = ["alpha","beta-gamma","delta","epsilon-zeta-eta","theta","iota","kappa","lambda","mu","nu","xi","omicron","pi-rho","sigma","tau","upsilon","phi","chi","psi","omega","supercalifragilisticexpialidocious","x","hyper-connected","re-enter","--","a-","-b","state-of-the-art"]
ok=0;n=0
for i in range(60):
    t = " ".join(rnd.choice(words) for _ in range(rnd.randint(1,25)))
    if rnd.random()<0.3: t = "  " + t + "\t" + rnd.choice(words)
    if rnd.random()<0.2: t = t.replace(" ", "\n", 1)
    w = rnd.randint(5, 30)
    n+=1
    try:
        if fill(t,w)==textwrap.fill(t,w): ok+=1
        else:
            if n<8: print("FAIL", repr(t)[:60], w)
    except Exception as ex:
        if n<8: print("EXC", repr(ex)[:80])
print(f"PASSED {ok}/{n}")
'''

# ---------- T11 agentic tool loop with trap ----------
T11_TOOLS = [
 {"type":"function","function":{"name":"lookup_user","description":"Find a user id by email address","parameters":{"type":"object","properties":{"email":{"type":"string"}},"required":["email"]}}},
 {"type":"function","function":{"name":"get_orders","description":"List orders for a user id, paginated. Returns orders, page, has_more.","parameters":{"type":"object","properties":{"user_id":{"type":"string"},"page":{"type":"integer"}},"required":["user_id","page"]}}},
 {"type":"function","function":{"name":"send_report","description":"Send a one-line text report to the finance channel","parameters":{"type":"object","properties":{"text":{"type":"string"}},"required":["text"]}}}]
T11_PROMPT = "Find the user with email Reka.Kovacs@Example.com, fetch ALL of their orders (respect pagination), compute the total amount of orders whose status is 'paid' (ignore refunded and pending), and send a report with exactly this format: 'Reka.Kovacs@Example.com paid total: <amount>' with the amount as a plain number with two decimals. Then reply 'done'. Use the tools; never guess values."
T11_ORDERS = {1: ([{"id":"o1","status":"paid","amount":120.50},{"id":"o2","status":"refunded","amount":80.00},{"id":"o3","status":"paid","amount":19.99}], True),
              2: ([{"id":"o4","status":"pending","amount":500.00},{"id":"o5","status":"paid","amount":45.01}], True),
              3: ([{"id":"o6","status":"paid","amount":0.50}], False)}
T11_TOTAL = "186.00"
def t11_tool_impl(name, args):
    if name == "lookup_user":
        e = str(args.get("email", ""))
        if e != e.lower(): return {"error": "not found. Hint: emails are stored lowercase."}
        if e == "reka.kovacs@example.com": return {"user_id": "u-8842"}
        return {"error": "not found"}
    if name == "get_orders":
        if args.get("user_id") != "u-8842": return {"error": "unknown user"}
        p = int(args.get("page", 1)); o = T11_ORDERS.get(p)
        if not o: return {"orders": [], "page": p, "has_more": False}
        return {"orders": o[0], "page": p, "has_more": o[1]}
    if name == "send_report": return {"status": "sent"}
    return {"error": "unknown tool"}
def grade_t11(text, ctx):
    calls = ctx.get("tool_calls", [])
    pages = sorted({int(a.get("page", 0)) for n, a in calls if n == "get_orders"})
    sent = [a.get("text", "") for n, a in calls if n == "send_report"]
    c = [any(n == "lookup_user" and str(a.get("email", "")) == "reka.kovacs@example.com" for n, a in calls),
         pages == [1, 2, 3],
         any(str(s).strip() == f"Reka.Kovacs@Example.com paid total: {T11_TOTAL}" for s in sent)]
    return sum(c) / 3, f"{sum(c)}/3 pages={pages} sent={sent[:2]} ncalls={len(calls)}"

TASKS["t10_wrap"] = dict(kind="code", prompt=T10_PROMPT, grade=lambda t, c: run_python(code_block(t), T10_TESTS))
TASKS["t11_agent"] = dict(kind="tools", prompt=T11_PROMPT, grade=grade_t11, tools=T11_TOOLS, impl=t11_tool_impl)
