// app.js
/* global buildExportHtml, PRESETS */

let uploadedSVGs = []; // store File objects indexed by slide number

function getDefaults(type) {
  const placeholderSVG = encodeURIComponent(
    `<svg xmlns='http://www.w3.org/2000/svg' width='1440' height='1000'>
      <defs>
        <linearGradient id='g' x1='0' y1='0' x2='1' y2='1'>
          <stop offset='0%' stop-color='#DBE5F1'/>
          <stop offset='100%' stop-color='#F4F7FB'/>
        </linearGradient>
      </defs>
      <rect width='1440' height='1000' fill='url(#g)'/>
      <text x='40' y='70' font-size='40' font-family='Inter, Arial' fill='#223'>${type.toUpperCase()} SLIDE 1</text>
    </svg>`
  );
  const placeholderSVG2 = encodeURIComponent(
    `<svg xmlns='http://www.w3.org/2000/svg' width='1440' height='1000'>
      <rect width='1440' height='1000' fill='#E9F0F8'/>
      <text x='40' y='70' font-size='40' font-family='Inter, Arial' fill='#223'>${type.toUpperCase()} SLIDE 2</text>
    </svg>`
  );

  const slide1 = {
    id: 1,
    file: `data:image/svg+xml;charset=utf-8,${placeholderSVG}`,
    viewBoxWidth: 1440,
    viewBoxHeight: 1000,
    overlays: [
      { action: 'next', x: 1293, y: 40, w: 50, h: 50 }
    ]
  };
  const slide2 = {
    id: 2,
    file: `data:image/svg+xml;charset=utf-8,${placeholderSVG2}`,
    viewBoxWidth: 1440,
    viewBoxHeight: 1000,
    overlays: [
      { action: 'back', x: 101, y: 40, w: 50, h: 50 },
      { action: 'url', url: 'https://buildingtools.co', x: 100, y: 150, w: 280, h: 60 }
    ]
  };
  return [slide1, slide2];
}

// Replace tenant subdomain in all URLs (external tools links)
function replaceTenantSubdomain(slides, oldSubdomain, newSubdomain) {
  const oldPattern = `https://${oldSubdomain}.buildingtools.co`;
  const newPattern = `https://${newSubdomain}.buildingtools.co`;
  return slides.map(slide => ({
    ...slide,
    overlays: slide.overlays.map(ov => {
      if (ov.action === 'url' && ov.url && ov.url.startsWith(oldPattern)) {
        return { ...ov, url: ov.url.replace(oldPattern, newPattern) };
      }
      return ov;
    })
  }));
}

async function readSVGAsDataURL(file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => resolve(reader.result);
    reader.onerror = reject;
    reader.readAsDataURL(file);
  });
}

async function parseSVGDimensions(dataUrl) {
  return new Promise((resolve) => {
    const img = new Image();
    img.onload = () => {
      const w = img.naturalWidth || 1440;
      const h = img.naturalHeight || 1000;
      resolve({ w, h });
    };
    img.onerror = () => resolve({ w: 1440, h: 1000 });
    img.src = dataUrl;
  });
}

function tryParseJSON(text) {
  if (!text) return null;
  try { return JSON.parse(text); } catch (_) { return null; }
}

async function buildConfigFromForm(form) {
  const data = new FormData(form);
  const type = data.get('type');
  const preset = data.get('preset') || 'none';
  const tenantSubdomain = (data.get('tenantSubdomain') || '').trim() || 'tafesa';

  let baseSlides = getDefaults(type);

  // Load preset overlays if selected
  if (preset !== 'none' && typeof PRESETS !== 'undefined' && PRESETS[preset]) {
    baseSlides = PRESETS[preset].map((ps, idx) => {
      // Create placeholder SVG for each preset slide
      const placeholderSVG = encodeURIComponent(
        `<svg xmlns='http://www.w3.org/2000/svg' width='${ps.viewBoxWidth}' height='${ps.viewBoxHeight}'>
          <defs>
            <linearGradient id='g${idx}' x1='0' y1='0' x2='1' y2='1'>
              <stop offset='0%' stop-color='#DBE5F1'/>
              <stop offset='100%' stop-color='#F4F7FB'/>
            </linearGradient>
          </defs>
          <rect width='${ps.viewBoxWidth}' height='${ps.viewBoxHeight}' fill='url(#g${idx})'/>
          <text x='40' y='70' font-size='40' font-family='Inter, Arial' fill='#223'>SLIDE ${ps.id}</text>
          <text x='40' y='120' font-size='20' font-family='Inter, Arial' fill='#666'>Upload SVG to replace</text>
        </svg>`
      );
      return {
        id: ps.id,
        file: `data:image/svg+xml;charset=utf-8,${placeholderSVG}`,
        viewBoxWidth: ps.viewBoxWidth,
        viewBoxHeight: ps.viewBoxHeight,
        overlays: ps.overlays
      };
    });
  }

  // If user uploaded SVGs, replace file paths and parse dimensions
  if (uploadedSVGs.length > 0) {
    for (let i = 0; i < uploadedSVGs.length; i++) {
      if (baseSlides[i]) {
        const dataUrl = await readSVGAsDataURL(uploadedSVGs[i]);
        const { w, h } = await parseSVGDimensions(dataUrl);
        baseSlides[i].file = dataUrl;
        baseSlides[i].viewBoxWidth = w;
        baseSlides[i].viewBoxHeight = h;
      } else {
        // User uploaded more SVGs than preset slots - add new slides
        const dataUrl = await readSVGAsDataURL(uploadedSVGs[i]);
        const { w, h } = await parseSVGDimensions(dataUrl);
        baseSlides.push({
          id: i + 1,
          file: dataUrl,
          viewBoxWidth: w,
          viewBoxHeight: h,
          overlays: []
        });
      }
    }
  }

  // Replace tenant subdomain in all tool links (default was tafesa)
  baseSlides = replaceTenantSubdomain(baseSlides, 'tafesa', tenantSubdomain);

  const cfg = {
    title: data.get('title') || (type === 'activation' ? 'Activation Guide' : 'Implementation Guide'),
    trackingPrefix: data.get('trackingPrefix') || 'tafesa',
    baseUrl: `https://${tenantSubdomain}.buildingtools.co`,
    includeDebug: data.get('includeDebug') === 'on',
    portalId: (data.get('portalId') || '').trim(),
    slides: baseSlides
  };

  // Allow advanced JSON overrides (optional)
  const overrides = tryParseJSON(data.get('overrides'));
  if (overrides) {
    if (Array.isArray(overrides.slides)) cfg.slides = overrides.slides;
    if (typeof overrides.trackingPrefix === 'string') cfg.trackingPrefix = overrides.trackingPrefix;
    if (typeof overrides.baseUrl === 'string') cfg.baseUrl = overrides.baseUrl;
  }
  return cfg;
}

