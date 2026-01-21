# Learning Journey Tracking - Developer Guide

## Overview
This guide explains how to implement Google Analytics 4 (GA4) tracking for all learning journey pages in HubSpot.

## What Gets Tracked
Each learning journey automatically tracks:
- ✅ Journey starts
- ✅ Step views (which step users are on)
- ✅ Step navigation (movement between steps)
- ✅ Time spent on each step
- ✅ External link clicks
- ✅ Journey completion
- ✅ Session data

---

## Setup Instructions

### Step 1: Get GA4 Measurement ID
1. Log into Google Analytics 4
2. Go to **Admin** → **Data Streams**
3. Select the "Building Tools" web stream
4. Copy the **Measurement ID** (format: `G-XXXXXXXXXX`)

### Step 2: Add GA4 Code to Each Journey Page

For **every HubSpot page** that contains a learning journey:

1. Edit the page in HubSpot
2. Go to **Settings** → **Advanced Options** → **Head HTML**
3. Add this code (replace `G-XXXXXXXXXX` with actual Measurement ID):

```html
<!-- Google Analytics 4 Tracking -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXXX');
</script>
```

4. Save and publish the page

### Step 3: Embed Journey HTML

Upload the journey HTML files from the `base64-embeds` folder:

**Available Journey Files:**
- `tools-competency-v12-swinburne-base64.html` - For Swinburne University version
- `tools-competency-v12-base64.html` - Standard version 12
- `tools-competency-builders-v1-base64.html` - For builders audience

**To embed:**
1. Upload the HTML file to HubSpot File Manager
2. In the page editor, add a **Custom HTML module**
3. Paste the entire HTML file contents into the module
4. Save and publish

---

## Verification Checklist

After deploying a new journey page, verify tracking works:

### Immediate Verification (Real-time)
1. Open the journey page in a browser
2. Open browser Developer Console (F12)
3. Navigate through 2-3 steps
4. Check console for messages like:
   ```
   📊 Tracked: journey_started {journey_name: '...', ...}
   📊 Tracked: step_viewed {step_number: 1, ...}
   📊 Tracked: step_navigated {...}
   ```

5. In Google Analytics 4:
   - Go to **Reports** → **Realtime**
   - You should see events appearing within seconds
   - Look for: `journey_started`, `step_viewed`, `step_navigated`

### Full Verification (24 hours later)
1. In GA4, go to **Reports** → **Engagement** → **Events**
2. Verify these events appear:
   - `journey_started`
   - `step_viewed`
   - `step_navigated`
   - `step_time_spent`
   - `external_link_clicked`
   - `journey_completed`

---

## Event Details

### journey_started
Fires when user begins the journey
```javascript
{
  journey_name: 'tools-competency-builders-v1',
  session_id: 'session_1767884166202_9sxr4b0ej',
  timestamp: 1767884171418
}
```

### step_viewed
Fires when user views a step
```javascript
{
  journey_name: 'tools-competency-builders-v1',
  step_number: 1,
  step_name: 'Component 28',
  session_id: 'session_1767884166202_9sxr4b0ej',
  timestamp: 1767884171418
}
```

### step_navigated
Fires when user moves between steps
```javascript
{
  journey_name: 'tools-competency-builders-v1',
  to_step_number: 2,
  to_step_name: 'Component 29',
  from_step_number: 1,
  from_step_name: 'Component 28',
  navigation_method: 'button', // or 'keyboard', 'progress_bar'
  session_id: 'session_1767884166202_9sxr4b0ej'
}
```

### step_time_spent
Fires when user leaves a step
```javascript
{
  journey_name: 'tools-competency-builders-v1',
  step_number: 1,
  step_name: 'Component 28',
  time_spent_seconds: 15,
  session_id: 'session_1767884166202_9sxr4b0ej'
}
```

### external_link_clicked
Fires when user clicks external links
```javascript
{
  journey_name: 'tools-competency-builders-v1',
  step_number: 1,
  url: 'https://example.com',
  session_id: 'session_1767884166202_9sxr4b0ej'
}
```

