/**
 * HubSpot Learning Journey Tracker
 * 
 * Usage: Include this script in your HTML and call initTracking() with your journey name
 * Example: initTracking('tools-competency-v12');
 */

(function(window) {
  'use strict';

  // Configuration
  const config = {
    journeyName: '',
    startTime: Date.now(),
    stepStartTime: Date.now(),
    sessionId: generateSessionId(),
    completedSteps: new Set(),
    hubspotReady: false
  };

  /**
   * Initialize tracking for a specific journey
   * @param {string} journeyName - Name identifier for this learning journey
   */
  function initTracking(journeyName) {
    config.journeyName = journeyName;
    
    // Wait for HubSpot tracking to be ready
    waitForHubSpot(() => {
      config.hubspotReady = true;
      trackEvent('journey_started', {
        journey_name: config.journeyName,
        session_id: config.sessionId,
        timestamp: Date.now()
      });
      
      // Track initial page load
      trackStepView(0, getComponentName(0));
    });
    
    // Load saved progress
    loadProgress();
    
    // Track page unload
    window.addEventListener('beforeunload', handleUnload);
  }

  /**
   * Track navigation to a new step
   * @param {number} stepIndex - Index of the step being viewed
   * @param {string} stepName - Name of the step
   * @param {string} method - How the user navigated (button, progress_bar, keyboard, etc.)
   * @param {number} fromStep - Previous step index
   */
  function trackNavigation(stepIndex, stepName, method, fromStep) {
    // Track time spent on previous step
    const timeSpent = Date.now() - config.stepStartTime;
    trackEvent('step_time_spent', {
      journey_name: config.journeyName,
      step_number: fromStep + 1,
      step_name: getComponentName(fromStep),
      time_spent_seconds: Math.round(timeSpent / 1000),
      session_id: config.sessionId
    });
    
    // Track navigation event
    trackEvent('step_navigated', {
      journey_name: config.journeyName,
      to_step_number: stepIndex + 1,
      to_step_name: stepName,
      from_step_number: fromStep + 1,
      from_step_name: getComponentName(fromStep),
      navigation_method: method,
      session_id: config.sessionId
    });
    
    // Track new step view
    trackStepView(stepIndex, stepName);
    
    // Mark step as completed and save progress
    config.completedSteps.add(stepIndex);
    saveProgress(stepIndex);
    
    // Reset step timer
    config.stepStartTime = Date.now();
    
    // Check for completion
    if (stepIndex === getTotalSteps() - 1) {
      trackCompletion();
    }
  }

  /**
   * Track a step being viewed
   */
  function trackStepView(stepIndex, stepName) {
    trackEvent('step_viewed', {
      journey_name: config.journeyName,
      step_number: stepIndex + 1,
      step_name: stepName,
      session_id: config.sessionId,
      timestamp: Date.now()
    });
  }

  /**
   * Track button/interaction clicks
   * @param {string} action - Type of action (next, back, url, video, etc.)
   * @param {number} stepIndex - Current step index
   * @param {object} metadata - Additional metadata about the interaction
   */
  function trackInteraction(action, stepIndex, metadata = {}) {
    trackEvent('interaction', {
      journey_name: config.journeyName,
      step_number: stepIndex + 1,
      step_name: getComponentName(stepIndex),
      action_type: action,
      session_id: config.sessionId,
      ...metadata
    });
  }

  /**
   * Track external link clicks
   */
  function trackExternalLink(url, stepIndex) {
    trackEvent('external_link_clicked', {
      journey_name: config.journeyName,
      step_number: stepIndex + 1,
      url: url,
      session_id: config.sessionId
    });
  }

  /**
   * Track video interactions
   */
  function trackVideo(action, videoSrc, stepIndex) {
    trackEvent('video_interaction', {
      journey_name: config.journeyName,
      step_number: stepIndex + 1,
      video_action: action, // play, pause, complete, etc.
      video_source: videoSrc,
      session_id: config.sessionId
    });
  }

  /**
   * Track FAQ interactions
   */
  function trackFAQ(action, question, stepIndex) {
    trackEvent('faq_interaction', {
      journey_name: config.journeyName,
      step_number: stepIndex + 1,
      faq_action: action, // opened, closed
      question: question,
      session_id: config.sessionId
    });
  }

  /**
   * Track journey completion
   */
  function trackCompletion() {
    const totalTime = Date.now() - config.startTime;
    trackEvent('journey_completed', {
      journey_name: config.journeyName,
      total_time_seconds: Math.round(totalTime / 1000),
      total_steps: getTotalSteps(),
      completed_steps: config.completedSteps.size,
      session_id: config.sessionId,
      timestamp: Date.now()
    });
  }

  /**
   * Core tracking function - sends events to HubSpot via contact properties and page views
   */
  function trackEvent(eventName, properties) {
    if (!config.hubspotReady) {
      console.warn('HubSpot tracking not ready yet');
      return;
    }

    // Send to HubSpot using contact properties and virtual page views
    if (typeof window._hsq !== 'undefined') {
      // 1. Track as virtual page view for analytics
      const virtualPath = `/learning-journey/${config.journeyName}/${eventName}${properties.step_number ? '/step-' + properties.step_number : ''}`;
      window._hsq.push(['setPath', virtualPath]);
      window._hsq.push(['trackPageView']);
      
      // 2. Update contact properties with progression data
      const contactProperties = buildContactProperties(eventName, properties);
      if (Object.keys(contactProperties).length > 0) {
        window._hsq.push(['identify', contactProperties]);
      }
      
      console.log('📊 Tracked:', eventName, virtualPath, contactProperties);
    } else {
      console.warn('HubSpot _hsq not available');
    }

    // Also send to Google Analytics if available
    if (typeof window.gtag !== 'undefined') {
      window.gtag('event', eventName, {
        event_category: 'Learning Journey',
        ...properties
      });
    }
  }

  /**
   * Build contact property updates based on the event
   */
  function buildContactProperties(eventName, properties) {
    const props = {};
    const journeyPrefix = `lj_${sanitizePropertyName(config.journeyName)}`;
    
    // Common properties for all events
    props[`${journeyPrefix}_last_activity`] = new Date().toISOString();
    
    // Event-specific properties
    switch (eventName) {
      case 'journey_started':
        props[`${journeyPrefix}_status`] = 'started';
        props[`${journeyPrefix}_start_date`] = new Date().toISOString();
        props[`${journeyPrefix}_session_id`] = config.sessionId;
        break;
        
      case 'step_viewed':
      case 'step_navigated':
        props[`${journeyPrefix}_current_step`] = properties.step_number || properties.to_step_number;
        props[`${journeyPrefix}_current_step_name`] = properties.step_name || properties.to_step_name;
        props[`${journeyPrefix}_completed_steps`] = config.completedSteps.size;
        props[`${journeyPrefix}_status`] = 'in_progress';
        break;
        
      case 'journey_completed':
        props[`${journeyPrefix}_status`] = 'completed';
        props[`${journeyPrefix}_completion_date`] = new Date().toISOString();
        props[`${journeyPrefix}_total_time_seconds`] = properties.total_time_seconds;
        props[`${journeyPrefix}_completed_steps`] = properties.completed_steps;
        props[`${journeyPrefix}_total_steps`] = properties.total_steps;
        break;
        
      case 'session_ended':
        props[`${journeyPrefix}_session_time_seconds`] = properties.session_time_seconds;
        props[`${journeyPrefix}_final_step`] = properties.final_step;
        break;
    }
    
    return props;
  }

  /**
   * Sanitize journey name for use in HubSpot property names
   * HubSpot properties should only contain lowercase letters, numbers, and underscores
   */
  function sanitizePropertyName(name) {
    return name.toLowerCase().replace(/[^a-z0-9]+/g, '_');
  }

  /**
   * Save progress to localStorage
   */
  function saveProgress(currentStep) {
    try {
      const progress = {
        journeyName: config.journeyName,
        currentStep: currentStep,
        completedSteps: Array.from(config.completedSteps),
        sessionId: config.sessionId,
        lastVisit: new Date().toISOString()
      };
      localStorage.setItem('learning_journey_progress', JSON.stringify(progress));
    } catch (e) {
      console.warn('Could not save progress to localStorage:', e);
    }
  }

  /**
   * Load progress from localStorage
   */
  function loadProgress() {
    try {
      const saved = localStorage.getItem('learning_journey_progress');
      if (saved) {
        const progress = JSON.parse(saved);
        if (progress.journeyName === config.journeyName) {
          config.completedSteps = new Set(progress.completedSteps || []);
          return progress.currentStep;
        }
      }
    } catch (e) {
      console.warn('Could not load progress from localStorage:', e);
    }
    return 0;
  }

  /**
   * Handle page unload - track session end
   */
  function handleUnload() {
    const sessionTime = Date.now() - config.startTime;
    trackEvent('session_ended', {
      journey_name: config.journeyName,
      session_time_seconds: Math.round(sessionTime / 1000),
      final_step: config.completedSteps.size > 0 ? Math.max(...config.completedSteps) + 1 : 1,
      session_id: config.sessionId
    });
  }

  /**
   * Wait for HubSpot tracking to be ready
   */
  function waitForHubSpot(callback) {
    if (typeof window._hsq !== 'undefined') {
      callback();
    } else {
      // Check every 100ms for up to 5 seconds
      let attempts = 0;
      const interval = setInterval(() => {
        attempts++;
        if (typeof window._hsq !== 'undefined') {
          clearInterval(interval);
          callback();
        } else if (attempts > 50) {
          clearInterval(interval);
          console.warn('HubSpot tracking not detected after 5 seconds');
          // Still allow tracking to proceed
          window._hsq = window._hsq || [];
          callback();
        }
      }, 100);
    }
  }

  /**
   * Generate a unique session ID
   */
  function generateSessionId() {
    return 'session_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
  }

  /**
   * Helper functions that need to be defined by the implementation
   */
  function getComponentName(index) {
    if (window.components && window.components[index]) {
      return window.components[index].name || `Component ${window.components[index].id}`;
    }
    return `Step ${index + 1}`;
  }

  function getTotalSteps() {
    return window.components ? window.components.length : 0;
  }

  // Export to global scope
  window.LearningJourneyTracker = {
    init: initTracking,
    trackNavigation: trackNavigation,
    trackInteraction: trackInteraction,
    trackExternalLink: trackExternalLink,
    trackVideo: trackVideo,
    trackFAQ: trackFAQ,
    trackCompletion: trackCompletion
  };

})(window);
