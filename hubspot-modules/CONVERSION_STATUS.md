# HubSpot Module Conversion Status

## ✅ Completed Files

### TAFE Activation Module
- ✅ `fields.json` - Defines all editable fields (institution, slides, FAQs, URLs)
- ✅ `meta.json` - Module metadata
- ✅ `module.css` - Complete styling (scoped to avoid conflicts)
- ✅ `README.md` - Deployment and usage instructions

### Remaining Work
- ⏳ `module.html` - Needs conversion from HTML to HubL template
- ⏳ `module.js` - JavaScript needs to use HubL variables from fields.json

## Current Approach

The modules are designed to be **fully self-contained** in HubSpot:

1. **All editable via HubSpot UI** - No code editing needed
2. **SVG files stay external** - Referenced by URL (can be HubSpot CDN or your current hosting)
3. **Institution-agnostic** - Same module works for TAFE SA, TAFE NSW, etc.
4. **HubSpot tracking built-in** - Uses configurable tracking prefix

## Key Design Decisions

### 1. Editable Fields Structure
```
Institution Settings
├── institution_name (text)
├── base_url (text)
└── tracking_prefix (text)

Slides (9 slides)
├── slide_1_file (SVG path)
├── slide_1_height (number)
├── slide_1_video (optional video URL)
└── ... (repeat for all 9 slides)

FAQ Items
├── faq_1_question
├── faq_1_answer
└── ... (can add more)

Final Slide URLs
├── signup_url
└── implementation_guide_url
```

### 2. HubL Variable Usage Example

Instead of hardcoded values like:
```javascript
file: "EDU Activation/1 - Transform Student Learning.svg"
```

The module.html will use:
```hubl
file: "{{ module.slides.slide_1_file }}"
```

And tracking like:
```javascript
updateHubSpotProperty('tafesa_activation_last_slide_viewed', slideNumber);
```

Becomes:
```hubl
updateHubSpotProperty('{{ module.tracking_prefix }}_activation_last_slide_viewed', slideNumber);
```

## Next Steps to Complete

### Option A: Simple Completion (Recommended)
Keep the JavaScript mostly as-is and only inject HubL variables for:
- Slide file paths
- Video URLs
- Tracking prefix
- FAQ content
- Final URLs

This means most of your existing JavaScript stays intact.

### Option B: Full HubL Integration
Convert more logic to HubL (server-side rendering), making the module more "HubSpot native" but more complex.

## For Implementation Module

The Implementation module will need similar files:
- `fields.json` - 13 slides + accordion config
- `meta.json`
- `module.css`
- `module.html`
- `module.js`

**Key difference:** Accordion tool links need to be editable fields, making `fields.json` more complex.

## Recommended Next Action

1. **Test with current setup** - Deploy activation module with placeholder `module.html` and `module.js`
2. **Verify it shows in HubSpot** - Confirm structure works
3. **Complete JavaScript conversion** - Add HubL variables systematically
4. **Test functionality** - Ensure slides, tracking, FAQs work
5. **Repeat for Implementation module**

## Alternative: Hybrid Approach

Keep current HTML files on Render/GitHub, create a **minimal HubSpot module** that:
- Just embeds your current HTML in an iframe
- Makes only the iframe URL editable
- Users change institution by selecting different URL

This is **much simpler** but less integrated with HubSpot.

## Questions to Answer

1. Do you want full HubSpot integration (more work, better UX)?
2. Or hybrid iframe approach (less work, good enough)?
3. Do you want to complete this yourself or need the full files generated?
4. Should we prioritize getting ONE module working first?

## File Size Warning

The complete `module.html` and `module.js` files will be:
- ~500-800 lines each for Activation
- ~800-1200 lines each for Implementation

These can be generated but are too large to review easily in one go.
