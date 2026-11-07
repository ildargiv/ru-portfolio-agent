# Установка агента «Семейный офис» (портфель акций РФ) на Windows (без WSL).
#   powershell -ExecutionPolicy Bypass -File install.ps1 hermes-default   # Hermes: навык в основной профиль
#   powershell -ExecutionPolicy Bypass -File install.ps1 hermes           # Hermes: профиль "portfolio", если он есть, иначе основной
#   powershell -ExecutionPolicy Bypass -File install.ps1 claude
#   powershell -ExecutionPolicy Bypass -File install.ps1 codex
#   powershell -ExecutionPolicy Bypass -File install.ps1 openclaw
# Каталог Hermes: $env:HERMES_HOME, иначе %LOCALAPPDATA%\hermes, иначе ~\.hermes.
param([ValidateSet("hermes", "hermes-default", "claude", "codex", "openclaw")][string]$Target = "claude")
$ErrorActionPreference = "Stop"
$Src = Join-Path $PSScriptRoot "skills\finance\ru-portfolio"

function Copy-Skill($Dest) {
    New-Item -ItemType Directory -Force (Split-Path $Dest) | Out-Null
    if (Test-Path $Dest) { Remove-Item -Recurse -Force $Dest }
    Copy-Item -Recurse $Src $Dest
    Write-Host "Навык -> $Dest"
}

function Get-HermesHome {
    if ($env:HERMES_HOME) { return $env:HERMES_HOME }
    $local = Join-Path $env:LOCALAPPDATA "hermes"
    if (Test-Path $local) { return $local }
    return (Join-Path $HOME ".hermes")
}

function Find-Python {
    foreach ($c in @("py", "python", "python3")) {
        if (Get-Command $c -ErrorAction SilentlyContinue) { return $c }
    }
    return $null
}

switch ($Target) {
    "hermes-default" {
        $h = Get-HermesHome
        Copy-Skill (Join-Path $h "skills\finance\ru-portfolio")
        Write-Host "Hermes: начните новую сессию или выполните /reset"
    }
    "hermes" {
        $h = Get-HermesHome
        $prof = Join-Path $h "profiles\portfolio"
        if (Test-Path $prof) {
            Copy-Item (Join-Path $PSScriptRoot "SOUL.md") (Join-Path $prof "SOUL.md") -Force
            Copy-Skill (Join-Path $prof "skills\finance\ru-portfolio")
            Write-Host "Профиль Hermes 'portfolio' обновлён: $prof"
        } else {
            Copy-Skill (Join-Path $h "skills\finance\ru-portfolio")
            Write-Host "Профиль 'portfolio' не найден — навык установлен в основной профиль: $h (новая сессия или /reset)"
        }
    }
    "claude" {
        Copy-Skill (Join-Path $HOME ".claude\skills\ru-portfolio")
        $agents = Join-Path $HOME ".claude\agents"
        New-Item -ItemType Directory -Force $agents | Out-Null
        Copy-Item (Join-Path $PSScriptRoot "agents\claude-code\portfolio.md") $agents -Force
        Copy-Item (Join-Path $PSScriptRoot "agents\claude-code\portfolio-devil.md") $agents -Force
        Write-Host "Субагенты -> $agents (portfolio, portfolio-devil). Перезапустите сессию Claude Code."
    }
    "codex" {
        Copy-Skill (Join-Path $HOME ".codex\skills\ru-portfolio")
        Write-Host "Перезапустите сессию Codex."
    }
    "openclaw" {
        Copy-Skill (Join-Path $HOME ".openclaw\skills\ru-portfolio")
        Write-Host "Перезапустите OpenClaw. Характер агента: добавьте SOUL.md из этой папки в SOUL.md вашего workspace."
    }
}
$desk = if ($env:FAMILY_OFFICE) { $env:FAMILY_OFFICE } else { Join-Path $HOME "family-office" }
New-Item -ItemType Directory -Force $desk | Out-Null
Write-Host "Хранилище семейного офиса: $desk"
$py = Find-Python
if ($py) {
    try { & $py -m pip install --user --quiet pypdf } catch { Write-Host "Для чтения PDF: $py -m pip install pypdf" }
    Write-Host "Проверка доступа к MOEX..."
    try { & $py (Join-Path $Src "scripts\moex_share.py") SBER | Select-Object -First 3 } catch { Write-Host "MOEX ISS недоступен — проверьте сеть" }
} else {
    Write-Host "Python не найден (py / python / python3). Установите Python 3.9+ с python.org."
}
Write-Host "Портфель: скажите агенту «мой портфель: SBER, LKOH, MGNT» — дальше он ведёт его сам и попросите присылать брифинг каждый будний день в 19:15."
