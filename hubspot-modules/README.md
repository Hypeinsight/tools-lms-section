# TAFE HubSpot Modules - Deployment Guide

This folder contains two HubSpot Custom Modules:
1. **tafe-activation-module** - For activation/onboarding slides
2. **tafe-implementation-module** - For implementation guide slides

## Prerequisites

1. **HubSpot Account** with CMS Hub (Professional or Enterprise)
2. **Node.js** installed (v14 or higher)
3. **HubSpot CLI** installed globally

## Installation Steps

### 1. Install HubSpot CLI

```bash
npm install -g @hubspot/cli
```

### 2. Authenticate with HubSpot

```bash
hs init
```

Follow the prompts:
- Enter your HubSpot account ID (Portal ID: 20832146)
- Choose authentication method (Personal Access Key recommended)
- Name your account (e.g., "tafe-production")

### 3. Upload Modules to HubSpot

#### Upload Activation Module:
```bash
hs upload hubspot-modules/tafe-activation-module tafe-activation-module
```

#### Upload Implementation Module:
```bash
hs upload hubspot-modules/tafe-implementation-module tafe-implementation-module
```

### 4. Upload SVG Assets

You need to upload all SVG files to HubSpot File Manager:

1. Go to HubSpot → Marketing → Files and Templates → Files
2. Create folder structure:
   - `EDU Activation/`
   - `EDU Practical Guide (Implementation)/`
   - `Hickory Activation/`
3. Upload all SVG files maintaining folder structure
4. Note: The modules reference these file paths

**Alternative:** Update `fields.json` defaults with HubSpot CDN URLs after upload

## Using the Modules

### In HubSpot Page Editor:

1. Go to Marketing → Website → Website Pages
2. Create or edit a page
3. Click "+ Add" to add module
4. Find "TAFE Activation Guide" or "TAFE Implementation Guide"
5. Drag onto page
6. Edit settings in right sidebar:
   - Institution Name
   - Base URL
   - Tracking Prefix
   - Slide file paths
   - Video URLs
   - FAQ content

### Module Settings:

**Activation Module:**
- 9 slides configurable
- FAQ items (extendable)
- Video URLs per slide
- HubSpot tracking integration

**Implementation Module:**
- 13 slides configurable
- Accordion tool links
- Complex slide interactions
- HubSpot tracking integration

## Creating New Institution Versions

To create a version for a new institution (e.g., TAFE NSW):

1. Add module to page
2. Configure:
   - Institution Name: "TAFE NSW"
   - Base URL: "tafensw.buildingtools.co"
   - Tracking Prefix: "tafensw"
3. Update slide SVG paths if different
4. Update signup/tool URLs

## Updating Modules

After making changes to module files:

```bash
hs upload hubspot-modules/tafe-activation-module tafe-activation-module --mode=publish
```

Or use watch mode during development:

```bash
hs watch hubspot-modules/tafe-activation-module tafe-activation-module
```

## Troubleshooting

### Module doesn't appear in editor
- Check module is uploaded: `hs list`
- Ensure `meta.json` has correct `host_template_types`

### SVG images not loading
- Verify files are uploaded to HubSpot File Manager
- Check file paths in module settings match uploaded paths
- Use absolute HubSpot CDN URLs if needed

### Tracking not working
- Verify HubSpot tracking code is on page
- Check custom properties exist in HubSpot
- Verify tracking prefix matches property names

## File Structure

```
hubspot-modules/
├── tafe-activation-module/
│   ├── fields.json          # Editable fields configuration
│   ├── meta.json            # Module metadata
│   ├── module.css           # Styles
│   ├── module.html          # HubL template
│   └── module.js            # JavaScript functionality
├── tafe-implementation-module/
│   ├── fields.json
│   ├── meta.json
│   ├── module.css
│   ├── module.html
│   └── module.js
└── README.md                # This file
```

## Support

For HubSpot CLI documentation:
https://developers.hubspot.com/docs/cms/guides/getting-started-with-local-development

For module development:
https://developers.hubspot.com/docs/cms/building-blocks/modules
