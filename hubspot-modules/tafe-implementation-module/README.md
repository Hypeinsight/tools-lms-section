# TAFE Implementation Guide - HubSpot Custom Module

Complete, self-contained HubSpot module for the TAFE Implementation Guide with **13 slides**, accordion functionality, and HubSpot tracking.

## Features

- **13 Educational Slides** with dynamic accordion expansion on Slide 3
- **7 Tool Category Accordions** with 23 tool links total
- **HubSpot Tracking Integration** (Portal ID: 20832146)
- **Video Modal Support** for instructional content
- **Navigation** with keyboard arrows and click areas
- **100% Client-Owned** - No external hosting dependencies

## Deployment

### Prerequisites

```bash
npm install -g @hubspot/cli
hs init
```

Enter Portal ID when prompted: `20832146`

### Upload Module

```bash
hs upload hubspot-modules/tafe-implementation-module tafe-implementation-module
```

### Usage in HubSpot

1. Edit any page in HubSpot
2. Drag "TAFE Implementation Guide" module onto page
3. Configure in right sidebar:
   - **Institution**: Set tracking prefix (e.g., "tafesa")
   - **Base URL**: Set tool base URL (e.g., "https://tafesa.buildingtools.co")
   - **Slides 1-13**: SVG paths are pre-configured
   - **Slide 3 Accordions**: 7 tool categories with links
   - **Videos**: Video URLs for "Show Me" buttons
   - **Links**: All URL overlays pre-configured

## Module Structure

- `fields.json` - 13 slides + 7 accordions configuration (440+ lines)
- `meta.json` - Module metadata
- `module.css` - Scoped styles with `.tafe-implementation-module` prefix
- `module.html` - Complete HubL template with JavaScript
- `README.md` - This file

## Tracking Properties

The module creates/updates these HubSpot properties:

- `{prefix}_implementation_completed` (true when slide 13 reached)
- `{prefix}_implementation_completion_date` (ISO timestamp)
- `{prefix}_implementation_last_slide_viewed` (1-13)
- `{prefix}_implementation_tools_clicked` (cumulative count)
- `{prefix}_implementation_accordions_opened` (cumulative count)
- `{prefix}_implementation_show_me_clicked` (cumulative count)

Where `{prefix}` is the institution tracking prefix (e.g., "tafesa").

## Technical Details

### Accordion Functionality

Slide 3 features dynamic height calculation with 7 accordion sections:

1. **Construction Basics** (3 tools)
2. **Science of Construction Quality** (2 tools)
3. **Design Fundamentals** (2 tools)
4. **Plumbing** (3 tools)
5. **Carpentry** (4 tools)
6. **Electrical** (3 tools)
7. **Waterproofing** (3 tools)

Each accordion:
- Collapsed height: 62px
- Expanded height: 417px (Carpentry: 717px)
- Auto-repositions bottom navigation buttons
- Tracks expansion events in HubSpot

### Differences from Activation Module

- 13 slides instead of 9
- Complex accordion system on Slide 3
- More tool links (23 vs fewer in activation)
- Dynamic height calculations
- Positioning offsets (80px left, 1281px width for accordions)

## Support

All configuration is managed through HubSpot's sidebar interface. No code changes required for:
- Changing tool URLs
- Updating video content
- Modifying SVG paths
- Adjusting button positions
