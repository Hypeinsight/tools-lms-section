# Deployment Process for Tools LMS Section

## Overview
This project uses Git + Render for automatic deployment. When changes are pushed to the `main` branch, Render automatically rebuilds and deploys the site.

## Git Workflow

### 1. Check Status
```bash
git --no-pager status
```

### 2. Stage Changes
```bash
git add .
```

### 3. Commit Changes
```bash
git commit -m "Your commit message here"
```

**Important**: Always include co-author attribution in commits:
```bash
git commit -m "Description of changes

Co-Authored-By: Warp <agent@warp.dev>"
```

### 4. Push to Remote
```bash
git push
```

After pushing, Render will automatically:
- Detect the changes
- Rebuild the site
- Deploy to production

**Deployment URLs:**
- Swinburne: https://tools-lms-section.onrender.com/edu-practical-guide-implementation-swinburne.html
- RMIT: https://tools-lms-section.onrender.com/edu-practical-guide-implementation-rmit.html

---

## HubSpot Embed Codes

### RMIT Version

```html
<!-- Add this script first -->
<script>
(function() {
  // Create modal container in parent page
  const modalHTML = `
    <div id="parent-video-modal" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0, 0, 0, 0.9); z-index: 99999; justify-content: center; align-items: center;">
      <button id="parent-close-video" style="position: absolute; top: 20px; right: 20px; width: 40px; height: 40px; background: rgba(255, 255, 255, 0.9); border: none; border-radius: 50%; font-size: 24px; line-height: 1; cursor: pointer; color: #252D36; font-weight: 700;">&times;</button>
      <video id="parent-video-player" controls style="max-width: 90%; max-height: 90vh; border-radius: 8px;">
        <source id="parent-video-source" src="" type="video/mp4" />
      </video>
    </div>
  `;
  
  // Add modal to page when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
      document.body.insertAdjacentHTML('beforeend', modalHTML);
      setupModalHandlers();
    });
  } else {
    document.body.insertAdjacentHTML('beforeend', modalHTML);
    setupModalHandlers();
  }
  
  function setupModalHandlers() {
    const modal = document.getElementById('parent-video-modal');
    const video = document.getElementById('parent-video-player');
    const closeBtn = document.getElementById('parent-close-video');
    
    function closeModal() {
      modal.style.display = 'none';
      video.pause();
    }
    
    closeBtn.addEventListener('click', closeModal);
    modal.addEventListener('click', function(e) {
      if (e.target === modal) {
        closeModal();
      }
    });
    
    // ESC key to close
    document.addEventListener('keydown', function(e) {
      if (e.key === 'Escape' && modal.style.display === 'flex') {
        closeModal();
      }
    });
  }
  
  // Listen for messages from the iframe
  window.addEventListener('message', function(event) {
    const iframe = document.getElementById('tools-competency-iframe');
    if (!iframe) return;
    
    const data = event.data;
    
    // Handle iframe height resize
    if (data.action === 'resizeIframe' && data.height) {
      iframe.style.height = data.height + 'px';
      console.log('Resized iframe to height:', data.height);
    }
    
    // Handle scroll to top request
    if (data.action === 'scrollToTop') {
      const wrapper = document.getElementById('iframe-wrapper');
      if (wrapper) {
        wrapper.scrollIntoView({ behavior: 'smooth', block: 'start' });
      } else {
        window.scrollTo({ top: 0, behavior: 'smooth' });
      }
      console.log('Scrolled to top');
    }
    
    // Handle video modal request
    if (data.action === 'showVideoModal' && data.videoSrc) {
      const modal = document.getElementById('parent-video-modal');
      const source = document.getElementById('parent-video-source');
      const video = document.getElementById('parent-video-player');
      
      const extension = data.videoSrc.split('.').pop().toLowerCase();
      source.type = extension === 'webm' ? 'video/webm' : 'video/mp4';
      source.src = data.videoSrc;
      video.load();
      modal.style.display = 'flex';
      console.log('Showing video modal:', data.videoSrc);
    }
  });
})();
</script>

<div id="iframe-wrapper" style="width: 100% !important; max-width: 1440px !important; margin: 0 auto !important; display: block !important;">
  <iframe id="tools-competency-iframe" 
          style="border: none !important; display: block !important; margin: 0px auto;" 
          xml="lang" 
          src="https://tools-lms-section.onrender.com/edu-practical-guide-implementation-rmit.html" 
          width="1440" 
          height="1175" 
          data-service="info.buildingtools" 
          frameborder="0" 
          scrolling="no">
  </iframe>
</div>
```

### Swinburne Version

