# C Drive Scanner
$drive = Get-PSDrive C
$used = [math]::Round($drive.Used/1GB, 1)
$free = [math]::Round($drive.Free/1GB, 1)
Write-Host "C Drive: Used=$used GB, Free=$free GB"

# Check key directories
$paths = @(
    $env:TEMP,
    "C:\Windows\Temp",
    "C:\Windows\SoftwareDistribution\Download",
    "$env:USERPROFILE\Downloads",
    "C:\Windows\Prefetch"
)

foreach ($p in $paths) {
    if (Test-Path $p) {
        $size = (Get-ChildItem $p -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        $mb = [math]::Round($size/1MB, 1)
        Write-Host "$p => $mb MB"
    }
}

# Top user folders
Get-ChildItem $env:USERPROFILE -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    $size = (Get-ChildItem $_.FullName -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    [PSCustomObject]@{Name=$_.Name; MB=[math]::Round($size/1MB,1)}
} | Sort-Object MB -Descending | Select-Object -First 10 | Format-Table -AutoSize
