# /caveman HTML output (loaded only when an HTML deliverable is requested)

User asks for HTML deliverable while caveman active ("caveman html", "html version", report or gallery as HTML) -> build single-file caveman-style HTML page.

Text: caveman rules apply to all rendered prose. Layout: visual-first per deep-research skill `reference/dashboard.md` (TL;DR-first sections, real visuals not styled prose, dark/light theme, mobile reflow, no em dashes). Read that file before building.

Images: every image opens in PhotoSwipe lightbox tuned to iPhone Photos feel. Copy include + init + options from `assets/photoswipe-iphone.html`. Do NOT re-derive or tweak settings from memory; asset is the single source, values researched against PhotoSwipe v5 docs + iOS behavior.

Gates (all must pass, else not done):

1. Every gallery `<img>` wrapped in `<a href="fullsize" data-pswp-width="W" data-pswp-height="H">`. Missing real pixel width/height -> zoom transition breaks. Not allowed.
2. Options object from asset used verbatim: zoom open/close animation, iOS timing + easing, single tap toggles UI, double tap zooms, pinch close, vertical drag close.
3. Page viewport + touch CSS from asset present (else iPhone Safari double-tap fights the lightbox).
4. Test 390px mobile + desktop width before shipping.
