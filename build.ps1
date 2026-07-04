# build.ps1 - Windows Plugin Build Script

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$CURRENT_DIR = $PSScriptRoot
if (-not $CURRENT_DIR) {
    $CURRENT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
}

# Load environment variables from build.conf
$CONF_FILE = Join-Path $CURRENT_DIR "build.conf"
if (Test-Path $CONF_FILE) {
    Get-Content $CONF_FILE | ForEach-Object {
        if ($_ -match '^\s*([A-Za-z_][A-Za-z0-9_]*)=(.*)$') {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim()
            [System.Environment]::SetEnvironmentVariable($name, $value, "Process")
        }
    }
}

function Write-Log {
    param([string]$Message)
    $logMessage = "[Plugin-Build Log]: $Message"
    Write-Host $logMessage
    Add-Content -Path (Join-Path $CURRENT_DIR "build.log") -Value $logMessage -Encoding UTF8
}

function Tar-Package {
    param([string]$PluginRoot)

    Write-Log "打包插件..."
    $pluginPath = Join-Path $CURRENT_DIR $PluginRoot

    if (-not (Test-Path $pluginPath)) {
        Write-Log "错误：插件目录不存在: $pluginPath"
        return
    }

    $indexFile = Join-Path $pluginPath "index.json"
    if (-not (Test-Path $indexFile)) {
        Write-Log "错误：index.json 不存在: $indexFile"
        return
    }

    # Read package_name from index.json
    $jsonContent = Get-Content -Path $indexFile -Raw -Encoding UTF8
    $jsonObject = $jsonContent | ConvertFrom-Json
    $packageName = $jsonObject.package_name

    if (-not $packageName) {
        Write-Log "错误：无法从 index.json 读取 package_name"
        return
    }

    # Replace dots with hyphens for tar.gz filename
    $tarName = $packageName -replace '\.', '-'
    $tarName = "$tarName.tar.gz"

    Write-Log "开始打包插件：$packageName"

    # Set permissions (Windows equivalent of chmod 777)
    Write-Log "设置目录权限..."
    icacls $pluginPath /grant "Everyone:(OI)(CI)(F)" /T /C /Q
    if ($LASTEXITCODE -ne 0) {
        Write-Log "警告：权限设置可能不完全成功"
    }

    # Create tar.gz using tar command (bsdtar supports -z on Windows)
    $outputTarGz = Join-Path $CURRENT_DIR $tarName

    # Remove old files if exist
    if (Test-Path $outputTarGz) { Remove-Item $outputTarGz -Force }

    Push-Location $pluginPath
    try {
        # Use tar with -z to create gzip compressed archive directly
        tar -zcvf $outputTarGz --exclude=".DS_Store" --exclude="*.tar" --exclude="*.tar.gz" --exclude="build.log" .
        if ($LASTEXITCODE -ne 0) {
            Write-Log "错误：tar 创建失败"
            return
        }
    }
    finally {
        Pop-Location
    }

    Write-Log "打包完成: $tarName"
}

function Main {
    if ($Args.Count -eq 0) {
        Write-Host "错误：必须提供打包root参数，示例：.\build.ps1 plugin-root"
        Write-Host "用法：.\build.ps1 参数1 [参数2 ...]"
        exit 1
    }

    foreach ($arg in $Args) {
        Tar-Package -PluginRoot $arg
    }
}

Main @Args
