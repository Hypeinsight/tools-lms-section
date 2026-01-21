# Script to extract link coordinates from SVG files
$svgDir = "C:\Users\Isuru\Special Projects\tools-lms-section\EDU Practical Guide (Implementation)"
$svgFiles = Get-ChildItem "$svgDir\*.svg" | Sort-Object Name

$results = @()

foreach ($file in $svgFiles) {
    $slideNumber = if ($file.Name -match '^(\d+)') { [int]$matches[1] } else { 0 }
    
    # Read the SVG content
    $content = Get-Content $file.FullName -Raw
    
    # Parse SVG dimensions
    if ($content -match 'viewBox="0 0 (\d+) (\d+)"') {
        $svgWidth = [int]$matches[1]
        $svgHeight = [int]$matches[2]
    }
    
    # Find all <a href="..."> tags with their content
    $linkPattern = '<a\s+href="([^"]+)"[^>]*>(.*?)</a>'
    $matches = [regex]::Matches($content, $linkPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)
    
    foreach ($match in $matches) {
        $url = $match.Groups[1].Value
        $linkContent = $match.Groups[2].Value
        
        # Decode HTML entities
        $url = $url -replace '&#38;', '&'
        
        # Try to extract rect coordinates
        $x = $y = $width = $height = $null
        
        if ($linkContent -match '<rect[^>]+x="([^"]+)"[^>]+y="([^"]+)"[^>]+width="([^"]+)"[^>]+height="([^"]+)"') {
            $x = [double]$matches[1]
            $y = [double]$matches[2]
            $width = [double]$matches[3]
            $height = [double]$matches[4]
        }
        elseif ($linkContent -match '<rect[^>]+width="([^"]+)"[^>]+height="([^"]+)"[^>]+x="([^"]+)"[^>]+y="([^"]+)"') {
            $width = [double]$matches[1]
            $height = [double]$matches[2]
            $x = [double]$matches[3]
            $y = [double]$matches[4]
        }
        
        if ($x -ne $null) {
            # Convert to percentages
            $xPercent = [math]::Round(($x / $svgWidth) * 100, 2)
            $yPercent = [math]::Round(($y / $svgHeight) * 100, 2)
            $widthPercent = [math]::Round(($width / $svgWidth) * 100, 2)
            $heightPercent = [math]::Round(($height / $svgHeight) * 100, 2)
            
            $results += [PSCustomObject]@{
                Slide = $slideNumber
                FileName = $file.Name
                URL = $url
                X = $xPercent
                Y = $yPercent
                Width = $widthPercent
                Height = $heightPercent
                SVGWidth = $svgWidth
                SVGHeight = $svgHeight
            }
        }
    }
}

# Output results
Write-Host "`n=== LINK COORDINATES EXTRACTED ===" -ForegroundColor Green
$results | Format-Table -AutoSize

# Export to JSON for easy import
$results | ConvertTo-Json | Out-File "$svgDir\link-coordinates.json"
Write-Host "`nResults saved to: $svgDir\link-coordinates.json" -ForegroundColor Cyan
