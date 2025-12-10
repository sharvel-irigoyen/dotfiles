# ~/.my_alias.sh

# Contains aliases, functions, and configurations for Bash/Zsh

# ==============================================================================
# 0. UX/UI & Helpers
# ==============================================================================

# ANSI Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Helper Functions
function log_success() { echo -e "${GREEN}✅ $1${NC}"; }
function log_error() { echo -e "${RED}❌ $1${NC}"; }
function log_info() { echo -e "${CYAN}ℹ️  $1${NC}"; }
function log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }

# Check command execution
function check_status() {
    if [ $? -eq 0 ]; then
        log_success "$1"
    else
        log_error "$2"
        return 1
    fi
}

# ==============================================================================
# 1. System & Environment
# ==============================================================================

# History Settings
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

# Colored ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# LS Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Config Aliases
alias r="source ~/.bashrc && log_success 'Bashrc reloaded!'"
alias config="code ~/.bashrc"

# Path Configs
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
export PATH=$PATH:/home/sharvel/.local/bin

if command -v oh-my-posh &> /dev/null; then
    eval "$(oh-my-posh init bash --config $HOME/dotfiles/themes/easy-term.omp.json)"
fi

# ==============================================================================
# 2. Git Aliases
# ==============================================================================

alias pull="log_info 'Pulling...'; git pull origin master"
alias push="log_info 'Pushing...'; git push origin master"
alias master="log_info 'Switching to master...'; git checkout master"
alias lsbranch="git branch"
alias gst="git status"
alias gl="git log"

function commit() {
    if [ -z "$1" ]; then log_error "Message required"; return 1; fi
    git add . && git commit -am "$1"
    check_status "Committed changes." "Commit failed."
}

function branch() {
    if [ -z "$1" ]; then log_error "Branch name required"; return 1; fi
    git checkout "$1"
    check_status "Switched to $1" "Failed to switch."
}

function cbranch() {
    if [ -z "$1" ]; then log_error "Branch name required"; return 1; fi
    git checkout -b "$1"
    check_status "Created and switched to $1" "Failed to create branch."
}

function dbranch() {
    if [ -z "$1" ]; then log_error "Branch name required"; return 1; fi
    git branch -d "$1"
    check_status "Deleted branch $1" "Failed to delete branch."
}

# ==============================================================================
# 3. Laravel / PHP
# ==============================================================================

alias serve="log_info 'Starting Laravel Server...'; php artisan serve --host=localhost --port=8000"
alias rl="php artisan route:list"
alias opt="log_info 'Clearing Caches...'; php artisan optimize:clear"
alias migrate="log_info 'Migrating...'; php artisan migrate"
alias fresh="log_warning 'Wiping DB & Migrating...'; php artisan migrate:fresh"
alias seed="log_info 'Seeding...'; php artisan db:seed"
alias sl="php artisan schedule:list"
alias sw="php artisan schedule:work"

# NPM Wrappers
alias watch="log_info 'NPM Watch...'; npm run watch"
alias dev="log_info 'NPM Dev...'; npm run dev"
function prod() {
    log_info "Building production..."
    npm run build
    check_status "Build complete." "Build failed."
}

function lrv() {
    if [ -z "$1" ]; then log_error "Project name required"; return 1; fi
    log_info "Creating Laravel Project '$1'..."
    composer create-project laravel/laravel "$1" && cd "$1" && php artisan storage:link
    check_status "Project $1 created!" "Failed to create project."
}

function mm() { php artisan make:model "$1" -m; }
function mmf() { php artisan make:model "$1" -mf; }
function m() { php artisan make:migration "$1"; }

# Laravel Packages
alias livewire="composer require livewire/livewire"
alias jetstream="composer require laravel/jetstream"
alias fakerimages="composer require --dev smknstd/fakerphp-picsum-images"

# Composer Install Function
composeri() {
    log_info "Installing Composer..."
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    # Verification omitted for brevity but recommended in full script
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
    sudo mv composer.phar /usr/local/bin/composer
    check_status "Composer installed." "Composer installation failed."
}

# ==============================================================================
# 4. Python / Uvicorn
# ==============================================================================

pyinit() {
    if ! command -v python3 &> /dev/null; then
        log_error "Python3 not found."
        return 1
    fi
    local py_version=$(python3 --version)
    log_info "Detected: $py_version"

    if ! python3 -c "import venv" &> /dev/null; then
        log_error "Module 'venv' missing. Try: sudo apt install python3-venv"
        return 1
    fi

    if [ ! -d "venv" ]; then
        log_info "Creating venv..."
        python3 -m venv venv
        if [ $? -ne 0 ]; then log_error "Failed to create venv."; return 1; fi
    else
        log_success "venv already exists."
    fi

    if [ -f "venv/bin/activate" ]; then
        source venv/bin/activate
        log_success "Environment activated!"
    else
        log_error "Activation script not found."
        return 1
    fi
}

