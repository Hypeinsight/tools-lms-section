# Script to embed SVG and GIF files as base64 in HTML files

$htmlFiles = @(
    "edu-practical-guide-implementation.html",
    "edu-practical-guide-implementation-rmit.html"
)

foreach ($htmlFile in $htmlFiles) {
    Write-Host "Processing $htmlFile..."
    
    $content = Get-Content $htmlFile -Raw
    $basePath = "EDU Practical Guide (Implementation)"
    
    # Find all SVG file references
    $svgPattern = 'file:\s*"([^"]+\.svg)"'
    $svgMatches = [regex]::Matches($content, $svgPattern)
    
    foreach ($match in $svgMatches) {
        $relativePath = $match.Groups[1].Value
        $fullPath = Join-Path $PSScriptRoot $relativePath
        
        if (Test-Path $fullPath) {
            Write-Host "  Embedding: $relativePath"
            
            # Read SVG file and convert to base64
            $svgBytes = [System.IO.File]::ReadAllBytes($fullPath)
            $base64 = [System.Convert]::ToBase64String($svgBytes)
            $dataUri = "data:image/svg+xml;base64,$base64"
            
            # Replace file path with data URI
            $content = $content -replace [regex]::Escape("file: `"$relativePath`""), "file: `"$dataUri`""
        } else {
            Write-Warning "  File not found: $fullPath"
        }
    }
    
    # Find GIF file references
    $gifPattern = 'url:\s*"([^"]+\.gif)"'
    $gifMatches = [regex]::Matches($content, $gifPattern)
    
    foreach ($match in $gifMatches) {
        $relativePath = $match.Groups[1].Value
        $fullPath = Join-Path $PSScriptRoot $relativePath
        
        if (Test-Path $fullPath) {
            Write-Host "  Embedding: $relativePath"
            
            # Read GIF file and convert to base64
            $gifBytes = [System.IO.File]::ReadAllBytes($fullPath)
            $base64 = [System.Convert]::ToBase64String($gifBytes)
            $dataUri = "data:image/gif;base64,$base64"
            
            # Replace file path with data URI
            $content = $content -replace [regex]::Escape("url: `"$relativePath`""), "url: `"$dataUri`""
        } else {
            Write-Warning "  File not found: $fullPath"
        }
    }
    
    # Save embedded version
    $outputFile = $htmlFile -replace '\.html$', '-embedded.html'
    Set-Content -Path $outputFile -Value $content -NoNewline
    Write-Host "  Saved to: $outputFile`n"
}

Write-Host "Done! Created embedded HTML files."
