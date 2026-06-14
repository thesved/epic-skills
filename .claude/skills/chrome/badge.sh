#!/usr/bin/env bash
# badge.sh - show/clear a "this tab is being driven" indicator on the CURRENT
# session's tab. Goes through cdp.py, so it targets the same tab that session
# owns (no focus stealing, no extra tab). Paints its OWN favicon (a dark rounded
# icon + red dot) so it never depends on / taints the page's real favicon, and
# also prefixes the tab title with a red circle. A MutationObserver re-applies
# it if the page (SPA) overwrites the favicon.
#
#   badge.sh on  [label] [dotcolor]   # default label "A", dot "#ef4444"
#   badge.sh off
#
# Honors the same env as cdp.py: CHROME_CDP_PORT, CDP_SESSION,
# CLAUDE_CODE_SESSION_ID. NOTE: a page navigation wipes the injected badge
# (new document), so re-run `badge.sh on` after navigating if you want it to persist.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CMD="${1:-on}"; LABEL="${2:-A}"; COLOR="${3:-#ef4444}"

run_eval() { # $1 = JS expression
  local params
  params=$(JS="$1" python3 -c 'import json,os;print(json.dumps({"expression":os.environ["JS"]}))')
  python3 "$HERE/cdp.py" Runtime.evaluate "$params"
}

case "$CMD" in
  on)
    JS=$(LABEL="$LABEL" COLOR="$COLOR" python3 - <<'PY'
import json, os
js = r'''(()=>{
  const ID="__cdp_badge_icon", LABEL=%s, COLOR=%s;
  function paint(){
    const c=document.createElement("canvas"); c.width=c.height=32;
    const x=c.getContext("2d");
    x.fillStyle="#1f2937";
    if(x.roundRect){x.beginPath();x.roundRect(0,0,32,32,6);x.fill();}else{x.fillRect(0,0,32,32);}
    if(LABEL){x.fillStyle="#e5e7eb";x.font="bold 18px sans-serif";x.textAlign="center";x.textBaseline="middle";x.fillText(String(LABEL).slice(0,2),15,17);}
    x.fillStyle=COLOR; x.beginPath(); x.arc(24,8,7,0,2*Math.PI); x.fill();
    x.strokeStyle="#fff"; x.lineWidth=1.5; x.stroke();
    let l=document.getElementById(ID);
    if(!l){l=document.createElement("link");l.id=ID;l.rel="icon";}
    document.querySelectorAll("link[rel~='icon']:not(#"+ID+")").forEach(e=>e.remove());
    l.href=c.toDataURL("image/png"); document.head.appendChild(l);
  }
  if(window.__cdpBadge){paint();return "rebadged";}
  document.title="🔴 "+document.title.replace(/^🔴\s*/,"");
  paint();
  const mo=new MutationObserver(()=>{if(!document.getElementById(ID))paint();});
  mo.observe(document.head,{childList:true});
  window.__cdpBadge={stop(){mo.disconnect();const l=document.getElementById(ID);if(l)l.remove();document.title=document.title.replace(/^🔴\s*/,"");delete window.__cdpBadge;}};
  return "badged";
})()''' % (json.dumps(os.environ["LABEL"]), json.dumps(os.environ["COLOR"]))
print(js)
PY
)
    run_eval "$JS" ;;
  off)
    run_eval 'window.__cdpBadge&&window.__cdpBadge.stop(),"unbadged"' ;;
  *)
    echo "usage: badge.sh on [label] [dotcolor] | off" >&2; exit 1 ;;
esac
