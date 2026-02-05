// templates.js
// Build a self-contained, single-file HTML string with inline CSS + JS

function buildExportHtml(cfg) {
  const safeTitle = (cfg.title || 'TAFE Guide').replace(/</g,'&lt;');
  const includeDebug = !!cfg.includeDebug;
  const slides = cfg.slides || [];
  const trackingPrefix = cfg.trackingPrefix || 'tafesa';
  const baseUrl = cfg.baseUrl || '';
  const portalId = cfg.portalId || '';

  const configJson = JSON.stringify({
    trackingPrefix,
    baseUrl,
    slides
  }, null, 2);

  const hsScript = portalId ? `\n<script type="text/javascript" async defer src="//js.hs-scripts.com/${portalId}.js"></script>` : '';

  return `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>${safeTitle}</title>
<style>
  :root { --max-w: 1440px; }
  html,body { margin:0; padding:0; background:#DBE5F1; font-family: Inter, system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif; color:#111; }
  .page { display:flex; justify-content:center; padding:0; }
  .container { position:relative; width:100%; max-width: var(--max-w); background:#DBE5F1; border-radius:8px; box-shadow:0 10px 40px rgba(0,0,0,0.25); }
  .component { display:none; position:relative; background:#DBE5F1; }
  .component.active { display:block; }
  .svg-host { position:relative; width:100%; height:auto; display:block; background:#DBE5F1; }
  .svg-host img { width:100%; height:auto; display:block; }
  .overlay-root { position:absolute; inset:0; pointer-events:none; z-index:10; }
  .click-area { position:absolute; border-radius:8px; pointer-events:auto; cursor:pointer; }
  .image-embed, .video-embed { position:absolute; border:none; border-radius:16px; }
  .image-embed { pointer-events:none; }

  /* Video Modal */
  .video-modal { display:none; position:fixed; inset:0; background:rgba(0,0,0,.9); z-index:99999; justify-content:center; align-items:center; }
  .video-modal.active { display:flex; }
  .video-modal .close-button { position:absolute; top:20px; right:20px; width:40px; height:40px; background:rgba(255,255,255,.9); border:none; border-radius:50%; font-size:24px; font-weight:700; cursor:pointer; color:#252D36; }

  /* Debug tool */
  .debug-toggle { position:fixed; bottom:20px; left:20px; z-index:100000; width:56px; height:56px; border-radius:50%; border:none; cursor:pointer; color:#fff; font-size:22px; font-weight:800; box-shadow:0 8px 20px rgba(0,0,0,.25); ${includeDebug ? '' : 'display:none;'} }
  .debug-toggle.on { background:#bfe002; color:#252d36; }
  .debug-toggle.off { background:#1482ff; }
  .debug-info { position:fixed; bottom:20px; left:90px; z-index:100000; display:none; background:rgba(37,45,54,.96); color:#fff; padding:12px 14px; border-radius:8px; font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; font-size:12px; min-width:220px; box-shadow:0 8px 20px rgba(0,0,0,.25); }
  .debug-info.active { display:block; }
  .debug-selection { position:fixed; border:2px solid #BFE002; background: rgba(191,224,2,.12); pointer-events:none; z-index: 99998; }
</style>
</head>
<body>
<div class="page">
  <div class="container" id="container"></div>
</div>
<div class="video-modal" id="videoModal"><button class="close-button" id="closeVideoModal">&times;</button><video id="modalVideo" controls style="max-width:90%; max-height:90vh; border-radius:8px;"><source id="modalVideoSource" src="" type="video/mp4" /></video></div>
<button id="debugToggle" class="debug-toggle off" title="Toggle Debug">🎯</button>
<div id="debugInfo" class="debug-info"><div id="debugInfoContent">Drag to select...</div></div>
<script>
  const moduleConfig = ${configJson};
  const container = document.getElementById('container');
  const state = { index: 0, loaded: new Array(moduleConfig.slides.length).fill(false), viewBox: new Array(moduleConfig.slides.length).fill(null) };

  // Tracking (HubSpot optional)
  function updateHubSpotProperty(propertyName, value) {
    if (typeof window._hsq !== 'undefined') {
      const properties = {}; properties[propertyName] = value; window._hsq.push(['identify', properties]);
    }
  }
  const trackingState = { highestSlideViewed: 1, videos: 0 };
  function trackSlideView(slideNumber){ if(slideNumber>trackingState.highestSlideViewed){trackingState.highestSlideViewed=slideNumber; updateHubSpotProperty(moduleConfig.trackingPrefix+'_last_slide_viewed', slideNumber);} }
  function trackVideoWatch(){ trackingState.videos++; updateHubSpotProperty(moduleConfig.trackingPrefix+'_videos_watched', trackingState.videos); }

  function buildDOM(){
    moduleConfig.slides.forEach((c,i)=>{
      const comp=document.createElement('div'); comp.className='component'+(i===0?' active':''); comp.dataset.idx=i;
      const host=document.createElement('div'); host.className='svg-host';
      const img=document.createElement('img'); img.src=c.file; img.setAttribute('aria-label', 'Slide '+c.id);
      const overlays=document.createElement('div'); overlays.className='overlay-root';
      host.appendChild(img); host.appendChild(overlays); comp.appendChild(host); container.appendChild(comp);
      state.viewBox[i]={w:c.viewBoxWidth||1440,h:c.viewBoxHeight||2000};
      img.addEventListener('load',()=>{ state.loaded[i]=true; renderOverlays(i); });
    });
  }

  function renderOverlays(idx){
    const compEl=container.querySelector('.component[data-idx="'+idx+'"]'); if(!compEl) return; const root=compEl.querySelector('.overlay-root'); root.innerHTML=''; const vb=state.viewBox[idx]; if(!vb) return;
    const slide=moduleConfig.slides[idx];
    (slide.images||[]).forEach(img=>{ const el=document.createElement('img'); el.className='image-embed'; el.src=img.src; styleABS(el, vb, img); el.style.objectFit='contain'; root.appendChild(el); });
    (slide.videos||[]).forEach(v=>{ const el=document.createElement('video'); el.className='video-embed'; el.controls=true; const s=document.createElement('source'); s.src=v.src; s.type='video/mp4'; el.appendChild(s); styleABS(el, vb, v); el.addEventListener('play',()=>trackVideoWatch(),{once:true}); root.appendChild(el); });
    (slide.overlays||[]).forEach(o=>{ const el=document.createElement('div'); el.className='click-area'; styleABS(el, vb, o); el.title=o.action.toUpperCase(); el.addEventListener('click',(e)=>{e.preventDefault();e.stopPropagation();handleAction(o);}); root.appendChild(el); });
  }

  function styleABS(el, vb, box){ el.style.position='absolute'; el.style.left=(box.x/vb.w*100)+'%'; el.style.top=(box.y/vb.h*100)+'%'; el.style.width=(box.w/vb.w*100)+'%'; el.style.height=(box.h/vb.h*100)+'%'; }

  function handleAction(o){ if(o.action==='next'){goTo(state.index+1);} else if(o.action==='back'){goTo(state.index-1);} else if(o.action==='url'&&o.url){ window.open(o.url,'_blank','noopener'); } else if(o.action==='video'&&o.src){ showVideoModal(o.src); } }

  function goTo(newIndex){ const max=moduleConfig.slides.length-1; const n=Math.max(0,Math.min(max,newIndex)); if(n===state.index) return; const prev=container.querySelector('.component[data-idx="'+state.index+'"]'); const next=container.querySelector('.component[data-idx="'+n+'"]'); if(prev) prev.classList.remove('active'); if(next) next.classList.add('active'); state.index=n; if(state.viewBox[n]) renderOverlays(n); trackSlideView(n+1); window.scrollTo({top:0,behavior:'smooth'}); }

  // Video modal
  function showVideoModal(src){ const modal=document.getElementById('videoModal'); const video=document.getElementById('modalVideo'); const source=document.getElementById('modalVideoSource'); const ext=(src.split('.').pop()||'mp4').toLowerCase(); source.type= ext==='webm'?'video/webm':'video/mp4'; source.src=src; video.load(); modal.classList.add('active'); }
  function closeVideoModal(){ const modal=document.getElementById('videoModal'); const video=document.getElementById('modalVideo'); video.pause(); modal.classList.remove('active'); }
  document.getElementById('closeVideoModal').addEventListener('click', closeVideoModal);

  // Debug tool (client-side overlay measurement)
  (function(){
    const btn=document.getElementById('debugToggle'); const info=document.getElementById('debugInfo'); if(!btn) return;
    let on=false; let drag=null; let sel=null;
    function fmt(n){ return (Math.round(n*1000)/1000).toFixed(3); }
    btn.addEventListener('click',()=>{ on=!on; btn.className='debug-toggle '+(on?'on':'off'); info.classList.toggle('active', on); document.getElementById('debugInfoContent').innerHTML='Drag to select an area...'; });
    container.addEventListener('mousedown',(e)=>{ if(!on) return; const comp=container.querySelector('.component.active .svg-host'); if(!comp) return; const rect=comp.getBoundingClientRect(); const vb=state.viewBox[state.index]; drag={startX:e.clientX,startY:e.clientY,rect,vb}; sel=document.createElement('div'); sel.className='debug-selection'; sel.style.left=e.clientX+'px'; sel.style.top=e.clientY+'px'; sel.style.width='0px'; sel.style.height='0px'; document.body.appendChild(sel); e.preventDefault(); });
    document.addEventListener('mousemove',(e)=>{ if(!drag||!sel) return; const w=Math.abs(e.clientX-drag.startX), h=Math.abs(e.clientY-drag.startY); const l=Math.min(e.clientX,drag.startX), t=Math.min(e.clientY,drag.startY); sel.style.left=l+'px'; sel.style.top=t+'px'; sel.style.width=w+'px'; sel.style.height=h+'px'; const svgX=(l-drag.rect.left)/drag.rect.width*drag.vb.w; const svgY=(t-drag.rect.top)/drag.rect.height*drag.vb.h; const svgW=w/drag.rect.width*drag.vb.w; const svgH=h/drag.rect.height*drag.vb.h; document.getElementById('debugInfoContent').innerHTML= '<div><b>Slide '+(state.index+1)+'</b></div>'+
      '<div>x:'+fmt(svgX)+' y:'+fmt(svgY)+' w:'+fmt(svgW)+' h:'+fmt(svgH)+'</div>'+
      '<div style="margin-top:6px;color:#bfe002">{ action: "url", url: "https://example.com", x: '+fmt(svgX)+', y: '+fmt(svgY)+', w: '+fmt(svgW)+', h: '+fmt(svgH)+' }</div>'; });
    document.addEventListener('mouseup',()=>{ if(sel){ sel.remove(); sel=null; } drag=null; });
  })();

  // Keyboard nav
  document.addEventListener('keydown',(e)=>{ if(e.key==='ArrowRight'||e.key==='ArrowDown'){ e.preventDefault(); goTo(state.index+1);} else if(e.key==='ArrowLeft'||e.key==='ArrowUp'){ e.preventDefault(); goTo(state.index-1);} else if(e.key==='Escape'){ closeVideoModal(); } });

  // Boot
  buildDOM();
  trackSlideView(1);
</script>
${hsScript}
</body></html>`;
}

if (typeof module !== 'undefined') { module.exports = { buildExportHtml }; }
