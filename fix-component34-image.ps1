# Extract embedded image from Component 34 SVG and modify HTML to use it as an overlay

$svgPath = "C:\Users\Isuru\Special Projects\tools-lms-section\builders\v1\Component 34.svg"
$htmlPath = "C:\Users\Isuru\Special Projects\tools-lms-section\tools-competency-builders-v1.html"
$outputHtmlPath = "C:\Users\Isuru\Special Projects\tools-lms-section\tools-competency-builders-v1-fixed.html"

Write-Host "Reading SVG file..."
$svgContent = Get-Content $svgPath -Raw

# Extract the base64 image data using regex
if ($svgContent -match 'data:image/png;base64,([A-Za-z0-9+/=]+)"') {
    $base64Image = $matches[1]
    $imageDataUrl = "data:image/png;base64,$base64Image"
    Write-Host "Found embedded image in SVG"
    
    # Find the image element to get position and size
    if ($svgContent -match '<image[^>]+x="([^"]+)"[^>]+y="([^"]+)"[^>]+width="([^"]+)"[^>]+height="([^"]+)"') {
        $imgX = $matches[1]
        $imgY = $matches[2]
        $imgW = $matches[3]
        $imgH = $matches[4]
        Write-Host "Image position: x=$imgX, y=$imgY, w=$imgW, h=$imgH"
        
        # Remove the embedded image from SVG
        $modifiedSvg = $svgContent -replace '<image[^>]+>.*?</image>', ''
        $modifiedSvg = $modifiedSvg -replace '<image[^>]+/>', ''
        
        # Save modified SVG
        $modifiedSvgPath = "C:\Users\Isuru\Special Projects\tools-lms-section\builders\v1\Component 34-noimage.svg"
        Set-Content -Path $modifiedSvgPath -Value $modifiedSvg
        Write-Host "Created SVG without embedded image: $modifiedSvgPath"
        
        # Read HTML and modify Component 34 configuration
        Write-Host "Modifying HTML..."
        $html = Get-Content $htmlPath -Raw
        
        # Replace Component 34 config to use the modified SVG and add the image as an overlay
        $newConfig = @"
      // Component 34 (Slide 7)
      {
        id: 34,
        file: "builders/v1/Component 34-noimage.svg",
        viewBoxWidth: 1440,
        viewBoxHeight: 2282,
        overlays: [
          // Navigation buttons
          { action: "back", x: 80, y: 1948, w: 142, h: 56 },
          { action: "next", x: 1087, y: 1948, w: 273, h: 56 }
        ],
        images: [
          { src: "$imageDataUrl", x: $imgX, y: $imgY, w: $imgW, h: $imgH }
        ]
      },
"@
        
        $html = $html -replace '(?s)// Component 34 \(Slide 7\).*?(?=\s*// Component 35)', $newConfig
        
        Set-Content -Path $outputHtmlPath -Value $html
        Write-Host "Created fixed HTML: $outputHtmlPath"
        Write-Host "Now run the base64 script on this fixed version!"
    }
} else {
    Write-Host "Could not find embedded image in SVG"
}
