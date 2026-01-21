# PowerShell Script to Update tracking.js URL in HTML Files
# 
# USAGE:
# 1. Upload tracking.js to HubSpot File Manager
# 2. Copy the full URL (e.g., https://12345678.fs1.hubspotusercontent-na1.net/hubfs/tools-lms-section/tracking.js)
# 3. Run this script and paste the URL when prompted

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Update Tracking URL in HTML Files" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Get the HubSpot URL from user
Write-Host "First, upload tracking.js to HubSpot File Manager" -ForegroundColor Yellow
Write-Host "Then copy the full URL to the file" -ForegroundColor Yellow
Write-Host ""
$hubspotUrl = Read-Host "Paste your HubSpot tracking.js URL here"

if ([string]::IsNullOrWhiteSpace($hubspotUrl)) {
    Write-Host "Error: No URL provided. Exiting." -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "Using URL: $hubspotUrl" -ForegroundColor Green
Write-Host ""

# List of files to update
$files = @(
    "tools-competency-v11.html",
    "tools-competency-v11-swinburne.html",
    "tools-competency-v12.html",
    "tools-competency-v12-swinburne.html"
)

$updated = 0
$failed = 0

foreach ($file in $files) {
    $filePath = Join-Path $PSScriptRoot $file
    
    if (Test-Path $filePath) {
        Write-Host "Updating $file..." -ForegroundColor Cyan
        
        try {
            # Read file content
            $content = Get-Content $filePath -Raw
            
            # Replace the tracking.js src
            $content = $content -replace '<script src="tracking\.js"></script>', "<script src=`"$hubspotUrl`"></script>"
            
            # Write back to file
            Set-Content $filePath -Value $content -NoNewline
            
            Write-Host "  ✓ Updated successfully" -ForegroundColor Green
            $updated++
        }
        catch {
            Write-Host "  ✗ Failed to update: $_" -ForegroundColor Red
            $failed++
        }
    }
    else {
        Write-Host "  ✗ File not found: $file" -ForegroundColor Red
        $failed++
    }
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Updated: $updated files" -ForegroundColor Green
Write-Host "  Failed:  $failed files" -ForegroundColor $(if ($failed -gt 0) { "Red" } else { "Green" })
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Upload all HTML files to HubSpot File Manager" -ForegroundColor White
Write-Host "2. Embed on your HubSpot landing page" -ForegroundColor White
Write-Host "3. Test and view results in: Reports > Analytics Tools > Custom Behavioral Events" -ForegroundColor White
Write-Host ""
