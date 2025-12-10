    # ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH=$PATH:/home/sharvel/.local/bin
eval "$(oh-my-posh init bash  --config /mnt/c/Users/sharv/easy-term.omp.json)"

phpsw() {
    sudo update-alternatives --config php
}

alias r="source ~/.bashrc"
alias config="code ~/.bashrc"
alias pull="git pull origin master"
alias push="git push origin master"
alias master="git checkout master"
alias lsbranch="git branch"
alias gst="git status"
alias gl="git log"
alias serve="php artisan serve --host=localhost --port=8000"
alias rl="php artisan route:list"
alias watch="npm run watch"
alias prod="npm run build"
alias dev="npm run dev"

alias dockup="docker-compose up -d --build"
alias dock="docker-compose run php"

alias phpi="sudo add-apt-repository ppa:ondrej/php"
alias laraveli="composer global require laravel/installer"
alias laravelinit="cp .env.example .env && composer install && php artisan key:generate && php artisan storage:link && php artisan migrate && php artisan db:seed && npm install && npm run dev"

function commit() { git add . && git commit -am "$1"; }
function branch() { git checkout "$1"; }
function cbranch() { git checkout -b "$1"; }
function dbranch() { git branch -d "$1"; }
#crear proyecto de laravel
function lrv() { composer create-project laravel/laravel "$1" && cd "$1" && php artisan storage:link; }
alias opt="php artisan optimize:clear"
#migraciones
alias migrate="php artisan migrate"
alias fresh="php artisan migrate:fresh"
alias seed="php artisan db:seed"
alias sl="php artisan schedule:list"
alias sw="php artisan schedule:work"
alias cron="crontab -e"
alias crons="echo '* * * * * cd /var/www/proyect && php artisan schedule:run >> /dev/null 2>&1'"

pyinit() {
    # 1. Verificar si Python3 está instalado
    if ! command -v python3 &> /dev/null; then
        echo "❌ ERROR CRÍTICO: Python3 no está instalado o no se encuentra en el PATH."
        return 1
    fi

    # 2. Verificar versión (Opcional: muestra la versión actual)
    local py_version=$(python3 --version)
    echo "ℹ️  Detectado: $py_version"

    # 3. Verificar si el módulo 'venv' está disponible (común en Ubuntu/Debian)
    if ! python3 -c "import venv" &> /dev/null; then
        echo "❌ ERROR: El módulo 'venv' no está instalado."
        echo "💡 Intenta ejecutar: sudo apt install python3-venv (en Linux)"
        return 1
    fi

    # 4. Intentar crear el entorno si no existe
    if [ ! -d "venv" ]; then
        echo "⚙️  Carpeta 'venv' no encontrada. Creando entorno virtual..."
        python3 -m venv venv

        # Verificar si el comando anterior falló (ej. permisos, disco lleno)
        if [ $? -ne 0 ]; then
            echo "❌ ERROR: Falló la creación del entorno. Revisa permisos o espacio en disco."
            return 1
        fi
    else
        echo "✅ La carpeta 'venv' ya existe. Omitiendo creación."
    fi

    # 5. Activar el entorno
    if [ -f "venv/bin/activate" ]; then
        source venv/bin/activate
        echo "🚀 ¡Entorno activado exitosamente!"
    else
        echo "❌ ERROR: No se encontró el archivo de activación (venv/bin/activate)."
        echo "   Es posible que la creación haya fallado silenciosamente."
        return 1
    fi
}

