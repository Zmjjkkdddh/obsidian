$dl = "$env:USERPROFILE\Downloads"
Write-Host "========== Downloads FILES (top 30 by size) =========="
Get-ChildItem $dl -File | Sort-Object Length -Descending | Select-Object -First 30 | ForEach-Object {
    $mb = [math]::Round($_.Length/1MB, 1)
    $kb = [math]::Round($_.Length/1KB, 1)
    if ($mb -ge 1) {
        Write-Host ("{0,8} MB  {1}" -f $mb, $_.Name)
    } else {
        Write-Host ("{0,8} KB  {1}" -f $kb, $_.Name)
    }
}

Write-Host ""
Write-Host "========== Downloads FOLDERS =========="
Get-ChildItem $dl -Directory | ForEach-Object {
    $size = (Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    $mb = [math]::Round($size/1MB, 1)
    Write-Host ("{0,8} MB  {1}/" -f $mb, $_.Name)
}

Write-Host ""
$total = (Get-ChildItem $dl -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
Write-Host ("Total: " + [math]::Round($total/1MB, 1) + " MB")
