# HubSpot Tracking Setup Guide

## Quick Start

### Step 1: Add Tracking to Your HTML Files

Add this code to each of your HTML files (v11, v12, etc.):

```html
<!-- Add this BEFORE the closing </body> tag -->
<script src="tracking.js"></script>
<script>
  // Initialize tracking with your journey name
  LearningJourneyTracker.init('tools-competency-v12');
</script>
```

**Important**: Change `'tools-competency-v12'` to match each file:
- `tools-competency-v11.html` → `'tools-competency-v11'`
- `tools-competency-v11-swinburne.html` → `'tools-competency-v11-swinburne'`
- `tools-competency-v12.html` → `'tools-competency-v12'`
- `tools-competency-v12-swinburne.html` → `'tools-competency-v12-swinburne'`
- etc.

### Step 2: Add Tracking Calls to Your Navigation Functions

In your `goTo()` function, add this tracking call:

```javascript
function goTo(newIndex) {
  const max = components.length - 1;
  const clamped = Math.max(0, Math.min(max, newIndex));
  if (clamped === state.index) return;
  
  // ADD THIS: Track navigation
  LearningJourneyTracker.trackNavigation(
    clamped,
    getComponentName(clamped),
    'button', // or 'progress_bar', 'keyboard'
    state.index
  );
  
  // ... rest of your existing code
  const prev = container.querySelector(`.component[data-idx="${state.index}"]`);
  const next = container.querySelector(`.component[data-idx="${clamped}"]`);
  if (prev) prev.classList.remove('active');
  if (next) next.classList.add('active');
  state.index = clamped;
  // ... etc
}
```

### Step 3: Track External Links (Optional)

In your `handleAction()` function, track external link clicks:

```javascript
function handleAction(o) {
  if (o.action === 'next') {
    goTo(state.index + 1);
  } else if (o.action === 'back') {
    goTo(state.index - 1);
  } else if (o.action === 'url' && o.href) {
    // ADD THIS: Track external link
    LearningJourneyTracker.trackExternalLink(o.href, state.index);
    window.open(o.href, '_blank', 'noopener');
  }
  // ... rest of your code
}
```

### Step 4: Track FAQ Interactions (Optional)

Add to your FAQ click handler:

```javascript
faqItem.addEventListener('click', () => {
  const wasActive = faqItem.classList.contains('active');
  
  // ADD THIS: Track FAQ interaction
  LearningJourneyTracker.trackFAQ(
    wasActive ? 'closed' : 'opened',
    item.q,
    state.index
  );
  
  // ... rest of your existing code
});
```

### Step 5: Upload to HubSpot

1. **Upload tracking.js** to HubSpot File Manager
2. **Update the script src** in your HTML files to point to the HubSpot URL:
   ```html
   <script src="https://YOUR-HUBSPOT-DOMAIN.com/hubfs/tools-lms-section/tracking.js"></script>
   ```

---

## Where to View Tracking Results

### Method 1: Custom Behavioral Events Dashboard

1. **Navigate to HubSpot Reports**
   - Go to: **Reports** → **Analytics Tools** → **Custom Behavioral Events**

2. **View Your Events**
   You'll see these event types:
   - `journey_started` - When someone starts the learning journey
   - `step_viewed` - Each step they view
   - `step_navigated` - Navigation between steps
   - `step_time_spent` - Time spent on each step
   - `journey_completed` - When they finish
   - `interaction` - Button/element clicks
   - `external_link_clicked` - External links clicked
   - `video_interaction` - Video plays/pauses
   - `faq_interaction` - FAQ opens/closes
   - `session_ended` - When they leave

3. **Filter by Journey**
   - Click on any event name
   - Filter by property: `journey_name = tools-competency-v12`
   - View counts, timeline, and trends

### Method 2: Contact Timeline

1. **View Individual Contact Activity**
   - Go to: **Contacts** → Select a contact
   - Scroll to **Activity** tab
   - Look for "Custom behavioral event"
   - You'll see which steps they viewed, completed, etc.

2. **Use for Follow-ups**
   - See who started but didn't finish
   - Identify which step users drop off at
   - Personalize outreach based on progress

### Method 3: Create Custom Reports

1. **Navigate to Custom Report Builder**
   - Go to: **Reports** → **Reports** → **Create custom report**
   - Choose **Custom behavioral events report**