uvistart() {
    # 1. Configuración de variables y argumentos
    local APP_FILE="app/main.py"
    local APP_MODULE="app.main:app"
    local PORT=8000
    local BACKGROUND=false

    # Recorrer argumentos para detectar puerto y modo background (-d o bg)
    for arg in "$@"; do
        if [[ "$arg" == "-d" ]] || [[ "$arg" == "--detach" ]] || [[ "$arg" == "bg" ]]; then
            BACKGROUND=true
        elif [[ "$arg" =~ ^[0-9]+$ ]]; then
            PORT="$arg"
        fi
    done

    # 2. Verificar si Uvicorn está instalado/accesible
    if ! command -v uvicorn &> /dev/null; then
        echo "❌ ERROR: 'uvicorn' no se encuentra."
        echo "   ¿Activaste el entorno virtual? (Usa 'pyinit' primero)"
        return 1
    fi

    # 3. Verificar si el archivo de la app existe
    if [ ! -f "$APP_FILE" ]; then
        echo "❌ ERROR: No encuentro el archivo '$APP_FILE'."
        return 1
    fi

    # 4. Verificar si el puerto está ocupado
    if command -v lsof &> /dev/null; then
        local PID_OCUPADO=$(lsof -ti :$PORT)
        if [ ! -z "$PID_OCUPADO" ]; then
            echo "⚠️  ALERTA: El puerto $PORT ya está en uso por PID: $PID_OCUPADO."
            local NOMBRE=$(ps -p $PID_OCUPADO -o comm=)
            echo "   Proceso: $NOMBRE"
            echo "   Para matar: kill -9 $PID_OCUPADO"
            return 1
        fi
    fi

    # 5. Ejecutar Uvicorn según el modo
    if [ "$BACKGROUND" = true ]; then
        echo "🚀 Iniciando Uvicorn en SEGUNDO PLANO (Puerto $PORT)..."
        echo "📄 La salida se está guardando en 'uvicorn.log'"

        # nohup permite que siga corriendo aunque cierres la terminal
        nohup uvicorn "$APP_MODULE" --reload --port "$PORT" > uvicorn.log 2>&1 &

        # $! obtiene el PID del último comando ejecutado en segundo plano
        local NEW_PID=$!
        echo "✅ Servidor corriendo con PID: $NEW_PID"
        echo "   Para detenerlo usa: kill $NEW_PID"
    else
        echo "🚀 Iniciando Uvicorn en puerto $PORT..."
        echo "   Modo reload: ACTIVO"
        echo "-------------------------------------"
        uvicorn "$APP_MODULE" --reload --port "$PORT"
    fi
}

uvistop() {
    local PORT="${1:-8000}"
    local PID=$(lsof -ti :$PORT)
    if [ ! -z "$PID" ]; then
        kill -9 $PID
        echo "🛑 Se ha detenido Uvicorn en el puerto $PORT (PID: $PID)."
        # Opcional: Borrar el log
        # rm uvicorn.log
    else
        echo "ℹ️  No se encontró ningún proceso en el puerto $PORT."
    fi
}

function mm() { php artisan make:model "$1" -m; }
function mmf() { php artisan make:model "$1" -mf; }
function m() { php artisan make:migration "$1"; }
#paquetes de laravel
##liveiwre
alias livewire="composer require livewire/livewire"

##jetstream
alias jetstream="composer require laravel/jetstream"

##fakerimages
alias fakerimages="composer require --dev smknstd/fakerphp-picsum-images"

# Flutter flutter pub get
alias pubget="flutter pub get"
alias pubupgrade="flutter pub upgrade"
alias fweb="flutter config --enable-web"
alias frun="flutter run -d chrome"
# flutter run -d chrome --web-port 5000
alias fbuild="flutter build web --release --web-renderer html --csp"

function wtl() { sudo mv /mnt/c/Users/sharv/Downloads/"$1" /home/sharvel/webs; }
function ltw() { sudo mv /home/sharvel/webs/"$1" /mnt/c/Users/sharv/Downloads/"$2"; }
function cpkey() { ssh-copy-id -i ~/.ssh/id_rsa.pub  -p "$3" "$1"@"$2"; }
function shserve() { ssh root@31.97.25.142; }
function isamserve() { ssh root@91.205.223.18 -p 50050; }
function lpserve() { ssh -tt root@159.223.142.139; }
function upcserve() { ssh javier@20.106.172.238; }
function upcftp() { sftp -inv ubuntu@44.212.77.236; }

function ingftp() { sftp -inv ubuntu@44.212.77.236; }

function iaisamserve() { ssh root@217.15.171.169; }
function vaserve() { ssh -tt root@172.13.38.11  -p 2211; }
function 28serve() { ssh -tt deploy@143.244.185.161; }
function ingserve() { ssh -tt ingenioedu@ingenio.edu.pe -p 22; }

function cigoserve() { ssh -tt root@143.198.167.8 -p 22; }

function cigoprod() { ssh -tt root@10.8.110.111 -p 22022; }

