You are a senior web-graphics performance engineer.

Context:

- App: single-file three.js room planner.
- Size: ~950 KB decoded / 268 KB gzip.
- JavaScript: inline in the HTML.
- Hosting: Cloudflare Worker static asset.
- No service worker.
- No code splitting.
- Benchmark: live URL in desktop Chrome on an M1 Max, cache disabled, 3 runs.
- Incognito is the user’s benchmark. It has no localStorage-cached AA policy, so the AA probe creates an extra GL context first.

Desktop measurements:

- TTFB: 72-148 ms.
- responseEnd: 97-168 ms.
- One startup long task: 174-199 ms.
- appReady, defined as the first rendered 3D frame: 310-394 ms.
- CPU profile of the startup long task:
  - `"(program)"` parse/compile: 88 ms.
  - First render: 115 ms inclusive.
  - WebGLProgram `getUniforms`/link within first render: 72 ms.
  - There are 39 distinct `Mesh*Material` instances.
  - `shadowMap` uses PCF, creating depth programs too.
  - Scene build: ~30 ms.
  - `renderer.setSize`: 12 ms.
- The control panel is prerendered static HTML and paints ~150 ms before the 3D canvas displays anything.
- User perception: “panel is instant, scene arrives ~500 ms later.”

Earlier phone measurements at 4× CPU throttle:

- Parse: 180 ms.
- Scene build/first render: 540 ms.

Goal:

Minimize both:

1. Time from navigation start to the first correct 3D frame.
2. The perceived gap between panel paint and scene paint.

Include real engineering improvements and perception techniques, but rank real improvements first.

Deliverable:

Provide concrete, three.js-r16x-specific techniques ranked by:

`expected milliseconds saved on desktop cold start / (risk + effort)`

For every technique, include:

- Mechanism.
- Expected saving, with reasoning based on the measurements above.
- How to measure it.
- The trap that can make it fail.

Cover at least all of the following:

- Move the script from inline HTML to an external file to enable off-main-thread streaming compilation.
- Explain whether `defer`, modules, and preload ordering matter with a single-origin Worker.
- V8 code-cache behavior for inline versus external scripts across incognito sessions and first visits.
- Brotli versus gzip from the Worker.
- `renderer.compileAsync` with `KHR_parallel_shader_compile`.
- Reduce program count through material deduplication.
- Disable shadows for the first frame and enable them on the next frame.
- Use `MeshBasicMaterial` versus `MeshStandardMaterial` for the first frame.
- `preserveDrawingBuffer` and context-creation costs.
- The AA-probe extra-context cost in incognito.
- Render the first frame at lower resolution and upscale it.
- Split scene building across frames.
- `<link rel=preload>`.
- Cloudflare 103 Early Hints.
- HTML streaming so the panel can paint while the script downloads.
- As the final perception option, delay the panel reveal so the panel and scene appear together. Explain when this is honest versus a cheat, and describe the best-practice staged reveal, such as a shared 120 ms crossfade.

Finish with:

- A recommended plan containing at most 5 steps.
- A realistic floor for desktop cold-start `appReady` with everything applied.

Be concrete. Do not give generic advice.