```html
<!-- Add this script first -->
<script>
(function() {
  // Create modal container in parent page
  const modalHTML = `
    <div id="parent-video-modal" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0, 0, 0, 0.9); z-index: 99999; justify-content: center; align-items: center;">
      <button id="parent-close-video" style="position: absolute; top: 20px; right: 20px; width: 40px; height: 40px; background: rgba(255, 255, 255, 0.9); border: none; border-radius: 50%; font-size: 24px; line-height: 1; cursor: pointer; color: #252D36; font-weight: 700;">&times;</button>
      <video id="parent-video-player" controls style="max-width: 90%; max-height: 90vh; border-radius: 8px;">
        <source id="parent-video-source" src="" type="video/mp4" />
      </video>
    </div>
  `;
  
  // Add modal to page when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
      document.body.insertAdjacentHTML('beforeend', modalHTML);
      setupModalHandlers();
    });
  } else {
    document.body.insertAdjacentHTML('beforeend', modalHTML);
    setupModalHandlers();
  }
  
  function setupModalHandlers() {
    const modal = document.getElementById('parent-video-modal');
    const video = document.getElementById('parent-video-player');
    const closeBtn = document.getElementById('parent-close-video');
    
    function closeModal() {
      modal.style.display = 'none';
      video.pause();
    }
    
    closeBtn.addEventListener('click', closeModal);
    modal.addEventListener('click', function(e) {
      if (e.target === modal) {
        closeModal();
      }
    });
    
    // ESC key to close
    document.addEventListener('keydown', function(e) {
      if (e.key === 'Escape' && modal.style.display === 'flex') {
        closeModal();
      }
    });
  }
  
  // Listen for messages from the iframe
  window.addEventListener('message', function(event) {
    const iframe = document.getElementById('tools-competency-iframe');
    if (!iframe) return;
    
    const data = event.data;
    
    // Handle iframe height resize
    if (data.action === 'resizeIframe' && data.height) {
      iframe.style.height = data.height + 'px';
      console.log('Resized iframe to height:', data.height);
    }
    
    // Handle scroll to top request
    if (data.action === 'scrollToTop') {
      const wrapper = document.getElementById('iframe-wrapper');
      if (wrapper) {
        wrapper.scrollIntoView({ behavior: 'smooth', block: 'start' });
      } else {
        window.scrollTo({ top: 0, behavior: 'smooth' });
      }
      console.log('Scrolled to top');
    }
    
    // Handle video modal request
    if (data.action === 'showVideoModal' && data.videoSrc) {
      const modal = document.getElementById('parent-video-modal');
      const source = document.getElementById('parent-video-source');
      const video = document.getElementById('parent-video-player');
      
      const extension = data.videoSrc.split('.').pop().toLowerCase();
      source.type = extension === 'webm' ? 'video/webm' : 'video/mp4';
      source.src = data.videoSrc;
      video.load();
      modal.style.display = 'flex';
      console.log('Showing video modal:', data.videoSrc);
    }
  });
})();
</script>

<div id="iframe-wrapper" style="width: 100% !important; max-width: 1440px !important; margin: 0 auto !important; display: block !important;">
  <iframe id="tools-competency-iframe" 
          style="border: none !important; display: block !important; margin: 0px auto;" 
          xml="lang" 
          src="https://tools-lms-section.onrender.com/edu-practical-guide-implementation-swinburne.html" 
          width="1440" 
          height="1175" 
          data-service="info.buildingtools" 
          frameborder="0" 
          scrolling="no">
  </iframe>
</div>
```

---

## HubSpot Embed Features

The embed code handles:
- **Video Modal**: Creates video modal in parent page (works around HubSpot iframe restrictions)
- **Dynamic Resizing**: Iframe automatically resizes based on content
- **Scroll to Top**: Automatically scrolls to top when navigating between slides
- **ESC Key Support**: Press ESC to close video modal
- **Click-to-Close**: Click outside video to close modal

---

## Project Structure

```
tools-lms-section/
├── edu-practical-guide-implementation.html (base version)
├── edu-practical-guide-implementation-swinburne.html
├── edu-practical-guide-implementation-rmit.html
├── EDU Practical Guide (Implementation)/
│   ├── [SVG files for each slide]
│   ├── Accordion/
│   │   └── [Accordion SVG files]
│   └── Show Me/
│       └── Nav buttons.svg
├── DEPLOYMENT_PROCESS.md (this file)
└── HUBSPOT_EMBED_CODE.html (backup embed code template)
```

---

## Notes

- Always test locally before pushing to production
- The only difference between Swinburne and RMIT versions is the domain used in URLs:
  - Swinburne: `swinburne.buildingtools.co`
  - RMIT: `rmit.buildingtools.co`
- Video files are hosted on HubSpot CDN
- Render automatically deploys from the `main` branch
