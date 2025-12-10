# PowerShell Profile for Dotfiles


# --- Helper Functions for UX ---

$eSuccess = [char]0x2705
$eError = [char]0x274C
$eInfo = "$([char]0x2139)$([char]0xFE0F)"
$eWarning = "$([char]0x26A0)$([char]0xFE0F)"

function Show-Success {
    param ( [string]$Message )
    Write-Host "$eSuccess  $Message" -ForegroundColor Green
}

function Show-Error {
    param ( [string]$Message )
    Write-Host "$eError  $Message" -ForegroundColor Red
}

function Show-Info {
    param ( [string]$Message )
    Write-Host "$eInfo   $Message" -ForegroundColor Cyan
}

function Show-Warning {
    param ( [string]$Message )
    Write-Host "$eWarning   $Message" -ForegroundColor Yellow
}

# --- Navigator & Config ---

function config {
    Show-Info "Opening PowerShell profile in Code..."
    try {
        code $PROFILE
    } catch {
        Show-Error "Failed to open VS Code. $_"
    }
}

function r {
    Show-Info "Reloading profile..."
    . $PROFILE
    Show-Success "Profile reloaded!"
}

# --- Git Aliases ---

function pull {
    Show-Info "Git Pull Origin Master..."
    git pull origin master
    if ($LASTEXITCODE -eq 0) { Show-Success "Pulled successfully." } else { Show-Error "Git pull failed." }
}

function push {
    Show-Info "Git Push Origin Master..."
    git push origin master
    if ($LASTEXITCODE -eq 0) { Show-Success "Pushed successfully." } else { Show-Error "Git push failed." }
}

function master {
    Show-Info "Switching to master..."
    git checkout master
    if ($LASTEXITCODE -eq 0) { Show-Success "On master branch." } else { Show-Error "Failed to checkout master." }
}

function lsbranch {
    git branch
}

function gst {
    git status
}

function gl {
    git log
}

function commit {
    param ( [string]$Message )
    if ([string]::IsNullOrWhiteSpace($Message)) {
        Show-Error "Please provide a commit message."
        return
    }
    git add .
    git commit -am "$Message"
    if ($LASTEXITCODE -eq 0) { Show-Success "Changes committed." } else { Show-Error "Commit failed." }
}

function branch {
    param ( [string]$Name )
    if ([string]::IsNullOrWhiteSpace($Name)) { Show-Error "Missing branch name."; return }
    git checkout "$Name"
    if ($LASTEXITCODE -eq 0) { Show-Success "Switched to branch $Name." } else { Show-Error "Failed to switch branch." }
}

function cbranch {
    param ( [string]$Name )
    if ([string]::IsNullOrWhiteSpace($Name)) { Show-Error "Missing branch name."; return }
    git checkout -b "$Name"
    if ($LASTEXITCODE -eq 0) { Show-Success "Created and switched to branch $Name." } else { Show-Error "Failed to create branch." }
}

function dbranch {
    param ( [string]$Name )
    if ([string]::IsNullOrWhiteSpace($Name)) { Show-Error "Missing branch name."; return }
    git branch -d "$Name"
    if ($LASTEXITCODE -eq 0) { Show-Success "Deleted branch $Name." } else { Show-Error "Failed to delete branch." }
}

# --- Laravel / PHP Aliases ---

function serve {
    Show-Info "Starting Laravel Server..."
    php artisan serve --host=localhost --port=8000
}

function rl {
    php artisan route:list
}

function watch {
    Show-Info "Starting NPM Watch..."
    npm run watch
}

function prod {
    Show-Info "Building for Production..."
    npm run build
    if ($LASTEXITCODE -eq 0) { Show-Success "Build complete." } else { Show-Error "Build failed." }
}

function dev {
    Show-Info "Starting NPM Dev..."
    npm run dev
}

function lrv {
    param ( [string]$Name )
    if ([string]::IsNullOrWhiteSpace($Name)) { Show-Error "Project name required."; return }

    Show-Info "Creating Laravel Project '$Name'..."
    composer create-project laravel/laravel "$Name"

    if ($LASTEXITCODE -eq 0) {
        Set-Location "$Name"
        php artisan storage:link
        Show-Success "Laravel project created and setup!"
    } else {
        Show-Error "Failed to create project."
    }
}

function opt {
    Show-Info "Clearing caches..."
    php artisan optimize:clear
    if ($LASTEXITCODE -eq 0) { Show-Success "Optimization cleared." } else { Show-Error "Failed to clear." }
}

