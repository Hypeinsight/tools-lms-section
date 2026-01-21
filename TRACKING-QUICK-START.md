# Quick Start: Add Tracking to Your HTML Files

## ✅ Already Done
`tools-competency-v12.html` is already set up with tracking!

## 📋 For Each Additional HTML File

### 1. Add Scripts Before `</body>`
```html
<!-- HubSpot Learning Journey Tracking -->
<script src="tracking.js"></script>
<script>
  // Change the name to match your file
  LearningJourneyTracker.init('tools-competency-v11');
</script>
</body>
</html>
```

### 2. Update Journey Names
| File | Journey Name |
|------|--------------|
| `tools-competency-v11.html` | `'tools-competency-v11'` |
| `tools-competency-v11-swinburne.html` | `'tools-competency-v11-swinburne'` |
| `tools-competency-v12.html` | ✅ Already done |
| `tools-competency-v12-swinburne.html` | `'tools-competency-v12-swinburne'` |
| `tools-competency-builders-v1.html` | `'tools-competency-builders-v1'` |
| `tools-competency-builders-v2.html` | `'tools-competency-builders-v2'` |

### 3. Add These Code Changes

#### A. Update `goTo()` function
**Find:**
```javascript
function goTo(newIndex) {
  const max = components.length - 1;
  const clamped = Math.max(0, Math.min(max, newIndex));
  if (clamped === state.index) return;
```

**Replace with:**
```javascript
function goTo(newIndex, method = 'button') {
  const max = components.length - 1;
  const clamped = Math.max(0, Math.min(max, newIndex));
  if (clamped === state.index) return;
  
  const prevIndex = state.index;
```

**Then add tracking AFTER `state.index = clamped;`:**
```javascript
state.index = clamped;

// Track navigation with HubSpot
if (typeof LearningJourneyTracker !== 'undefined') {
  LearningJourneyTracker.trackNavigation(
    clamped,
    getComponentName(clamped),
    method,
    prevIndex
  );
}
```

**Add helper function after `goTo()`:**
```javascript
function getComponentName(index) {
  if (components[index]) {
    return components[index].name || `Component ${components[index].id}`;
  }
  return `Step ${index + 1}`;
}
```

#### B. Update `handleAction()` function
**Find:**
```javascript
} else if (o.action === 'url' && o.href) {
  window.open(o.href, '_blank', 'noopener');
}
```

**Replace with:**
```javascript
} else if (o.action === 'url' && o.href) {
  // Track external link
  if (typeof LearningJourneyTracker !== 'undefined') {
    LearningJourneyTracker.trackExternalLink(o.href, state.index);
  }
  window.open(o.href, '_blank', 'noopener');
}
```

**Also update navigation calls:**
```javascript
if (o.action === 'next') {
  goTo(state.index + 1, 'button');  // Add 'button' parameter
} else if (o.action === 'back') {
  goTo(state.index - 1, 'button');  // Add 'button' parameter
}
```

#### C. Update Progress Bar Clicks
**Find:**
```javascript
el.addEventListener('click', (e) => {
  e.preventDefault();
  e.stopPropagation();
  goTo(segment.to);
});
```

**Replace with:**
```javascript
el.addEventListener('click', (e) => {
  e.preventDefault();
  e.stopPropagation();
  goTo(segment.to, 'progress_bar');  // Add navigation method
});
```

#### D. Update Keyboard Navigation (if present)
**Find:**
```javascript
if (e.key === 'ArrowRight' || e.key === 'ArrowDown') {
  e.preventDefault();
  goTo(state.index + 1);
}
```

**Replace with:**
```javascript
if (e.key === 'ArrowRight' || e.key === 'ArrowDown') {
  e.preventDefault();
  goTo(state.index + 1, 'keyboard');
}
```

#### E. Update FAQ Clicks (if present)
**Find:**
```javascript
faqItem.addEventListener('click', () => {
  const wasActive = faqItem.classList.contains('active');
  // Close all FAQ items
```

**Add tracking after `const wasActive`:**
```javascript
faqItem.addEventListener('click', () => {
  const wasActive = faqItem.classList.contains('active');
  
  // Track FAQ interaction
  if (typeof LearningJourneyTracker !== 'undefined') {
    LearningJourneyTracker.trackFAQ(
      wasActive ? 'closed' : 'opened',
      item.q,
      idx  // or state.index, depending on context
    );
  }
  
  // Close all FAQ items
```

## 🧪 Test Locally

1. Open HTML file in browser
2. Press F12 to open Console
3. Navigate between steps
4. Look for: `📊 Tracked: step_viewed {journey_name: "...", ...}`

## ☁️ Upload to HubSpot

1. Upload `tracking.js` to HubSpot File Manager
2. Update script src in HTML files:
   ```html
   <script src="https://YOUR-DOMAIN.hubspot.com/hubfs/tools-lms-section/tracking.js"></script>
   ```
3. Upload updated HTML files
4. Test on HubSpot page
5. Wait 10 minutes
6. Check: Reports → Analytics Tools → Custom Behavioral Events

## 📊 View Results

**Path:** Reports → Analytics Tools → Custom Behavioral Events

**Events to look for:**
- `journey_started`
- `step_viewed`
- `step_navigated`
- `journey_completed`
- `external_link_clicked`
- `faq_interaction`

## 🆘 Need Help?
See full guide: `TRACKING-SETUP-GUIDE.md`
