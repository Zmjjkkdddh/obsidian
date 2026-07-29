# C 盘空间扫描脚本
Write-Host "========== C 盘空间 =========="
$drive = Get-PSDrive C
$used = [math]::Round($drive.Used/1GB, 1)
$free = [math]::Round($drive.Free/1GB, 1)
$total = $used + $free
Write-Host "已用: ${used}GB / 空闲: ${free}GB / 总计: ${total}GB"

$dirs = @(
    @{Path=$env:TEMP; Name="用户临时文件"},
    @{Path="C:\Windows\Temp"; Name="Windows临时文件"},
    @{Path="C:\Windows\SoftwareDistribution\Download"; Name="Windows更新缓存"},
    @{Path="$env:USERPROFILE\Downloads"; Name="下载文件夹"},
    @{Path="C:\Windows\Prefetch"; Name="Prefetch"},
    @{Path="$env:LOCALAPPDATA\Microsoft\Windows\INetCache"; Name="IE缓存"},
    @{Path="$env:LOCALAPPDATA\pip\cache"; Name="pip缓存"},
    @{Path="$env:APPDATA\npm-cache"; Name="npm缓存"}
)

Write-Host "`n========== 可清理目录 =========="
foreach ($d in $dirs) {
    if (Test-Path $d.Path) {
        $size = (Get-ChildItem -Path $d.Path -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        $sizeMB = [math]::Round($size/1MB, 1)
        Write-Host ("{0,-20} {1,10} MB" -f ($d.Name + ":"), $sizeMB)
    }
}

# 回收站
Write-Host "`n========== 回收站 =========="
try {
    $shell = New-Object -ComObject Shell.Application
    $recycle = $shell.NameSpace(0x0a)
    $count = 0
    $size = 0
    foreach ($item in $recycle.Items()) {
        $count++
        $size += $item.Size
    }
    $sizeMB = [math]::Round($size/1MB, 1)
    Write-Host "回收站: ${count} 个文件, ${sizeMB} MB"
} catch {
    Write-Host "无法访问回收站"
}

# 大文件夹 TOP 10
Write-Host "`n========== C:\Users 大文件夹 TOP10 =========="
$userPath = "$env:USERPROFILE"
Get-ChildItem -Path $userPath -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    $size = (Get-ChildItem -Path $_.FullName -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    [PSCustomObject]@{Name=$_.Name; SizeMB=[math]::Round($size/1MB,1)}
} | Sort-Object -Property SizeMB -Descending | Select-Object -First 10 | Format-Table -AutoSize
