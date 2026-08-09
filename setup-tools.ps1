#Requires -Version 5.1

[CmdletBinding()]
param(
    [switch]$SkipWally,
    [switch]$SkipVSCodeExtensions,
    [switch]$SkipStudioPlugin,
    [switch]$SkipChecks
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    Write-Host ""
    Write-Host "============================================================" -ForegroundColor DarkCyan
    Write-Host $Message -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor DarkCyan
}

function Write-Ok {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-Warn {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Test-CommandAvailable {
    param(
        [Parameter(Mandatory = $true)]
        [string]$CommandName
    )

    return $null -ne (Get-Command $CommandName -ErrorAction SilentlyContinue)
}

function Invoke-Checked {
    param(
        [Parameter(Mandatory = $true)]
        [string]$CommandName,

        [Parameter(Mandatory = $true)]
        [string[]]$Arguments
    )

    & $CommandName @Arguments

    if ($LASTEXITCODE -ne 0) {
        $argumentText = $Arguments -join " "
        throw "Command failed: $CommandName $argumentText. Exit code: $LASTEXITCODE"
    }
}

Write-Step "1. Check project root"

$ProjectRoot = (Get-Location).Path

Write-Host "Project root: $ProjectRoot"

if (-not (Test-Path -LiteralPath ".\default.project.json")) {
    throw @"
default.project.json was not found.

Open PowerShell at the project root and run the script again:

cd "D:\Project\MythicCubes"
.\setup-tools.ps1
"@
}

Write-Ok "default.project.json found"

Write-Step "2. Check Rokit"

if (-not (Test-CommandAvailable "rokit")) {
    throw @"
Rokit was not found in PATH.

Close VS Code completely, reopen it, create a new PowerShell terminal,
and confirm this command works:

rokit --version
"@
}

Invoke-Checked -CommandName "rokit" -Arguments @("--version")
Write-Ok "Rokit is available"

Write-Step "3. Initialize Rokit manifest"

if (-not (Test-Path -LiteralPath ".\rokit.toml")) {
    Invoke-Checked -CommandName "rokit" -Arguments @("init")
    Write-Ok "rokit.toml created"
}
else {
    Write-Ok "rokit.toml already exists"
}

Write-Step "4. Add project tools"

$Tools = @(
    @{
        Name = "Rojo"
        Id   = "rojo-rbx/rojo"
    },
    @{
        Name = "StyLua"
        Id   = "JohnnyMorganz/StyLua"
    },
    @{
        Name = "Selene"
        Id   = "Kampfkarren/selene"
    }
)

if (-not $SkipWally) {
    $Tools += @{
        Name = "Wally"
        Id   = "UpliftGames/wally"
    }
}

foreach ($Tool in $Tools) {
    $ToolAlreadyConfigured = Select-String `
        -LiteralPath ".\rokit.toml" `
        -SimpleMatch `
        -Pattern $Tool.Id `
        -Quiet

    if ($ToolAlreadyConfigured) {
        Write-Ok "$($Tool.Name) is already configured"
        continue
    }

    Write-Host "Adding $($Tool.Name): $($Tool.Id)"

    Invoke-Checked `
        -CommandName "rokit" `
        -Arguments @("add", $Tool.Id)

    Write-Ok "$($Tool.Name) added"
}

Write-Step "5. Install tools"

Invoke-Checked -CommandName "rokit" -Arguments @("install")
Write-Ok "Rokit tools installed"

Write-Step "6. Refresh PATH for current terminal"

$MachinePath = [Environment]::GetEnvironmentVariable(
    "Path",
    [EnvironmentVariableTarget]::Machine
)

$UserPath = [Environment]::GetEnvironmentVariable(
    "Path",
    [EnvironmentVariableTarget]::User
)

$env:Path = "$MachinePath;$UserPath"

$RokitBin = Join-Path $env:USERPROFILE ".rokit\bin"

if (Test-Path -LiteralPath $RokitBin) {
    if ($env:Path -notlike "*$RokitBin*") {
        $env:Path = "$env:Path;$RokitBin"
    }

    Write-Ok "Rokit bin added to current PATH"
}
else {
    Write-Warn "Rokit bin directory was not found: $RokitBin"
}

Write-Step "7. Check installed commands"

$RequiredCommands = @(
    "rojo",
    "stylua",
    "selene"
)

if (-not $SkipWally) {
    $RequiredCommands += "wally"
}

foreach ($CommandName in $RequiredCommands) {
    if (Test-CommandAvailable $CommandName) {
        Write-Host ""
        Write-Host "$CommandName version:" -ForegroundColor Cyan

        & $CommandName --version

        if ($LASTEXITCODE -eq 0) {
            Write-Ok "$CommandName is available"
        }
        else {
            Write-Warn "$CommandName exists but version check failed"
        }
    }
    else {
        Write-Warn "$CommandName is not visible in the current terminal"
    }
}

Write-Step "8. Install Rojo Studio plugin"

if ($SkipStudioPlugin) {
    Write-Warn "Rojo Studio plugin installation skipped"
}
elseif (-not (Test-CommandAvailable "rojo")) {
    Write-Warn "Rojo command is unavailable; Studio plugin was not installed"
}
else {
    & rojo plugin install

    if ($LASTEXITCODE -eq 0) {
        Write-Ok "Rojo Studio plugin installed"
        Write-Warn "Restart Roblox Studio before using the plugin"
    }
    else {
        Write-Warn "Rojo Studio plugin installation failed"
        Write-Warn "Make sure Roblox Studio is installed, then run: rojo plugin install"
    }
}

Write-Step "9. Install VS Code extensions"

if ($SkipVSCodeExtensions) {
    Write-Warn "VS Code extension installation skipped"
}
elseif (-not (Test-CommandAvailable "code")) {
    Write-Warn "The code command was not found"
    Write-Warn "Install the extensions manually in VS Code:"
    Write-Host "  JohnnyMorganz.luau-lsp"
    Write-Host "  evaera.vscode-rojo"
    Write-Host "  JohnnyMorganz.stylua"
    Write-Host "  Kampfkarren.selene-vscode"
}
else {
    $Extensions = @(
        "JohnnyMorganz.luau-lsp",
        "evaera.vscode-rojo",
        "JohnnyMorganz.stylua",
        "Kampfkarren.selene-vscode"
    )

    foreach ($Extension in $Extensions) {
        Write-Host "Installing extension: $Extension"

        & code --install-extension $Extension

        if ($LASTEXITCODE -eq 0) {
            Write-Ok "Extension installed: $Extension"
        }
        else {
            Write-Warn "Extension installation failed: $Extension"
        }
    }

    Write-Warn "Reload VS Code after the script finishes"
}

if ($SkipChecks) {
    Write-Step "10. Checks skipped"
}
else {
    Write-Step "10. Run Rojo build check"

    if (Test-CommandAvailable "rojo") {
        & rojo build default.project.json -o default-current.rbxlx

        if ($LASTEXITCODE -eq 0) {
            Write-Ok "Rojo build succeeded: default-current.rbxlx"
        }
        else {
            Write-Warn "Rojo is installed, but the project build failed"
            Write-Warn "Check default.project.json and source mappings"
        }
    }
    else {
        Write-Warn "Rojo build skipped because rojo is unavailable"
    }

    Write-Step "11. Run StyLua check"

    $FormatTargets = @()

    if (Test-Path -LiteralPath ".\src") {
        $FormatTargets += "src"
    }

    if (Test-Path -LiteralPath ".\tests") {
        $FormatTargets += "tests"
    }

    if (-not (Test-CommandAvailable "stylua")) {
        Write-Warn "StyLua check skipped because stylua is unavailable"
    }
    elseif ($FormatTargets.Count -eq 0) {
        Write-Warn "No src or tests directory was found"
    }
    else {
        $StyLuaArguments = @("--check") + $FormatTargets

        & stylua @StyLuaArguments

        if ($LASTEXITCODE -eq 0) {
            Write-Ok "StyLua check passed"
        }
        else {
            Write-Warn "StyLua found files that need formatting"
            Write-Host ""
            Write-Host "Run this command to format them:"
            Write-Host "stylua $($FormatTargets -join ' ')"
        }
    }

    Write-Step "12. Run Selene check"

    if (-not (Test-CommandAvailable "selene")) {
        Write-Warn "Selene check skipped because selene is unavailable"
    }
    elseif (-not (Test-Path -LiteralPath ".\src")) {
        Write-Warn "Selene check skipped because src was not found"
    }
    else {
        & selene src

        if ($LASTEXITCODE -eq 0) {
            Write-Ok "Selene check passed"
        }
        else {
            Write-Warn "Selene found lint issues"
            Write-Warn "Review the messages above and check selene.toml"
        }
    }
}

Write-Step "Setup completed"

Write-Host "Project root: $ProjectRoot"
Write-Host ""
Write-Host "Next steps:"
Write-Host "1. Close this terminal."
Write-Host "2. Reload or reopen VS Code."
Write-Host "3. Restart Roblox Studio."
Write-Host "4. Open a new PowerShell terminal."
Write-Host "5. Run: rojo serve"
Write-Host "6. Open Roblox Studio."
Write-Host "7. Open Plugins -> Rojo."
Write-Host "8. Connect to the running Rojo server."
Write-Host ""
Write-Host "Final verification commands:"
Write-Host "rokit --version"
Write-Host "rojo --version"
Write-Host "stylua --version"
Write-Host "selene --version"

if (-not $SkipWally) {
    Write-Host "wally --version"
}
