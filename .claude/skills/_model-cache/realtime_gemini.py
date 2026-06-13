#!/usr/bin/env python3
"""Gemini Live API (BidiGenerateContent) realtime-audio client: text -> WAV.
Usage: realtime_gemini.py <model> <out.wav> [prompt]   (key from $GEMINI_API_KEY)
Prints "OK <bytes>" + exit 0 on success, "ERR <reason>" + exit 1 otherwise.
Verified pattern: ?key= query param, v1beta path, setup -> setupComplete ->
clientContent(turnComplete) -> collect serverContent.modelTurn inlineData (base64
PCM16 24kHz) until turnComplete. Output is 24kHz, not 16kHz."""
import asyncio, json, base64, wave, os, sys
import websockets

MODEL  = sys.argv[1] if len(sys.argv) > 1 else "gemini-2.5-flash-native-audio-preview-12-2025"
OUT    = sys.argv[2] if len(sys.argv) > 2 else "/tmp/gemini_live.wav"
PROMPT = sys.argv[3] if len(sys.argv) > 3 else "Say this exactly, nothing else: realtime audio is working."
KEY    = os.environ.get("GEMINI_API_KEY", "")
if not KEY:  # fall back to the shared resolver (OS store / .env / rc)
    import subprocess
    _lib = os.path.join(os.path.dirname(os.path.abspath(__file__)), "lib.sh")
    KEY = subprocess.run(["bash", "-c", f'. "{_lib}"; resolve_key GEMINI_API_KEY'],
                         capture_output=True, text=True).stdout.strip()
URL = ("wss://generativelanguage.googleapis.com/ws/"
       "google.ai.generativelanguage.v1beta.GenerativeService.BidiGenerateContent"
       f"?key={KEY}")

async def run():
    if not KEY:
        print("ERR no GEMINI_API_KEY"); return 1
    model = MODEL if MODEL.startswith("models/") else f"models/{MODEL}"
    pcm = bytearray()
    async with websockets.connect(URL, max_size=None) as ws:
        await ws.send(json.dumps({"setup": {
            "model": model,
            "generationConfig": {
                "responseModalities": ["AUDIO"],
                "speechConfig": {"voiceConfig": {"prebuiltVoiceConfig": {"voiceName": "Kore"}}},
            },
        }}))
        # wait for setupComplete (or error)
        while True:
            msg = json.loads(await asyncio.wait_for(ws.recv(), timeout=30))
            if "setupComplete" in msg:
                break
            if "error" in msg or "goAway" in msg:
                print("ERR setup:", json.dumps(msg)[:200]); return 1
        await ws.send(json.dumps({"clientContent": {
            "turns": [{"role": "user", "parts": [{"text": PROMPT}]}],
            "turnComplete": True,
        }}))
        while True:
            msg = json.loads(await asyncio.wait_for(ws.recv(), timeout=45))
            sc = msg.get("serverContent", {})
            for part in sc.get("modelTurn", {}).get("parts", []):
                inline = part.get("inlineData")
                if inline and inline.get("data"):
                    pcm += base64.b64decode(inline["data"])
            if sc.get("turnComplete"):
                break
    if not pcm:
        print("ERR no audio returned"); return 1
    with wave.open(OUT, "wb") as w:
        w.setnchannels(1); w.setsampwidth(2); w.setframerate(24000)
        w.writeframes(bytes(pcm))
    print(f"OK {len(pcm)}")
    return 0

try:
    sys.exit(asyncio.run(asyncio.wait_for(run(), timeout=90)))
except Exception as e:
    print("ERR", repr(e)[:200]); sys.exit(1)
