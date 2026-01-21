# Interactive Annotations System Documentation

## Overview
This system allows you to overlay interactive annotations (tooltips, callouts, highlights) on top of the embedded Tools app iframe.

## Files
- **`tools-annotations-demo.html`** - Basic demo with always-visible annotations
- **`tools-annotations-smart.html`** - Smart mode with locked/free toggle (RECOMMENDED)

## How It Works

### Core Concept
Since the Tools app is embedded as an iframe, we cannot directly modify its content. Instead, we position an overlay layer on top of the iframe with annotation elements positioned using percentages.

### The Zoom/Pan Problem
**Challenge**: When users zoom or pan inside the iframe, the overlay annotations don't move with the content because:
1. The iframe is a separate document (cross-origin security)
2. We cannot detect internal iframe state changes without postMessage support
3. Annotations are positioned relative to the iframe container, not the content inside

**Solution**: Two-mode system (implemented in `tools-annotations-smart.html`)

## Usage Guide

### Mode Behavior

#### 🔒 Locked Mode (Default)
- Annotations are **hidden**
- Iframe interaction is **blocked** (can't zoom/pan)
- View is **restored to default** when switching to locked
- Best for: Presenting the tool in a fixed state without distractions

#### 🔓 Free Mode (Toggle)
- Annotations are **visible**
- Iframe interaction is **enabled** (can zoom/pan)
- Annotations remain in fixed positions (may not align after zoom/pan)
- Best for: Guided exploration with visual hints

### Controls
- **Toggle Switch**: Click to switch between Locked/Free modes
- **Reset View**: Returns to Locked Mode and restores default iframe view

## Customizing Annotations

### Adding Info Icons with Tooltips

```html
<!-- Info icon -->
<div class="info-icon" style="top: 15%; left: 20%;" data-tooltip="my-tooltip">
  <span>i</span>
</div>

<!-- Tooltip content -->
<div class="tooltip" id="my-tooltip" style="top: 18%; left: 20%;">
  Your tooltip text with <strong>formatting</strong>
</div>
```

**Position Tips:**
- Use percentages for responsive positioning
- `top`/`left` are relative to iframe container
- Position tooltip slightly below/beside the icon

### Adding Callout Boxes

```html
<div class="callout arrow-left" style="top: 10%; right: 5%;">
  <div class="callout-title">Feature Name</div>
  <div class="callout-text">Description of the feature</div>
</div>
```

**Arrow Directions:**
- `arrow-left` - Arrow points left
- `arrow-right` - Arrow points right
- `arrow-top` - Arrow points up
- `arrow-bottom` - Arrow points down

### Adding Highlight Areas

```html
<div class="highlight-area" style="top: 30%; left: 15%; width: 25%; height: 35%;"></div>
```

**Styling:**
- Dashed blue border
- Semi-transparent background
- Non-interactive (pointer-events: none)

## Technical Details

### Iframe URL Parameters
The Tools app embed uses these key parameters:

```
zoom=2.2898           # Zoom level
x=570.11              # X position
y=238.71              # Y position
chromeless=true       # Hide UI chrome
```

### Interaction Detection
The smart mode uses an "interaction detector" - a transparent layer that:
- Sits above the iframe but below annotations
- Captures mouse/wheel events in Locked Mode
- Prevents zoom/pan by blocking events
- Becomes transparent in Free Mode

### PostMessage Support (Future Enhancement)
For perfect zoom/pan synchronization, the Tools app would need to send messages:

```javascript
// In Tools app (if implemented)
window.parent.postMessage({
  action: 'toolsStateChange',
  zoom: 2.5,
  x: 600,
  y: 250
}, '*');

// In parent page
window.addEventListener('message', (event) => {
  if (event.data.action === 'toolsStateChange') {
    updateAnnotationPositions(event.data.zoom, event.data.x, event.data.y);
  }
});
```

## Best Practices

### For Learning Content
1. **Start in Locked Mode** - Users see the tool without annotations
2. **Provide instructions** to toggle to Free Mode for guided exploration
3. **Use 4-6 annotations maximum** - Too many is overwhelming
4. **Position carefully** - Test at different screen sizes

### For Interactive Guides
1. **Start in Free Mode** - Show annotations immediately
2. **Use info icons** for detailed explanations (click to reveal)
3. **Use callouts** for always-visible key points
4. **Use highlights** to draw attention to specific areas

### Positioning Strategy
1. Open the page and take a screenshot of the iframe
2. Use an image editor to plan annotation positions
3. Convert pixel positions to percentages:
   - `left% = (pixelX / iframeWidth) * 100`
   - `top% = (pixelY / iframeHeight) * 100`

## Limitations

### Current Limitations
1. **No dynamic sync** - Annotations don't track with zoom/pan (without postMessage)
2. **Fixed viewport** - Works best at specific iframe size
3. **Cross-origin** - Cannot access iframe internals due to browser security

### Workarounds
1. **Locked Mode** - Prevent zoom/pan to keep alignment
2. **Hide on interaction** - Hide annotations when users zoom/pan
3. **Fixed view** - Lock iframe to specific zoom/pan state via URL

## Integration with Learning Journey

To integrate into `tools-competency-v12.html`:

1. **Copy annotation styles** from `tools-annotations-smart.html`
2. **Add mode toggle** to slide controls
3. **Add annotations layer** to slide 2 (Component 10)
4. **Configure positions** for the specific tool view

Example integration:
```javascript
// In tools-competency-v12.html, for Component 10 (slide 2)
{
  id: 10,
  file: "Finalised SVGs/Component 10.svg",
  iframes: [{
    src: "...", // Tools app URL
    annotations: true, // Enable annotations
    annotationsConfig: {
      icons: [...],
      callouts: [...],
      highlights: [...]
    }
  }]
}
```

## Troubleshooting

### Annotations not visible
- Check if `annotations-layer` has `hidden` class
- Verify you're in Free Mode (toggle switch is ON)

### Annotations misaligned
- User may have zoomed/panned in Free Mode
- Click "Reset View" to restore alignment
- Consider using Locked Mode only

### Tooltips not appearing
- Ensure tooltip ID matches info icon's `data-tooltip` attribute
- Check JavaScript console for errors
- Verify click event listeners are attached

## Future Enhancements

### Phase 1 (Current)
- ✅ Two-mode system (locked/free)
- ✅ Interactive tooltips
- ✅ Callout boxes
- ✅ Highlight areas

### Phase 2 (Proposed)
- ⏳ PostMessage support from Tools app
- ⏳ Dynamic annotation positioning based on zoom/pan
- ⏳ Progressive disclosure (annotations appear in sequence)
- ⏳ Animation effects (arrows, pulses)

### Phase 3 (Future)
- ⏳ Annotation authoring tool (visual editor)
- ⏳ Save/load annotation configurations
- ⏳ Multiple annotation sets per tool
- ⏳ Analytics tracking (which annotations clicked)

## Contact & Support

For questions or feature requests related to the Tools app embed:
- Contact Building Tools development team for postMessage support
- Request specific zoom/pan/disable URL parameters if needed

For annotation system issues:
- Check browser console for errors
- Test in different browsers (Chrome, Firefox, Safari)
- Verify iframe URL is accessible and not blocked by CORS
