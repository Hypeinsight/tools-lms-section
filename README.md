# Building Tools™ Interactive Learning Section

An interactive, multi-step learning journey for Building Tools™ that can be embedded on HubSpot landing pages.

## 📁 Project Structure

```
tools-lms-section/
├── index.html          # Main interactive HTML file
├── svg/                # SVG components folder
│   ├── Component 7.svg  # Landing page
│   ├── Component 8.svg  # Competency 1: How to Access Tools
│   ├── Component 9.svg  # Competency 2.1: Building Code Coverage
│   ├── Component 10.svg # Competency 2.2: Code Citations
│   ├── Component 11.svg # Competency 3.1: Share Links
│   ├── Component 12.svg # Competency 3.2: QRs and PDFs
│   └── Component 13.svg # Completion page
└── README.md           # This file
```

## 🚀 Features

- **7 Interactive Components**: Navigate through the complete learning journey
- **Multiple Navigation Methods**:
  - Click "BACK" and "NEXT" buttons on each page
  - Click progress tracker dots to jump to specific sections
  - Click "START NOW" button on the landing page
  - Use keyboard arrows (←→ or ↑↓) to navigate
  - Press number keys (1-7) to jump to specific components
- **Responsive Design**: Works on desktop, tablet, and mobile devices
- **Smooth Transitions**: Clean navigation between components
- **Exact Design Fidelity**: Uses original SVG exports to maintain colors, fonts, and layouts

## 🖥️ Local Testing

1. **Using a local web server** (recommended):
   ```bash
   # Python 3
   python -m http.server 8000
   
   # Python 2
   python -m SimpleHTTPServer 8000
   
   # Node.js (if you have http-server installed)
   npx http-server
   ```
   
   Then open: `http://localhost:8000`

2. **Using VS Code Live Server**:
   - Install "Live Server" extension
   - Right-click `index.html` → "Open with Live Server"

## 📤 Embedding on HubSpot

### Method 1: Direct File Upload

1. **Upload files to HubSpot File Manager**:
   - Go to Marketing → Files and Templates → Files
   - Create a new folder (e.g., "tools-lms-section")
   - Upload `index.html`
   - Upload entire `svg` folder with all 7 SVG files

2. **Update file paths in index.html**:
   - Open the uploaded `index.html` in HubSpot editor
   - Update the `file` paths in the `components` array to use HubSpot URLs:
   ```javascript
   const components = [
       { id: 'component-7', file: 'https://your-hubspot-domain.com/hubfs/tools-lms-section/svg/Component 7.svg', name: 'Landing' },
       // ... repeat for all components
   ];
   ```

3. **Embed in landing page**:
   - Edit your HubSpot landing page
   - Add a "Custom HTML" module
   - Insert iframe code:
   ```html
   <iframe 
       src="https://your-hubspot-domain.com/hubfs/tools-lms-section/index.html" 
       width="100%" 
       height="1200px" 
       frameborder="0"
       style="border: none; overflow: hidden;">
   </iframe>
   ```

### Method 2: Inline Embed

1. **Create a Custom HTML Module** in HubSpot
2. **Copy the entire contents** of `index.html`
3. **Update SVG paths** to point to HubSpot-hosted SVG files
4. **Paste into Custom HTML module**

### Method 3: External Hosting + Embed

1. **Host on your own server or CDN**
2. **Update CORS settings** if needed
3. **Embed via iframe** on HubSpot page:
   ```html
   <iframe 
       src="https://your-domain.com/tools-lms-section/index.html" 
       width="100%" 
       height="1200px" 
       frameborder="0"
       allow="fullscreen"
       style="border: none;">
   </iframe>
   ```

## 🎨 Customization

### Adjusting Click Areas

The clickable areas are defined in the `addClickHandlers()` function. If buttons aren't responding correctly, adjust the coordinates:

```javascript
// Back button coordinates (x, y, width, height)
const backButtonArea = createClickableArea(svg, 60, 1360, 120, 40, () => navigateTo(index - 1));

// Next button coordinates
const nextButtonArea = createClickableArea(svg, 1320, 1360, 120, 40, () => navigateTo(index + 1));
```

### Changing Colors or Styles

The SVG files contain all the design. To change colors/styles:
1. Edit the SVG files in a vector editor (e.g., Figma, Adobe Illustrator, Inkscape)
2. Export as SVG again
3. Replace the files in the `svg` folder

### Modifying Navigation Behavior

All navigation logic is in the `<script>` section of `index.html`. Key functions:
- `navigateTo(index)` - Navigate to specific component
- `addClickHandlers()` - Add interactive areas
- `createClickableArea()` - Create clickable regions

## 🔧 Troubleshooting

### SVGs Not Loading
- Check that SVG files are in the correct `svg/` folder
- Verify file paths in the `components` array
- Check browser console for loading errors
- Ensure web server is running (don't open HTML directly)

### Buttons Not Clickable
- The clickable areas are transparent overlays
- Adjust coordinates in `addClickHandlers()` function
- Use browser DevTools to inspect SVG structure
- Check that SVG viewBox dimensions match expected layout

### Responsive Issues
- SVGs automatically scale to container width
- Adjust iframe height as needed: `height="1200px"` or use responsive height
- Test on multiple devices

### CORS Errors (Cross-Origin)
- If hosting SVGs separately, ensure CORS headers are set
- Or host all files on the same domain

## 📱 Browser Support

- ✅ Chrome/Edge (90+)
- ✅ Firefox (88+)
- ✅ Safari (14+)
- ✅ Mobile browsers (iOS Safari, Chrome Mobile)

## 🔑 Navigation Reference

| Action | Method |
|--------|--------|
| Next page | Click "NEXT" button, Right Arrow (→), Down Arrow (↓) |
| Previous page | Click "BACK" button, Left Arrow (←), Up Arrow (↑) |
| Jump to page | Click progress dot, Press number key (1-7) |
| Start journey | Click "START NOW" button on landing page |

## 📊 Component Flow

```
Component 7 (Landing)
    ↓
Component 8 (Competency 1: How To Access Tools™)
    ↓
Component 9 (Competency 2.1: Building Code Coverage)
    ↓
Component 10 (Competency 2.2: Code Citations)
    ↓
Component 11 (Competency 3.1: Share Links)
    ↓
Component 12 (Competency 3.2: QRs And PDFs)
    ↓
Component 13 (Completion)
```

## 💡 Tips

- **Preload**: All components load on page load for instant navigation
- **Keyboard-friendly**: Full keyboard navigation support
- **Analytics**: Add tracking by inserting analytics code in `navigateTo()` function
- **Progress tracking**: Current page stored in `currentIndex` variable
- **Accessibility**: Consider adding ARIA labels for screen readers

## 🤝 Support

For issues or questions:
1. Check browser console for errors
2. Verify all SVG files are uploaded correctly
3. Test locally first before deploying to HubSpot
4. Ensure file paths match your hosting structure

## 📝 License

Proprietary - Building Tools™ Learning Content