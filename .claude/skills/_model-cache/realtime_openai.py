#!/usr/bin/env python3
"""OpenAI Realtime API (GA gpt-realtime) realtime-audio client: text -> WAV.
Usage: realtime_openai.py <model> <out.wav> [prompt]   (key from $OPENAI_API_KEY)
Prints "OK <bytes>" + exit 0, "ERR <reason>" + exit 1.
GA gotchas baked in: Authorization Bearer header, NO OpenAI-Beta header, `format`
is an OBJECT {"type":"audio/pcm","rate":24000}, must send response.create, collect
response.output_audio.delta (base64 PCM16 24kHz) until response.done."""
import asyncio, json, base64, wave, os, sys
import websockets

MODEL  = sys.argv[1] if len(sys.argv) > 1 else "gpt-realtime"
OUT    = sys.argv[2] if len(sys.argv) > 2 else "/tmp/openai_live.wav"
PROMPT = sys.argv[3] if len(sys.argv) > 3 else "Say this exactly, nothing else: realtime audio is working."
KEY    = os.environ.get("OPENAI_API_KEY", "")
if not KEY:  # fall back to the shared resolver (OS store / .env / rc)
    import subprocess
    _lib = os.path.join(os.path.dirname(os.path.abspath(__file__)), "lib.sh")
    KEY = subprocess.run(["bash", "-c", f'. "{_lib}"; resolve_key OPENAI_API_KEY'],
                         capture_output=True, text=True).stdout.strip()
URL    = f"wss://api.openai.com/v1/realtime?model={MODEL}"

# websockets>=13 uses additional_headers; 10.x/11/12 use extra_headers. Detect.
import inspect
_hdr_kw = "additional_headers" if "additional_headers" in inspect.signature(websockets.connect).parameters else "extra_headers"

async def run():
    if not KEY:
        print("ERR no OPENAI_API_KEY"); return 1
    pcm = bytearray()
    kw = {_hdr_kw: [("Authorization", f"Bearer {KEY}")], "max_size": None}
    async with websockets.connect(URL, **kw) as ws:
        await ws.send(json.dumps({"type": "session.update", "session": {
            "type": "realtime",
            "output_modalities": ["audio"],
            "audio": {"output": {"format": {"type": "audio/pcm", "rate": 24000}, "voice": "marin"}},
        }}))
        await ws.send(json.dumps({"type": "conversation.item.create", "item": {
            "type": "message", "role": "user",
            "content": [{"type": "input_text", "text": PROMPT}]}}))
        await ws.send(json.dumps({"type": "response.create"}))
        while True:
            ev = json.loads(await asyncio.wait_for(ws.recv(), timeout=45))
            t = ev.get("type", "")
            if t == "response.output_audio.delta":
                pcm += base64.b64decode(ev["delta"])
            elif t == "response.done":
                break
            elif t == "error":
                print("ERR", json.dumps(ev.get("error", ev))[:200]); return 1
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