function migrate {
    Show-Info "Running migrations..."
    php artisan migrate
}

function fresh {
    Show-Warning "Running MIGRATE:FRESH (Database will be wiped!)"
    php artisan migrate:fresh
}

function seed {
    Show-Info "Seeding database..."
    php artisan db:seed
}

function mm {
    param ( [string]$Name )
    if ([string]::IsNullOrWhiteSpace($Name)) { Show-Error "Model name needed."; return }
    php artisan make:model "$Name" -m
}

function mmf {
    param ( [string]$Name )
    if ([string]::IsNullOrWhiteSpace($Name)) { Show-Error "Model name needed."; return }
    php artisan make:model "$Name" -mf
}

function m {
    param ( [string]$Name )
    if ([string]::IsNullOrWhiteSpace($Name)) { Show-Error "Migration name needed."; return }
    php artisan make:migration "$Name"
}

# --- Docker Aliases ---

function dockup {
    Show-Info "Starting Docker Compose..."
    docker-compose up -d --build
    if ($LASTEXITCODE -eq 0) { Show-Success "Docker containers verified up." } else { Show-Error "Docker failed to start." }
}

function dock {
    Show-Info "Running PHP container..."
    docker-compose run php
}

# --- Python Helper Functions ---

function pyinit {
    if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
        Show-Error "Python is not installed."
        return
    }

    $venvDir = "venv"
    if (-not (Test-Path $venvDir)) {
        Show-Info "Creating clean 'venv' environment..."
        python -m venv $venvDir
        if ($LASTEXITCODE -ne 0) { Show-Error "Failed to create venv."; return }
    } else {
        Show-Success "'venv' directory already exists."
    }

    $activateScript = ".\venv\Scripts\Activate.ps1"
    if (Test-Path $activateScript) {
        Show-Info "To activate, run: $activateScript"
        # We can't easily source from a function in a way that stays in the parent unless we dot-source the function call itself usually
        # But we can try to invoke expression
        # Invoke-Expression $activateScript
        # Note: PowerShell scoping makes activation tricky from inside a function consistently.
        Show-Warning "Please run:  . .\venv\Scripts\Activate.ps1   to activate it manually."
    } else {
        Show-Error "Activation script not found."
    }
}

function uvistart {
    param (
        [int]$Port = 8000,
        [switch]$Detach
    )

    if (-not (Get-Command uvicorn -ErrorAction SilentlyContinue)) {
        Show-Error "Uvicorn not found. Is your venv activated?"
        return
    }

    if (-not (Test-Path "app/main.py")) {
        Show-Error "app/main.py not found."
        return
    }

    if ($Detach) {
        Show-Info "Starting Uvicorn in background on port $Port..."
        Start-Process -FilePath "uvicorn" -ArgumentList "app.main:app --host 127.0.0.1 --port $Port" -WindowStyle Hidden
        Show-Success "Uvicorn started (Hidden)."
    } else {
        Show-Info "Starting Uvicorn on port $Port..."
        uvicorn app.main:app --reload --port $Port
    }
}

# --- Flutter Aliases ---

function pubget {
    Show-Info "Flutter Pub Get..."
    flutter pub get
}

function frun {
    Show-Info "Flutter Run (Chrome)..."
    flutter run -d chrome
}

# --- SSH Shortcuts (Windows Native SSH) ---
# Note: Ensure you have your keys set up in $HOME/.ssh

function shserve { ssh root@31.97.25.142 }
function isamserve { ssh root@91.205.223.18 -p 50050 }
function lpserve { ssh -tt root@159.223.142.139 }
function upcserve { ssh javier@20.106.172.238 }
function iaisamserve { ssh root@217.15.171.169 }
function vaserve { ssh -tt root@172.13.38.11 -p 2211 }
function 28serve { ssh -tt deploy@143.244.185.161 }
function ingserve { ssh -tt ingenioedu@ingenio.edu.pe -p 22 }
function cigoserve { ssh -tt root@143.198.167.8 -p 22 }
function cigoprod { ssh -tt root@10.8.110.111 -p 22022 }
function winprod { ssh -tt ubuntu@10.0.1.230 }
function windev { ssh -tt ubuntu@10.0.1.112 }
function agenteprod { ssh -tt root@192.241.175.109 }

# --- Extras ---

# Enable Oh-My-Posh if available
# if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
#    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\janover.omp.json" | Invoke-Expression
# }

Show-Success "Dotfiles Profile Loaded."
