# HubSpot Iframe Scaling Solution

## Problem
HubSpot strips or overrides iframe width/height CSS properties, forcing iframes to stay at their default size (560px x 315px) even when you try to make them responsive.

## Solution
Use CSS `transform: scale()` to scale the iframe up to fill its container.

## Working Code Template

```html
<div style="width: 100% !important; max-width: 1440px !important; margin: 0 auto !important; display: block !important; overflow: hidden !important;">
    <iframe 
        id="YOUR-IFRAME-ID" 
        style="border: none !important; display: block !important; margin: 0px auto !important; transform: scale(2.57) !important; transform-origin: 0 0 !important; width: 560px !important; height: 315px !important;" 
        src="YOUR-IFRAME-URL" 
        width="560" 
        height="315" 
        frameborder="0" 
        scrolling="no">
    </iframe>
</div>
<script>
    var iframe = document.getElementById('YOUR-IFRAME-ID');
    var container = iframe.parentElement;
    var scale = container.offsetWidth / 560;
    iframe.style.transform = 'scale(' + scale + ')';
    iframe.style.transformOrigin = '0 0';
    container.style.height = (315 * scale) + 'px';
</script>
```

## How to Use

1. Replace `YOUR-IFRAME-ID` with your iframe's unique ID
2. Replace `YOUR-IFRAME-URL` with your HubSpot iframe source URL
3. Paste the entire code block into your HubSpot page

## How It Works

- The iframe stays at its native 560px x 315px size
- JavaScript calculates the scale factor: `container width / 560`
- CSS `transform: scale()` visually enlarges the iframe to fill the container
- Container height is adjusted to match the scaled iframe height
- Max width of 1440px is maintained on the container

## Example (Current Implementation)

```html
<div style="width: 100% !important; max-width: 1440px !important; margin: 0 auto !important; display: block !important; overflow: hidden !important;">
    <iframe 
        id="tools-competency-iframe" 
        style="border: none !important; display: block !important; margin: 0px auto !important; transform: scale(2.57) !important; transform-origin: 0 0 !important; width: 560px !important; height: 315px !important;" 
        src="https://info.buildingtools.co/hubfs/tools-competency-v10.html" 
        width="560" 
        height="315" 
        frameborder="0" 
        scrolling="no">
    </iframe>
</div>
<script>
    var iframe = document.getElementById('tools-competency-iframe');
    var container = iframe.parentElement;
    var scale = container.offsetWidth / 560;
    iframe.style.transform = 'scale(' + scale + ')';
    iframe.style.transformOrigin = '0 0';
    container.style.height = (315 * scale) + 'px';
</script>
```
