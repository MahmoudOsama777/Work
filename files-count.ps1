# Step 1: Get the last folder (A–Z) in current directory
$level1 = Get-ChildItem -Directory | Sort-Object Name -Descending | Select-Object -First 1
if (-not $level1) { 
    Write-Host "No folders found in current directory." -ForegroundColor Red
    return
}

# Step 2: Get the last subfolder inside $level1
$level2 = Get-ChildItem -Path $level1.FullName -Directory | Sort-Object Name -Descending | Select-Object -First 1
if (-not $level2) {
    Write-Host "No subfolders found in '$($level1.Name)'." -ForegroundColor Yellow
    return
}

Write-Host "Navigated to: $($level2.FullName)" -ForegroundColor Green

# Step 3: Look for 'Black' and 'White' folders inside $level2
$blackFolder = Get-ChildItem -Path $level2.FullName -Directory | Where-Object { $_.Name -eq 'Black' }
$whiteFolder = Get-ChildItem -Path $level2.FullName -Directory | Where-Object { $_.Name -eq 'White' }

# Create 'Black' folder if not found
if (-not $blackFolder) {
    $blackFolder = New-Item -ItemType Directory -Path (Join-Path $level2.FullName "Black")
    Write-Host "Created folder 'Black' in '$($level2.Name)'." -ForegroundColor Green
}

# Create 'White' folder if not found
if (-not $whiteFolder) {
    $whiteFolder = New-Item -ItemType Directory -Path (Join-Path $level2.FullName "White")
    Write-Host "Created folder 'White' in '$($level2.Name)'." -ForegroundColor Green
}

# Initialize counters
$blackCount = 0
$whiteCount = 0

# Count files in Black folder (recursive)
$blackCount = (Get-ChildItem -Path $blackFolder.FullName -File -Recurse | Measure-Object).Count
Write-Host "Files in 'Black': $blackCount" -ForegroundColor Red

# Count files in White folder (recursive)
$whiteCount = (Get-ChildItem -Path $whiteFolder.FullName -File -Recurse | Measure-Object).Count
Write-Host "Files in 'White': $whiteCount" -ForegroundColor Red

# Total
$total = $blackCount + $whiteCount
Write-Host "Total (Black + White): $total" -ForegroundColor Cyan