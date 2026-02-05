# TAFE Page Generator

A standalone HTML generator for Activation and Implementation guides. No build tools, no dependencies—just open `index.html` in your browser and generate self-contained HTML pages with clickable overlays, videos, and debug tools.

## Quick Start

1. **Open** `index.html` in your browser
2. **Select a preset** (e.g., "Implementation (TAFE SA) - 13 slides") to load pre-configured overlays
3. **Upload your SVGs** (in order by slide number) OR use the preset's placeholder graphics
4. **Set tenant subdomain** (e.g., "tafesa" → all tool links will use `https://tafesa.buildingtools.co`)
5. **Click Generate** or **Preview**
6. **Upload** the generated HTML to HubSpot File Manager or any static host

## Complete Workflow

### 1. Select Preset
- Choose **Implementation (TAFE SA)** to load all 13 slides with pre-configured overlays
- Or choose **None** to build from scratch

### 2. Upload SVGs
- Click **Upload SVGs (ordered by slide)**
- Select your SVG files in slide order (Slide 1, Slide 2, ...)
- The generator will automatically:
  - Parse SVG dimensions
  - Apply preset overlays to matching slides
  - Inject clickable areas for navigation, videos, and external links

### 3. Customize Tenant
- Enter your **Tenant Subdomain** (e.g., "tafesa", "tafensw", "university")
- All external tool links will automatically update:
  - `https://tafesa.buildingtools.co/tools/...` → `https://YOUR_TENANT.buildingtools.co/tools/...`

### 4. Debug Overlays
- Check **Include debug tool** (enabled by default)
- In the generated page, click the **Debug Overlays** toggle button
- Hover over any clickable area to see its coordinates:
  - `x, y, w, h` values
  - Click to copy coordinates to clipboard
- Use these coordinates to report overlay issues for correction

### 5. Generate & Deploy
- **Preview** opens in new tab for testing
- **Generate HTML** downloads a single `.html` file
- Upload to HubSpot File Manager, S3, or any web host
- No server-side dependencies required

## Reporting Overlay Issues

If clickable areas are misaligned:

1. **Enable Debug Tool** when generating
2. Open the page and toggle **Debug Overlays**
3. Hover over the incorrect overlay to see coordinates
4. Click the overlay to copy coordinates
5. Report to developer:
   - Slide number
   - Action type (next, back, video, url)
   - Current coordinates: `x, y, w, h`
   - Expected behavior

Developer will update `presets.js` with corrected values.

## Advanced: JSON Overrides

For full manual control, use the **Advanced overrides** field:

```json
{
  "slides": [
    {
      "id": 1,
      "file": "data:image/svg+xml;...",
      "viewBoxWidth": 1440,
      "viewBoxHeight": 1000,
      "overlays": [
        { "action": "next", "x": 1293, "y": 40, "w": 50, "h": 50 },
        { "action": "video", "src": "https://path/to/video.mp4", "x": 100, "y": 200, "w": 200, "h": 60 },
        { "action": "url", "url": "https://example.com", "x": 300, "y": 400, "w": 150, "h": 50 }
      ]
    }
  ]
}
```

## File Structure

```
generator/
├── index.html          # Main generator interface
├── app.js              # Form handling, SVG upload, tenant replacement
├── presets.js          # Preset slide configs with overlay coordinates
├── templates.js        # HTML template builder
├── styles.css          # Generator UI styles
└── README.md           # This file
```

## Hosting Options

### HubSpot File Manager
1. Generate the HTML file
2. Go to Marketing → Files and Templates → Files
3. Upload the `.html` file
4. Use the file URL as your landing page or embed link

### Static Host (S3, Netlify, etc.)
1. Generate the HTML file
2. Upload to your preferred static host
3. Serve as-is (no build step needed)

### Direct Distribution
- Email the HTML file
- Users can open locally in browser
- Tracking will work if HubSpot tracking code is present on the domain

## Troubleshooting

**SVGs not displaying?**
- Ensure files are valid SVG format
- Check browser console for errors
- Try Preview before downloading

**Overlays not clickable?**
- Enable Debug Tool to inspect coordinates
- Verify SVG dimensions match preset expectations
- Check browser zoom is at 100%

**Links not working?**
- Verify tenant subdomain is correct
- Check that preset was loaded properly
- Use Debug Tool to inspect overlay action types

**Tracking not working?**
- Ensure HubSpot Portal ID is entered
- Verify page is hosted on domain with HubSpot tracking code
- Check browser's tracking consent settings

## Support

For issues or questions:
- Check Debug Tool output
- Review presets.js for your slide configuration
- Contact the developer with debug coordinates
