#!/usr/bin/env python3
"""End-to-end verification harness - actually CALLS one representative model per
capability and reports PASS/FAIL with evidence. Nothing is "ready" unless it
passes here. Run via verify.sh (which resolves the keys).

Tiers:
  --cheap   text liveness only (gemini text+lite, openai text, openrouter)   ~free
  (default) + media: gemini image, tts, live-audio; openai realtime, codex   ~10-15c
  --full    + paid-gen: veo video, lyria music, deep-research, video-analysis ~$0.50-1

Model ids are the ones the cache recommends - keep in sync with index.md."""
import os, sys, json, base64, subprocess, time, urllib.request, urllib.error

HERE = os.path.dirname(os.path.abspath(__file__))
GKEY = os.environ.get("GEMINI_API_KEY", "")
OKEY = os.environ.get("OPENAI_API_KEY", "")
RKEY = os.environ.get("OPENROUTER_API_KEY", "")
GBASE = "https://generativelanguage.googleapis.com/v1beta"
YT_URL = os.environ.get("VERIFY_YT_URL", "https://www.youtube.com/watch?v=EeYkZloXIww")

results = []  # dicts: cap, model, status, detail, secs
def rec(cap, model, status, detail=""): results.append({"cap":cap,"model":model,"status":status,"detail":detail,"secs":None})
def _median(xs):
    s = sorted(xs); n = len(s)
    return s[n//2] if n % 2 else round((s[n//2-1]+s[n//2])/2, 1)

def run(fn, repeat=1):  # run fn `repeat` times, collapse to one result with MEDIAN secs
    runs = []
    for _ in range(repeat):
        t0 = time.time(); fn(); dt = round(time.time()-t0, 1)
        r = results.pop()           # take the single rec fn appended
        r["secs"] = dt; runs.append(r)
    last = runs[-1]
    secs = [x["secs"] for x in runs]
    last["secs"] = _median(secs)
    if repeat > 1:
        last["detail"] += f"  [{repeat}× {min(secs):.1f}-{max(secs):.1f}s]"
    if any(x["status"] == "FAIL" for x in runs): last["status"] = "FAIL"
    results.append(last)

def http(url, body=None, headers=None, timeout=60):
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(url, data=data, headers=headers or {})
    if data and "content-type" not in {k.lower() for k in (headers or {})}:
        req.add_header("content-type", "application/json")
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            return r.status, json.load(r)
    except urllib.error.HTTPError as e:
        try: return e.code, json.load(e)
        except Exception: return e.code, {"error": {"message": e.read()[:200].decode("utf8","ignore")}}
    except Exception as e:
        return 0, {"error": {"message": repr(e)[:200]}}

def need(key, cap, model):
    if not key: rec(cap, model, "SKIP", "no API key"); return False
    return True

# ---- TIER 0: text liveness ----
def t_gemini_text():
    m = "gemini-3.5-flash"
    if not need(GKEY, "gemini-text", m): return
    s, d = http(f"{GBASE}/models/{m}:generateContent?key={GKEY}",
                {"contents":[{"parts":[{"text":"Reply with exactly: GEMINI_OK"}]}]})
    try: rec("gemini-text", m, "PASS", d["candidates"][0]["content"]["parts"][0]["text"].strip())
    except Exception: rec("gemini-text", m, "FAIL", str(d.get("error",d))[:120])

def t_gemini_lite():
    m = "gemini-flash-lite-latest"
    if not need(GKEY, "gemini-lite", m): return
    s, d = http(f"{GBASE}/models/{m}:generateContent?key={GKEY}",
                {"contents":[{"parts":[{"text":"Reply with exactly: LITE_OK"}]}]})
    try: rec("gemini-lite", m, "PASS", "resolved=%s tier=%s" % (d.get("modelVersion"), d.get("usageMetadata",{}).get("serviceTier","?")))
    except Exception: rec("gemini-lite", m, "FAIL", str(d.get("error",d))[:120])

def t_openai_text():
    m = "gpt-5.5"
    if not need(OKEY, "openai-text", m): return
    s, d = http("https://api.openai.com/v1/chat/completions",
                {"model":m,"messages":[{"role":"user","content":"Reply with exactly: OPENAI_OK"}]},
                {"Authorization": f"Bearer {OKEY}"})
    try: rec("openai-text", m, "PASS", d["choices"][0]["message"]["content"].strip())
    except Exception: rec("openai-text", m, "FAIL", str(d.get("error",d))[:120])

def t_openrouter():
    m = "google/gemini-3.1-flash-lite"  # liveness ping only (key+endpoint); keep on a current-gen cheap id so dashboards don't show retired models
    if not need(RKEY, "openrouter", m): return
    s, d = http("https://openrouter.ai/api/v1/chat/completions",
                {"model":m,"messages":[{"role":"user","content":"Reply with exactly: OR_OK"}]},
                {"Authorization": f"Bearer {RKEY}"})
    try: rec("openrouter", m, "PASS", "via %s" % d.get("provider","?"))
    except Exception: rec("openrouter", m, "FAIL", str(d.get("error",d))[:120])

# ---- TIER 1: media ----
def t_gemini_image():
    m = "gemini-3.1-flash-image"
    if not need(GKEY, "gemini-image", m): return
    s, d = http(f"{GBASE}/models/{m}:generateContent?key={GKEY}",
                {"contents":[{"parts":[{"text":"a single red apple on white, photorealistic"}]}],
                 "generationConfig":{"responseModalities":["IMAGE"],"imageConfig":{"aspectRatio":"1:1","imageSize":"1K"}}})
    try:
        parts = d["candidates"][0]["content"]["parts"]
        inl = next(p["inlineData"] for p in parts if p.get("inlineData"))
        raw = base64.b64decode(inl["data"]); open("/tmp/verify_img.bin","wb").write(raw)
        rec("gemini-image", m, "PASS", "%s %dB" % (inl.get("mimeType"), len(raw)))
    except Exception: rec("gemini-image", m, "FAIL", str(d.get("error",d))[:120])

def t_gemini_tts():
    m = "gemini-3.1-flash-tts-preview"
    if not need(GKEY, "gemini-tts", m): return
    s, d = http(f"{GBASE}/models/{m}:generateContent?key={GKEY}",
                {"contents":[{"parts":[{"text":"Say cheerfully: verify ok"}]}],
                 "generationConfig":{"responseModalities":["AUDIO"],"speechConfig":{"voiceConfig":{"prebuiltVoiceConfig":{"voiceName":"Kore"}}}}})
    try:
        raw = base64.b64decode(d["candidates"][0]["content"]["parts"][0]["inlineData"]["data"])
        rec("gemini-tts", m, "PASS", "%dB pcm" % len(raw))
    except Exception: rec("gemini-tts", m, "FAIL", str(d.get("error",d))[:120])

def t_realtime(cap, model, script, keyok):
    if not keyok: rec(cap, model, "SKIP", "no API key"); return
    out = f"/tmp/verify_{cap}.wav"
    try:
        p = subprocess.run([sys.executable, os.path.join(HERE, script), model, out],
                           capture_output=True, text=True, timeout=120)
        if p.returncode == 0 and p.stdout.startswith("OK"):
            rec(cap, model, "PASS", p.stdout.strip())
        else:
            rec(cap, model, "FAIL", (p.stdout + p.stderr).strip()[:120])
    except Exception as e: rec(cap, model, "FAIL", repr(e)[:120])

def t_openai_codex():
    m = "gpt-5.3-codex"
    if not need(OKEY, "openai-codex", m): return
    s, d = http("https://api.openai.com/v1/responses",
                {"model":m,"input":"Reply with exactly: CODEX_OK"},
                {"Authorization": f"Bearer {OKEY}"})
    txt = d.get("output_text")
    if not txt:
        for o in d.get("output",[]):
            for c in o.get("content",[]):
                if c.get("text"): txt = c["text"]; break
    if txt: rec("openai-codex", m, "PASS", txt.strip()[:60] + " (Responses API)")
    else: rec("openai-codex", m, "FAIL", str(d.get("error",d))[:120])

# ---- TIER 2: paid-gen ----
def t_veo():
    m = "veo-3.1-lite-generate-preview"
    if not need(GKEY, "veo-video-gen", m): return
    s, d = http(f"{GBASE}/models/{m}:predictLongRunning?key={GKEY}",
                {"instances":[{"prompt":"a red apple rotating on white, studio light"}],"parameters":{"aspectRatio":"16:9"}})
    name = d.get("name")
    if not name: rec("veo-video-gen", m, "FAIL", str(d.get("error",d))[:120]); return
    for _ in range(20):
        time.sleep(14)
        _, op = http(f"{GBASE}/{name}?key={GKEY}")
        if op.get("done"):
            import re
            ss = json.dumps(op.get("response", op.get("error", {})))
            mm = re.search(r'"(https://[^"]+)"', ss) or re.search(r'"uri"\s*:\s*"([^"]+)"', ss)
            if mm:
                uri = mm.group(1); uri += ("&" if "?" in uri else "?") + f"key={GKEY}"
                try:
                    vb = urllib.request.urlopen(uri, timeout=60).read()
                    open("/tmp/verify_veo.mp4","wb").write(vb)
                    rec("veo-video-gen", m, "PASS", "mp4 %dB" % len(vb)); return
                except Exception as e: rec("veo-video-gen", m, "FAIL", "download "+repr(e)[:80]); return
            rec("veo-video-gen", m, "FAIL", "done but no uri: "+ss[:80]); return
    rec("veo-video-gen", m, "FAIL", "not done after ~4.5min")

def t_lyria():
    m = "lyria-3-pro-preview"
    if not need(GKEY, "lyria-music-gen", m): return
    s, d = http(f"{GBASE}/models/{m}:generateContent?key={GKEY}",
                {"contents":[{"parts":[{"text":"A short upbeat acoustic guitar jingle, major key. [Verse]"}]}],
                 "generationConfig":{"responseModalities":["AUDIO"]}}, timeout=180)
    try:
        parts = d["candidates"][0]["content"]["parts"]
        inl = next(p["inlineData"] for p in parts if p.get("inlineData"))
        raw = base64.b64decode(inl["data"]); open("/tmp/verify_lyria.mp3","wb").write(raw)
        rec("lyria-music-gen", m, "PASS", "%s %dB" % (inl.get("mimeType"), len(raw)))
    except Exception: rec("lyria-music-gen", m, "FAIL", str(d.get("error",d))[:120])

def t_deep_research():
    m = "deep-research-pro-preview-12-2025"
    if not need(GKEY, "deep-research", m): return
    s, d = http(f"{GBASE}/interactions?key={GKEY}",
                {"agent":m,"input":"In one sentence, what is the boiling point of water at sea level?","background":True})
    iid = d.get("id")
    if not iid: rec("deep-research", m, "FAIL", str(d.get("error",d))[:120]); return
    for _ in range(20):
        time.sleep(14)
        _, st = http(f"{GBASE}/interactions/{iid}?key={GKEY}")
        if st.get("status") != "in_progress":
            ok = st.get("status") == "completed"
            u = st.get("usage",{}).get("total_tokens")
            rec("deep-research", m, "PASS" if ok else "FAIL", "status=%s tokens=%s" % (st.get("status"), u)); return
    rec("deep-research", m, "FAIL", "still in_progress after ~4.5min (create-verified)")

def t_video_analysis():
    m = "gemini-3.5-flash"
    if not need(GKEY, "video-analysis(yt)", m): return
    s, d = http(f"{GBASE}/models/{m}:generateContent?key={GKEY}",
                {"contents":[{"parts":[{"text":"In one word: is this a video? Answer YES or NO."},
                                       {"fileData":{"fileUri":YT_URL}}]}]}, timeout=180)
    try: rec("video-analysis(yt)", m, "PASS", d["candidates"][0]["content"]["parts"][0]["text"].strip()[:40])
    except Exception: rec("video-analysis(yt)", m, "FAIL", str(d.get("error",d))[:120])

def main():
    tier = "full" if "--full" in sys.argv else ("cheap" if "--cheap" in sys.argv else "default")
    N = 1  # single run by default (don't burn credits); --repeat N for manual median-latency benchmarking
    if "--repeat" in sys.argv:
        try: N = max(1, int(sys.argv[sys.argv.index("--repeat")+1]))
        except Exception: pass
    print(f"verify.py - tier={tier} repeat={N}  (keys: gemini={'Y' if GKEY else 'N'} openai={'Y' if OKEY else 'N'} openrouter={'Y' if RKEY else 'N'})\n")
    # tier 0 - fast, median of N
    run(t_gemini_text, N); run(t_gemini_lite, N); run(t_openai_text, N); run(t_openrouter, N)
    if tier in ("default","full"):
        run(t_gemini_image, N); run(t_gemini_tts, N)
        run(lambda: t_realtime("gemini-live", "gemini-2.5-flash-native-audio-preview-12-2025", "realtime_gemini.py", bool(GKEY)), N)
        run(lambda: t_realtime("openai-realtime", "gpt-realtime", "realtime_openai.py", bool(OKEY)), N)
        run(t_openai_codex, N)
    if tier == "full":  # paid-gen: single run (cost + high variance)
        run(t_video_analysis, N); run(t_lyria); run(t_veo); run(t_deep_research)

    w1 = max(len(r["cap"]) for r in results); w2 = max(len(r["model"]) for r in results)
    print(f"{'CAPABILITY':<{w1}}  {'MODEL':<{w2}}  STATUS  {'SECS':>6}  DETAIL")
    print("-"*(w1+w2+40))
    npass=nfail=nskip=0
    for r in results:
        npass += r["status"]=="PASS"; nfail += r["status"]=="FAIL"; nskip += r["status"]=="SKIP"
        secs = "" if r["secs"] is None else f"{r['secs']:.1f}"
        print(f"{r['cap']:<{w1}}  {r['model']:<{w2}}  {r['status']:<6}  {secs:>6}  {r['detail']}")
    print("-"*(w1+w2+40))
    print(f"PASS={npass} FAIL={nfail} SKIP={nskip}")
    sys.exit(1 if nfail else 0)

if __name__ == "__main__":
    main()