2. **Build Your Report**
   - **Primary data source**: Custom Behavioral Events
   - **Event**: Select `step_viewed` or `journey_completed`
   - **Filters**: `journey_name` equals your journey name
   - **Visualization**: Choose chart type (funnel, bar, line, etc.)

3. **Example Reports to Create**:

   **Completion Funnel**
   - Event: `step_viewed`
   - Group by: `step_number`
   - Shows drop-off at each step

   **Average Time per Step**
   - Event: `step_time_spent`
   - Group by: `step_name`
   - Aggregation: Average of `time_spent_seconds`

   **Journey Completion Rate**
   - Events: `journey_started` vs `journey_completed`
   - Shows % who complete the full journey

   **Most Clicked External Links**
   - Event: `external_link_clicked`
   - Group by: `url`
   - Count occurrences

### Method 4: Create Workflows Based on Tracking

1. **Navigate to Workflows**
   - Go to: **Automation** → **Workflows**

2. **Create Enrollment Trigger**
   - Trigger: **Custom behavioral event**
   - Event: `journey_completed`
   - Property: `journey_name = tools-competency-v12`

3. **Example Workflow Actions**:
   - Send completion certificate email
   - Add to "Completed Training" list
   - Assign to sales rep
   - Update contact property

---

## Events You'll Track

| Event Name | When It Fires | Key Properties |
|------------|---------------|----------------|
| `journey_started` | User loads the page | journey_name, session_id |
| `step_viewed` | User views a step | step_number, step_name |
| `step_navigated` | User changes steps | from_step, to_step, navigation_method |
| `step_time_spent` | User leaves a step | step_number, time_spent_seconds |
| `journey_completed` | User reaches final step | total_time_seconds, completed_steps |
| `interaction` | User clicks button/element | action_type, step_number |
| `external_link_clicked` | User clicks external link | url, step_number |
| `video_interaction` | User plays/pauses video | video_action, video_source |
| `faq_interaction` | User opens/closes FAQ | faq_action, question |
| `session_ended` | User leaves page | session_time_seconds, final_step |

---

## Testing Your Tracking

### Local Testing

1. **Open Browser Console** (F12)
2. **Load your HTML file** in a browser
3. **Look for console logs**: `📊 Tracked: event_name`
4. **Navigate through steps** and watch events fire

### HubSpot Testing

1. **Upload files to HubSpot**
2. **Open the embedded page** in your browser
3. **Open Console** and watch for tracking events
4. **Wait 5-10 minutes** for events to appear in HubSpot
5. **Check**: Reports → Analytics Tools → Custom Behavioral Events

---

## Dashboard Setup (Recommended)

Create a dedicated dashboard to monitor all journeys:

1. **Create New Dashboard**
   - Go to: **Reports** → **Dashboards** → **Create dashboard**
   - Name: "Learning Journey Analytics"

2. **Add Reports**:
   - **Total Journey Starts** (count of `journey_started`)
   - **Completion Rate** (ratio of `journey_completed` / `journey_started`)
   - **Average Session Time** (avg of `session_time_seconds` from `session_ended`)
   - **Step-by-Step Funnel** (count of `step_viewed` by `step_number`)
   - **Most Dropped-Off Step** (where users stop)
   - **External Links Clicked** (count of `external_link_clicked` by `url`)

3. **Filter by Journey**
   - Add dashboard-wide filter: `journey_name`
   - Switch between v11, v12, Swinburne versions

---

## Troubleshooting

### "No events showing in HubSpot"
- ✅ Check browser console for `📊 Tracked:` messages
- ✅ Verify HubSpot tracking code is on the page
- ✅ Wait 5-10 minutes for events to process
- ✅ Ensure you're viewing the correct HubSpot account

### "Events tracked but not tied to contacts"
- HubSpot needs to identify the visitor first
- Events will associate when contact fills a form or is cookied
- Anonymous visitors are tracked but not in contact timeline

### "Tracking works locally but not on HubSpot"
- Check that tracking.js is uploaded to HubSpot
- Verify the script src URL is correct
- Check browser console for loading errors
- Ensure CORS isn't blocking the script

---

## Next Steps

1. ✅ Add tracking code to your HTML files
2. ✅ Upload tracking.js to HubSpot
3. ✅ Test locally
4. ✅ Upload HTML files to HubSpot
5. ✅ Wait 10 minutes and check Custom Behavioral Events
6. ✅ Create your first report/dashboard
7. ✅ Set up workflows for completed learners

Need help? Check browser console for detailed tracking logs!
