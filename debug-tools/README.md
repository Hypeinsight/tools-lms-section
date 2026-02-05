# Debug Tools

This folder contains reusable debugging tools for developing interactive SVG presentations.

## Click Area Debugger

**File:** `click-area-debugger.html`

A standalone tool for measuring and mapping clickable areas on SVG-based slides.

### Features

- **Selection Mode**: Click and drag to measure areas on your slides
- **Heatmap View**: Visualize existing clickable areas with red overlays
- **Coordinate Tracking**: Automatically normalizes coordinates to SVG viewBox dimensions
- **Multi-slide Support**: Tracks coordinates per slide
- **Export**: Copy coordinates in ready-to-use format
- **Accordion Debug**: Special support for debugging accordion link positions

### How to Use

1. Open your page that needs click area mapping
2. Copy the debug tool HTML and JavaScript into your page (see integration instructions below)
3. Toggle "Selection Mode" and click-drag to measure areas
4. Toggle "Show Click Areas" to see existing clickable areas highlighted
5. Use "Copy All Coordinates" to export all measured coordinates

### Integration Instructions

**CSS** (add to your `<style>` section):
```html
<style>
  /* Copy styles from click-area-debugger.html lines 9-97 */
</style>
```

**HTML** (add to your `<body>`):
```html
<!-- Copy the debug-tool div from click-area-debugger.html lines 101-122 -->
```

**JavaScript** (add to your `<script>` section):
```javascript
// Copy all functions from click-area-debugger.html lines 150-336
```

**Customization Points**:
- Line 198: Update selector to match your content container
- Line 248: Update selector to match your image element
- Line 260: Update to match your slide tracking mechanism
- Line 714: Update `document.getElementById('debugSlide')` calls when navigating

### Output Format

The tool exports coordinates in this format:

```javascript
// Slide 1
overlays: [
  { action: "next", x: 1216, y: 75, w: 131, h: 63 },
  { action: "back", x: 98, y: 75, w: 48, h: 56 },
]
```

### Tips

- Use arrow keys to navigate between slides if your page supports it
- The tool automatically normalizes pixel coordinates to your SVG's viewBox
- Clear slide coordinates if you need to remeasure
- The heatmap shows both your existing overlays and newly measured areas

## Future Tools

Additional debug tools can be added to this folder as needed.
