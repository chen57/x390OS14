<
# PowerShell 脚本：download-kexts.ps1
# 用途：从官方 GitHub Releases 拉取常用 kext（Lilu, VirtualSMC, WhateverGreen, AppleALC, IntelMausi 等）
# 运行环境：Windows PowerShell 或 PowerShell Core (跨平台)
# 注意：脚本尽量自动选择合适的 release asset，但不同项目 asset 命名不完全一致。运行前请检查 URL 与资产名称。
#>

param(
    [string]$OutputDir = "EFI/OC/Kexts"
)

$repos = @(
    "acidanthera/Lilu",
    "acidanthera/VirtualSMC",
    "acidanthera/WhateverGreen",
    "acidanthera/AppleALC",
    "Mieze/IntelMausi"
)

function Get-LatestAsset {
    param($repo)
    $api = "https://api.github.com/repos/$repo/releases/latest"
    try {
        $rel = Invoke-RestMethod -Uri $api -Headers @{ "User-Agent" = "download-kexts-script" }
    } catch {
        Write-Warning "无法访问 $api: $_"
        return $null
    }
    if (-not $rel.assets) { return $null }
    # 优先寻找带 kext/zip/tar.gz 的 asset
    $asset = $rel.assets | Where-Object { $_.name -match "kext|zip|tar.gz|tarball|darwin" } | Select-Object -First 1
    if (-not $asset) { $asset = $rel.assets[0] }
    return $asset
}

if (-not (Test-Path $OutputDir)) { New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null }

foreach ($repo in $repos) {
    Write-Host "处理 $repo ..."
    $asset = Get-LatestAsset -repo $repo
    if (-not $asset) {
        Write-Warning "未找到 release asset for $repo"
        continue
    }
    $downloadUrl = $asset.browser_download_url
    $fileName = Join-Path $OutputDir $asset.name
    Write-Host "下载 $downloadUrl -> $fileName"
    try {
        Invoke-WebRequest -Uri $downloadUrl -OutFile $fileName -Headers @{ "User-Agent" = "download-kexts-script" }
    } catch {
        Write-Warning "下载失败: $_"
        continue
    }
    # 若为 zip，则尝试解压到 Kexts 目录
    if ($fileName -match "\.zip$") {
        Write-Host "解压 $fileName ..."
        try {
            Expand-Archive -Path $fileName -DestinationPath $OutputDir -Force
        } catch {
            Write-Warning "解压失败: $_"
        }
    }
}

Write-Host "完成。请检查 $OutputDir 并根据需要把 .kext 拖入 EFI/OC/Kexts 文件夹（注意保持 .kext 目录结构）。"
