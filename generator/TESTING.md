# Testing Guide

## Quick Test Checklist

### 1. Basic Functionality
- [ ] Open `index.html` in browser (no errors in console)
- [ ] All form fields render correctly
- [ ] Preset dropdown shows "Implementation (TAFE SA) - 13 slides"
- [ ] Tenant subdomain preview updates live as you type

### 2. Preset Loading
- [ ] Select "Implementation (TAFE SA)" preset
- [ ] Click **Preview**
- [ ] Verify 13 slides load with placeholder graphics
- [ ] Test navigation (Next/Back buttons)
- [ ] Verify clickable overlays are present (use Debug Tool)

### 3. SVG Upload Workflow
- [ ] Prepare 13 SVG files named `slide-1.svg` through `slide-13.svg`
- [ ] Select "Implementation (TAFE SA)" preset
- [ ] Click **Upload SVGs** and select all 13 files
- [ ] Verify upload status shows "13 file(s) selected"
- [ ] Click **Preview**
- [ ] Confirm all uploaded SVGs appear correctly
- [ ] Verify overlays are positioned correctly on each slide

### 4. Tenant Subdomain Replacement
- [ ] Select "Implementation (TAFE SA)" preset
- [ ] Change **Tenant Subdomain** to "testclient"
- [ ] Verify preview updates to show "testclient"
- [ ] Click **Preview**
- [ ] Navigate to Slide 2 (has external tool links)
- [ ] Enable **Debug Overlays**
- [ ] Hover over URL overlays
- [ ] Click overlay to open link in new tab
- [ ] Verify URL starts with `https://testclient.buildingtools.co`

### 5. Debug Tool
- [ ] Ensure "Include debug tool" is checked
- [ ] Click **Preview**
- [ ] Look for **Debug Overlays** toggle button (bottom-right)
- [ ] Click toggle to enable debug mode
- [ ] Hover over Next button → see green debug box with coordinates
- [ ] Hover over video overlay → see purple debug box
- [ ] Hover over URL link → see orange debug box
- [ ] Click any debug overlay → verify coordinates copied to clipboard
- [ ] Paste (Ctrl+V) → should show JSON like `{"action":"next","x":1293,"y":80,"w":50,"h":50}`

### 6. Video Overlays
- [ ] Generate Implementation page with preset
- [ ] Navigate to Slide 2
- [ ] Click the video overlay (top-right)
- [ ] Verify modal opens with video player
- [ ] Verify video loads and plays
- [ ] Click close button or outside modal → verify modal closes
- [ ] Test ESC key → modal closes

### 7. Export & Download
- [ ] Fill in all form fields
- [ ] Click **Generate HTML**
- [ ] Verify file downloads with correct name (e.g., `implementation-guide.html`)
- [ ] Open downloaded file in browser
- [ ] Test all functionality (navigation, videos, links, debug)
- [ ] Verify file is self-contained (no external dependencies except videos/images)

### 8. HubSpot Tracking
- [ ] Enter HubSpot Portal ID: `20832146`
- [ ] Generate page
- [ ] Check HTML source for tracking script injection
- [ ] Upload to HubSpot File Manager
- [ ] Open hosted page
- [ ] Verify HubSpot analytics capture page views

## Regression Tests

### Edge Cases
- [ ] Upload only 5 SVGs for 13-slide preset → verify first 5 slides have SVGs, rest are placeholders
- [ ] Upload 15 SVGs for 13-slide preset → verify all 15 slides are created
- [ ] Upload non-SVG file → verify it's filtered out, status shows 0 files
- [ ] Leave tenant subdomain empty → defaults to "tafesa"
- [ ] Uncheck "Include debug tool" → verify debug toggle is absent in preview
- [ ] Clear Portal ID → verify no tracking script injected

### Browser Compatibility
- [ ] Chrome/Edge (Chromium)
- [ ] Firefox
- [ ] Safari (if available)
- [ ] Mobile Safari (responsive view)
- [ ] Mobile Chrome (responsive view)

### Performance
- [ ] Upload 13 large SVG files (>1MB each) → verify no freeze
- [ ] Generate page with all 13 slides → verify file size reasonable (<10MB)
- [ ] Preview page with 13 slides → verify smooth navigation

## Known Issues / Limitations

1. **SVG Dimensions**: If SVG has no width/height attributes, parser defaults to 1440×1000
2. **File Size**: Embedding large SVGs as data URLs increases HTML file size significantly
3. **Browser Cache**: Preview uses Blob URLs which expire after 60 seconds
4. **Tracking**: Only works when page is hosted on domain with HubSpot tracking code

## Reporting Issues

If tests fail, capture:
1. Browser and version
2. Console errors (F12 → Console)
3. Network errors (F12 → Network)
4. Debug overlay coordinates for misalignment
5. Steps to reproduce

## Next Steps

After validation:
- [ ] Test with real TAFE SA SVG slides
- [ ] Verify all 13 slides' overlay coordinates are accurate
- [ ] Create presets for other clients (e.g., `activation_tafesa`)
- [ ] Consider adding accordion support for Implementation pages
