$drive = Get-PSDrive C
$used = [math]::Round($drive.Used/1GB, 1)
$free = [math]::Round($drive.Free/1GB, 1)
Write-Host "C Drive: Used=$used GB, Free=$free GB"
Write-Host ""

# Temp files
$paths = @(
    @{Path=$env:TEMP; Name="User Temp"},
    @{Path="C:\Windows\Temp"; Name="Windows Temp"},
    @{Path="C:\Windows\SoftwareDistribution\Download"; Name="WinUpdate Cache"},
    @{Path="C:\Windows\Prefetch"; Name="Prefetch"},
    @{Path="$env:LOCALAPPDATA\pip\cache"; Name="pip Cache"},
    @{Path="$env:APPDATA\npm-cache"; Name="npm Cache"}
)
Write-Host "=== Cleanable ==="
foreach ($p in $paths) {
    if (Test-Path $p.Path) {
        $size = (Get-ChildItem $p.Path -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        $mb = [math]::Round($size/1MB, 1)
        if ($mb -gt 0) { Write-Host "$($p.Name): $mb MB" }
    }
}

# Recycle bin
Write-Host ""
Write-Host "=== Recycle Bin ==="
try { $rb=(New-Object -ComObject Shell.Application).NameSpace(0x0a); $c=0; $s=0; foreach($i in $rb.Items()){$c++;$s+=$i.Size}; Write-Host "Files: $c, Size: $([math]::Round($s/1MB,1)) MB" } catch { Write-Host "N/A" }

# Top user folders
Write-Host ""
Write-Host "=== Large Folders in User ==="
Get-ChildItem $env:USERPROFILE -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    $sz = (Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    [PSCustomObject]@{Folder=$_.Name; MB=[math]::Round($sz/1MB,1)}
} | Sort-Object MB -Descending | Select-Object -First 12 | Format-Table -AutoSize