function download(filename, content) {
  const blob = new Blob([content], { type: 'text/html;charset=utf-8' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = filename;
  document.body.appendChild(a);
  a.click();
  a.remove();
  setTimeout(()=>URL.revokeObjectURL(url), 2000);
}

function preview(content) {
  const blob = new Blob([content], { type: 'text/html;charset=utf-8' });
  const url = URL.createObjectURL(blob);
  window.open(url, '_blank');
  setTimeout(()=>URL.revokeObjectURL(url), 60000);
}

(function main(){
  const form = document.getElementById('gen-form');
  const previewBtn = document.getElementById('preview-btn');
  const loadActivationBtn = document.getElementById('load-activation');
  const loadImplementationBtn = document.getElementById('load-implementation');
  const svgFilesInput = document.getElementById('svgFiles');
  const uploadStatus = document.getElementById('uploadStatus');
  const tenantSubdomainInput = document.querySelector('input[name="tenantSubdomain"]');
  const tenantPreview = document.getElementById('tenantPreview');

  // SVG upload handler
  svgFilesInput.addEventListener('change', (e) => {
    // Accept files with .svg extension or image/svg+xml MIME type
    uploadedSVGs = Array.from(e.target.files).filter(f => {
      return f.type === 'image/svg+xml' || f.name.toLowerCase().endsWith('.svg');
    });
    console.log('Files selected:', e.target.files.length);
    console.log('Valid SVGs:', uploadedSVGs.length, uploadedSVGs.map(f => f.name));
    if (uploadedSVGs.length === 0) {
      uploadStatus.textContent = 'No valid SVG files selected';
      uploadStatus.style.color = 'red';
    } else {
      uploadStatus.textContent = `${uploadedSVGs.length} file(s) selected`;
      uploadStatus.style.color = 'green';
    }
  });

  // Tenant subdomain preview
  tenantSubdomainInput.addEventListener('input', (e) => {
    const val = e.target.value.trim() || 'tafesa';
    tenantPreview.textContent = val;
  });

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const cfg = await buildConfigFromForm(form);
    const html = buildExportHtml(cfg);
    const fname = (cfg.title || 'page').toLowerCase().replace(/[^a-z0-9]+/g,'-').replace(/(^-|-$)/g,'') + '.html';
    download(fname, html);
  });

  previewBtn.addEventListener('click', async () => {
    console.log('Preview clicked, uploaded SVGs:', uploadedSVGs.length);
    const cfg = await buildConfigFromForm(form);
    console.log('Config built, slides:', cfg.slides.length);
    console.log('First slide file:', cfg.slides[0]?.file?.substring(0, 50) + '...');
    const html = buildExportHtml(cfg);
    preview(html);
  });

  function setOverrides(slides){
    const ta = document.querySelector('textarea[name="overrides"]');
    ta.value = JSON.stringify({ slides }, null, 2);
  }

  if (loadActivationBtn) {
    loadActivationBtn.addEventListener('click', () => {
      console.log('Load Activation demo clicked');
      try {
        const slides = getDefaults('activation');
        // add a demo video overlay and a tools link
        slides[0].videos = [{ src: 'https://cdn.coverr.co/videos/coverr-building-sun-1080p.mp4', x: 900, y: 320, w: 360, h: 200 }];
        slides[1].overlays.push({ action:'url', url:'https://tafesa.buildingtools.co', x: 500, y: 300, w: 280, h: 60 });
        setOverrides(slides);
        alert('Activation demo loaded! Check the Advanced overrides section.');
      } catch(err) {
        console.error('Error loading activation demo:', err);
        alert('Error: ' + err.message);
      }
    });
  }

  if (loadImplementationBtn) {
    loadImplementationBtn.addEventListener('click', () => {
      console.log('Load Implementation demo clicked');
      try {
        const slides = getDefaults('implementation');
        slides[0].overlays.push({ action:'next', x: 156, y: 659, w: 174, h: 52 });
        slides[1].overlays.push({ action:'back', x: 60, y: 823, w: 142, h: 56 });
        setOverrides(slides);
        alert('Implementation demo loaded! Check the Advanced overrides section.');
      } catch(err) {
        console.error('Error loading implementation demo:', err);
        alert('Error: ' + err.message);
      }
    });
  }
})();