uvistart() {
    local APP_FILE="app/main.py"
    local APP_MODULE="app.main:app"
    local PORT=8000
    local BACKGROUND=false

    for arg in "$@"; do
        if [[ "$arg" == "-d" ]] || [[ "$arg" == "--detach" ]] || [[ "$arg" == "bg" ]]; then
            BACKGROUND=true
        elif [[ "$arg" =~ ^[0-9]+$ ]]; then
            PORT="$arg"
        fi
    done

    if ! command -v uvicorn &> /dev/null; then
        log_error "'uvicorn' not found. Activate venv?"
        return 1
    fi

    if [ ! -f "$APP_FILE" ]; then
        log_error "File '$APP_FILE' not found."
        return 1
    fi

    if command -v lsof &> /dev/null; then
        local PID_OCUPADO=$(lsof -ti :$PORT)
        if [ ! -z "$PID_OCUPADO" ]; then
            log_warning "Port $PORT is used by PID $PID_OCUPADO."
            return 1
        fi
    fi

    if [ "$BACKGROUND" = true ]; then
        log_info "Starting Uvicorn in background (Port $PORT)..."
        nohup uvicorn "$APP_MODULE" --reload --port "$PORT" > uvicorn.log 2>&1 &
        local NEW_PID=$!
        log_success "Started with PID: $NEW_PID"
    else
        log_info "Starting Uvicorn (Port $PORT)..."
        uvicorn "$APP_MODULE" --reload --port "$PORT"
    fi
}

uvistop() {
    local PORT="${1:-8000}"
    local PID=$(lsof -ti :$PORT)
    if [ ! -z "$PID" ]; then
        kill -9 $PID
        log_success "Stopped Uvicorn on port $PORT (PID: $PID)."
    else
        log_info "No process found on port $PORT."
    fi
}

# ==============================================================================
# 5. Docker
# ==============================================================================

alias dockup="log_info 'Docker Up...'; docker-compose up -d --build"
alias dock="docker-compose run php"

# ==============================================================================
# 6. Flutter
# ==============================================================================

alias pubget="log_info 'Flutter Pub Get...'; flutter pub get"
alias frun="log_info 'Flutter Run (Chrome)...'; flutter run -d chrome"

# ==============================================================================
# 7. SSH Shortcuts
# ==============================================================================

function cpkey() {
    if [ -z "$1" ] || [ -z "$2" ]; then log_error "Usage: cpkey user host [port]"; return 1; fi
    ssh-copy-id -i ~/.ssh/id_rsa.pub -p "${3:-22}" "$1"@"$2"
}

function shserve() { ssh root@31.97.25.142; }
function isamserve() { ssh root@91.205.223.18 -p 50050; }
function lpserve() { ssh -tt root@159.223.142.139; }
function upcserve { ssh javier@20.106.172.238; }
function iaisamserve { ssh root@217.15.171.169; }
function vaserve() { ssh -tt root@172.13.38.11  -p 2211; }
function 28serve { ssh -tt deploy@143.244.185.161; }
function ingserve() { ssh -tt ingenioedu@ingenio.edu.pe -p 22; }
function cigoserve { ssh -tt root@143.198.167.8 -p 22; }
function cigoprod { ssh -tt root@10.8.110.111 -p 22022; }
function winprod { ssh -tt ubuntu@10.0.1.230; }
function windev { ssh -tt ubuntu@10.0.1.112; }
function agenteprod { ssh -tt root@192.241.175.109; }

# ==============================================================================
# 8. Utils / Misc
# ==============================================================================

function cwebpr() {
    shopt -s globstar
    log_info "Converting images to WebP..."
    for file in **/*; do
        if [ ! -d "$file" ]; then
            filename=$(basename -- "$file")
            extension="${filename##*.}"
            if [ "$extension" != "webp" ] && ! test -f "${file%.*}.webp"; then
                cwebp -q 80 "$(pwd)/${file}" -o "$(pwd)/${file%.*}.webp"
                echo "Converted: $filename"
            fi
        fi
    done
    log_success "Conversion finished."
}

# Add Laravel completion if available
# _sf_laravel function omitted for brevity but can be re-added if widely used

function ag() {
    log_info "Opening with Antigravity..."
    antigravity .
    check_status "Opened." "Failed."
}

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

log_success "Dotfiles (Refactored) Loaded!"