function winprod() { ssh -tt ubuntu@10.0.1.230; }
function windev() { ssh -tt ubuntu@10.0.1.112; }
function agenteprod() { ssh -tt root@192.241.175.109; }
function cwebpr() {
    shopt -s globstar;
    for file in **/*;
    do
        filename=$(basename -- "$file")
        extension="${filename##*.}"
        if [ ! -d "$file" ];
        then
            if [ "$extension" != "webp" ] && ! test -f "${file%.*}.webp";
            then
                cwebp.exe -q 80 $(pwd)/${file} -o $(pwd)/${file%.*}.webp;
            fi
        fi
    done;
}

# Función para instalar Composer
composeri() {
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
    sudo mv composer.phar /usr/local/bin/composer
    echo "Composer instalado correctamente"
}


phpmod() {
    local php_version=$1

    if [ -z "$php_version" ]; then
        echo "Por favor, proporciona la versión de PHP. Ejemplo: install_php_extensions 8.2"
        return 1
    fi

    echo "Instalando extensiones para PHP $php_version..."

    sudo apt-get install php$php_version-xml php$php_version-curl php$php_version-zip php$php_version-mbstring php$php_version-gd php$php_version-mysql php$php_version-bcmath php$php_version-fpm php$php_version-soap php$php_version-intl -y
}

_sf_laravel() {
    # Use newline as only separator to allow space in completion values
    IFS=$'\n'
    local sf_cmd="${COMP_WORDS[0]}"

    # for an alias, get the real script behind it
    sf_cmd_type=$(type -t $sf_cmd)
    if [[ $sf_cmd_type == "alias" ]]; then
        sf_cmd=$(alias $sf_cmd | sed -E "s/alias $sf_cmd='(.*)'/\1/")
    elif [[ $sf_cmd_type == "file" ]]; then
        sf_cmd=$(type -p $sf_cmd)
    fi

    if [[ $sf_cmd_type != "function" && ! -x $sf_cmd ]]; then
        return 1
    fi

    local cur prev words cword
    _get_comp_words_by_ref -n := cur prev words cword

    local completecmd=("$sf_cmd" "_complete" "--no-interaction" "-sbash" "-c$cword" "-S4.5.1")
    for w in ${words[@]}; do
        w=$(printf -- '%b' "$w")
        # remove quotes from typed values
        quote="${w:0:1}"
        if [ "$quote" == \' ]; then
            w="${w%\'}"
            w="${w#\'}"
        elif [ "$quote" == \" ]; then
            w="${w%\"}"
            w="${w#\"}"
        fi
        # empty values are ignored
        if [ ! -z "$w" ]; then
            completecmd+=("-i$w")
        fi
    done

    local sfcomplete
    if sfcomplete=$(${completecmd[@]} 2>&1); then
        local quote suggestions
        quote=${cur:0:1}

        # Use single quotes by default if suggestions contains backslash (FQCN)
        if [ "$quote" == '' ] && [[ "$sfcomplete" =~ \\ ]]; then
            quote=\'
        fi

        if [ "$quote" == \' ]; then
            # single quotes: no additional escaping (does not accept ' in values)
            suggestions=$(for s in $sfcomplete; do printf $'%q%q%q\n' "$quote" "$s" "$quote"; done)
        elif [ "$quote" == \" ]; then
            # double quotes: double escaping for \ $ ` "
            suggestions=$(for s in $sfcomplete; do
                s=${s//\\/\\\\}
                s=${s//\$/\\\$}
                s=${s//\`/\\\`}
                s=${s//\"/\\\"}
                printf $'%q%q%q\n' "$quote" "$s" "$quote";
            done)
        else
            # no quotes: double escaping
            suggestions=$(for s in $sfcomplete; do printf $'%q\n' $(printf '%q' "$s"); done)
        fi
        COMPREPLY=($(IFS=$'\n' compgen -W "$suggestions" -- $(printf -- "%q" "$cur")))
        __ltrim_colon_completions "$cur"
    else
        if [[ "$sfcomplete" != *"Command \"_complete\" is not defined."* ]]; then
            >&2 echo
            >&2 echo $sfcomplete
        fi

        return 1
    fi
}
# export PATH="/home/sharvel/.config/herd-lite/bin:$PATH"
# export PHP_INI_SCAN_DIR="/home/sharvel/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
export PATH=/usr/bin:$PATH
export PATH="$HOME/.config/composer/vendor/bin:$PATH"


# Load Angular CLI autocompletion.
source <(ng completion script)

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export PATH="$HOME/flutter/bin:$PATH"
export ANDROID_SDK_ROOT="/mnt/c/Users/sharv/AppData/Local/Android/Sdk"
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export PATH="$HOME/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator:$PATH"
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export PATH="$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator:$PATH"
