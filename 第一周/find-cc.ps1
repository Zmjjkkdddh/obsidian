# Find CC-Switch
$home = $env:USERPROFILE
Write-Host "Searching for cc-switch in user profile..."
Get-ChildItem $home -Directory -Force -ErrorAction SilentlyContinue | ForEach-Object { Write-Host $_.Name }

Write-Host ""
Write-Host "Searching for cc-switch in AppData..."
Get-ChildItem "$home\AppData\Local" -Directory -Force -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'cc|switch' } | ForEach-Object { Write-Host $_.FullName }
Get-ChildItem "$home\AppData\Roaming" -Directory -Force -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'cc|switch' } | ForEach-Object { Write-Host $_.FullName }

Write-Host ""
Write-Host "Searching Program Files..."
Get-ChildItem "C:\Program Files" -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'cc|switch' } | ForEach-Object { Write-Host $_.FullName }

Write-Host ""
Write-Host "Searching entire user dir for cc-switch files..."
Get-ChildItem $home -Recurse -File -Force -Depth 4 -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'cc.switch|CC.Switch|cc-switch|CC-Switch' } | Select-Object -First 10 FullName | ForEach-Object { Write-Host $_.FullName }