### journey_completed
Fires when user reaches the final step
```javascript
{
  journey_name: 'tools-competency-builders-v1',
  total_time_seconds: 450,
  total_steps: 9,
  completed_steps: 9,
  session_id: 'session_1767884166202_9sxr4b0ej',
  timestamp: 1767884621418
}
```

---

## Creating Reports in GA4

### View Journey Completion Funnel
1. Go to **Explore** → **Funnel exploration**
2. Add steps:
   - Step 1: `journey_started`
   - Step 2: `step_viewed` (where `step_number` = 1)
   - Step 3: `step_viewed` (where `step_number` = 2)
   - Continue for all steps...
   - Final: `journey_completed`
3. View drop-off rates between each step

### View User Paths
1. Go to **Explore** → **Path exploration**
2. Set starting point: `journey_started`
3. See the paths users take through the journey

### View Time Metrics
1. Go to **Reports** → **Engagement** → **Events**
2. Select `step_time_spent` event
3. View average time per step

---

## Troubleshooting

### Events not appearing in console
**Problem:** No `📊 Tracked:` messages in browser console

**Solution:**
- Check that the HTML file includes the tracking.js script
- Verify `LearningJourneyTracker.init()` is called
- Check for JavaScript errors in console

### Events in console but not in GA4
**Problem:** See `📊 Tracked:` messages but no data in GA4

**Solutions:**
1. Verify GA4 code is added to the page
2. Check browser console for:
   ```javascript
   typeof window.gtag
   ```
   Should return `"function"`, not `"undefined"`
3. Check Network tab for requests to `google-analytics.com`
4. Wait 24 hours - GA4 can take time to process events

### "HubSpot tracking not detected" warning
**Problem:** Warning message in console

**Solution:** This is harmless and can be ignored. The tracking still works. This just means HubSpot's tracking took longer than 5 seconds to load.

---

## Technical Architecture

### File Structure
```
tracking.js           # Core tracking library (already integrated)
base64-embeds/       # Self-contained HTML files ready for deployment
├── tools-competency-v12-swinburne-base64.html
├── tools-competency-v12-base64.html
└── tools-competency-builders-v1-base64.html
```

### How It Works
1. Each HTML file includes `tracking.js`
2. On page load, `LearningJourneyTracker.init(journeyName)` is called
3. User interactions trigger tracking functions
4. Events are sent to GA4 via `window.gtag()`
5. Events are also sent to HubSpot via `window._hsq` (if available)
6. Progress is saved to localStorage for user persistence

### Browser Support
- Modern browsers (Chrome, Firefox, Safari, Edge)
- Requires JavaScript enabled
- Requires localStorage for progress persistence

---

## Best Practices

### ✅ DO:
- Use unique journey names for each journey
- Test tracking on staging before production
- Verify events in GA4 Realtime after deployment
- Keep the same GA4 Measurement ID across all pages
- Monitor tracking in GA4 regularly

### ❌ DON'T:
- Modify the tracking.js file without testing
- Use special characters in journey names
- Deploy without testing in console first
- Mix different GA4 Measurement IDs across journeys
- Remove console.log statements (they help with debugging)

---

## Support & Questions

### Common Questions

**Q: Can I track multiple journeys on the same page?**
A: No, each page should have one journey. Use different pages for different journeys.

**Q: How do I track different versions of the same journey?**
A: Use different journey names, e.g., `tools-competency-v12` vs `tools-competency-v13`

**Q: Can I customize which events are tracked?**
A: Yes, but consult with the tracking implementation team first to maintain consistency.

**Q: Does this work with GTM (Google Tag Manager)?**
A: Yes, but you'll need to load GTM instead of the direct GA4 script. Contact the team for GTM implementation instructions.

---

## Changelog

### Version 1.0 (January 2026)
- Initial implementation
- GA4 integration
- HubSpot integration
- Support for v12 and builders journeys
- Base64 embedded HTML files with all assets included

---

## File Locations

All files are located in: `C:\Users\Isuru\Special Projects\tools-lms-section`

**Production-ready files:** `base64-embeds/` folder
**Documentation:** Root directory
**Tracking library:** `tracking.js`

---

**Last Updated:** January 8, 2026
**Contact:** Project owner for questions or support
