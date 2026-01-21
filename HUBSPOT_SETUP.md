# HubSpot Contact Properties Setup Guide

## Overview
This guide explains how to set up HubSpot contact properties to track learning journey progression without requiring custom events.

## How It Works
The updated tracking system uses two methods:
1. **Contact Properties** - Stores user progression data on their contact record
2. **Virtual Page Views** - Tracks each step as a page view for analytics

## Step 1: Create Contact Properties in HubSpot

You need to create custom contact properties in HubSpot to store the tracking data. The properties will be automatically prefixed based on your journey name.

For example, if your journey name is `tools-competency-v12`, the properties will be:
- `lj_tools_competency_v12_status`
- `lj_tools_competency_v12_current_step`
- etc.

### Required Properties

Navigate to **Settings > Properties > Contact Properties** in HubSpot and create the following:

#### 1. Status Property
- **Internal Name**: `lj_tools_competency_v12_status`
- **Label**: Learning Journey Status (Tools Competency v12)
- **Field Type**: Dropdown select
- **Options**:
  - `started`
  - `in_progress`
  - `completed`

#### 2. Current Step Property
- **Internal Name**: `lj_tools_competency_v12_current_step`
- **Label**: Current Step Number (Tools Competency v12)
- **Field Type**: Number

#### 3. Current Step Name Property
- **Internal Name**: `lj_tools_competency_v12_current_step_name`
- **Label**: Current Step Name (Tools Competency v12)
- **Field Type**: Single-line text

#### 4. Completed Steps Property
- **Internal Name**: `lj_tools_competency_v12_completed_steps`
- **Label**: Completed Steps Count (Tools Competency v12)
- **Field Type**: Number

#### 5. Start Date Property
- **Internal Name**: `lj_tools_competency_v12_start_date`
- **Label**: Journey Start Date (Tools Competency v12)
- **Field Type**: Date picker

#### 6. Completion Date Property
- **Internal Name**: `lj_tools_competency_v12_completion_date`
- **Label**: Journey Completion Date (Tools Competency v12)
- **Field Type**: Date picker

#### 7. Total Time Property
- **Internal Name**: `lj_tools_competency_v12_total_time_seconds`
- **Label**: Total Time Spent (seconds) (Tools Competency v12)
- **Field Type**: Number

#### 8. Total Steps Property
- **Internal Name**: `lj_tools_competency_v12_total_steps`
- **Label**: Total Steps in Journey (Tools Competency v12)
- **Field Type**: Number

#### 9. Last Activity Property
- **Internal Name**: `lj_tools_competency_v12_last_activity`
- **Label**: Last Activity Date (Tools Competency v12)
- **Field Type**: Date picker

#### 10. Session ID Property
- **Internal Name**: `lj_tools_competency_v12_session_id`
- **Label**: Session ID (Tools Competency v12)
- **Field Type**: Single-line text

#### 11. Session Time Property
- **Internal Name**: `lj_tools_competency_v12_session_time_seconds`
- **Label**: Session Time (seconds) (Tools Competency v12)
- **Field Type**: Number

#### 12. Final Step Property
- **Internal Name**: `lj_tools_competency_v12_final_step`
- **Label**: Final Step Reached (Tools Competency v12)
- **Field Type**: Number

## Step 2: Adjust Property Names for Different Journeys

If you're using a different journey name (not `tools-competency-v12`), replace the prefix accordingly:
- Journey name gets sanitized: lowercase, special characters replaced with underscores
- Examples:
  - `tools-competency-builders-v2` → `lj_tools_competency_builders_v2_*`
  - `Tools Competency V12` → `lj_tools_competency_v12_*`

## Step 3: Verify Contact Identification

For the tracking to work, HubSpot needs to identify the user. This happens automatically if:
1. The user is on a HubSpot-hosted page
2. The HubSpot tracking code is installed on your page
3. The user has a HubSpot cookie (`hubspotutk`)

You can check if a user is identified by looking in the browser console for the tracking logs.

## Step 4: Test the Tracking

1. Open your learning journey page
2. Open browser DevTools (F12) and go to the Console tab
3. You should see logs like:
   ```
   📊 Tracked: journey_started /learning-journey/tools-competency-v12/journey_started {lj_tools_competency_v12_status: "started", ...}
   ```
4. Navigate through the journey and check that properties are being updated

## Step 5: Create Reports and Workflows

Once the properties are set up, you can:

### Create Lists
- Active learners: `lj_*_status` = `in_progress`
- Completed learners: `lj_*_status` = `completed`
- Stuck learners: `lj_*_last_activity` is more than X days ago AND status is `in_progress`

### Create Workflows
- Send completion email when `lj_*_status` = `completed`
- Send reminder email when `lj_*_last_activity` is more than 3 days ago
- Enroll in follow-up sequence after completion

### Create Reports
- Track completion rates over time
- Average time to completion
- Drop-off points (final step reached)
- Funnel analysis using virtual page views

## Analytics Dashboard

The virtual page views will appear in HubSpot analytics under paths like:
- `/learning-journey/tools-competency-v12/journey_started`
- `/learning-journey/tools-competency-v12/step_viewed/step-1`
- `/learning-journey/tools-competency-v12/step_navigated/step-2`
- `/learning-journey/tools-competency-v12/journey_completed`

You can create custom reports based on these page views.

## Troubleshooting

### Properties Not Updating
1. Check that the property names match exactly (including the prefix)
2. Verify HubSpot tracking code is loaded (check for `window._hsq`)
3. Check browser console for tracking logs
4. Ensure the user has a HubSpot cookie

### User Not Identified
1. Make sure HubSpot tracking code is installed
2. Check if user has accepted cookies
3. User may need to submit a form first to be identified

### Data Not Appearing in HubSpot
1. Wait 5-10 minutes for data to sync
2. Check the contact record directly
3. Verify property names in HubSpot match the tracking code

## Migration from Custom Events

If you were previously using custom events, the data is not compatible. You'll start fresh with contact properties. The benefits:
- ✅ Works on all HubSpot subscription tiers
- ✅ Data persists on contact records
- ✅ Can trigger workflows and lists
- ✅ Better for reporting and segmentation
- ✅ More reliable and standardized

## Questions?

If you need to track multiple different learning journeys, repeat the process for each journey name. Each journey will have its own set of properties with a unique prefix.
