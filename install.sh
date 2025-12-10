#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"
OS="$(uname -s)" # Detecta el Sistema Operativo (Linux o Darwin para Mac)

echo "🖥️  Detectando sistema: $OS"

# --- 0. Dependencias (Oh-My-Posh) ---
if ! command -v oh-my-posh &> /dev/null; then
    echo "⚠️  Oh-My-Posh no encontrado. Instalando..."
    if [[ "$OS" == "Darwin" ]]; then
        if command -v brew &> /dev/null; then
            brew install jandedobbeleer/oh-my-posh/oh-my-posh
        else
            echo "❌ Homebrew no encontrado. Instala OMP manualmente."
        fi
    else
        # Linux (Standard installer)
        # Requires sudo usually for writing to /usr/local/bin, or install locally
        echo "⬇️  Descargando instalador de Linux..."
        sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
        sudo chmod +x /usr/local/bin/oh-my-posh
    fi
    echo "✅ Oh-My-Posh instalado."
else
    echo "✅ Oh-My-Posh ya está instalado."
fi

# --- 1. Instalar lo COMÚN (Alias universales) ---
echo "🔗 Enlazando configuraciones comunes..."
ln -sf "$DOTFILES_DIR/common/.my_alias.sh" "$HOME/.my_alias.sh"

# --- 2. Lógica para BASH (Linux / WSL) ---
if [ "$SHELL" == "/bin/bash" ] || [ -f "/bin/bash" ]; then
    echo "🐚 Configurando Bash..."
    # Si quieres reemplazar el .bashrc completo:
    # ln -sf "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"

    # O si prefieres solo inyectar la carga (más seguro):
    if ! grep -q ".my_alias.sh" "$HOME/.bashrc"; then
        echo "source $HOME/.my_alias.sh" >> "$HOME/.bashrc"
    fi
fi

# --- 3. Lógica para ZSH (MacOS / Linux avanzado) ---
# MacOS usa Zsh por defecto ahora
if [[ "$OS" == "Darwin" ]] || [[ "$SHELL" == */zsh ]]; then
    echo "🍏 Configurando Zsh (Mac/Linux)..."

    # Enlazar .zshrc si tienes uno personalizado en tu repo
    if [ -f "$DOTFILES_DIR/zsh/.zshrc" ]; then
        ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
    fi

    # Asegurarnos de que Zsh también cargue tus alias comunes
    # Nota: Zsh también entiende la sintaxis de tus alias de Bash el 99% de las veces
    if [ -f "$HOME/.zshrc" ]; then
        if ! grep -q ".my_alias.sh" "$HOME/.zshrc"; then
             echo "source $HOME/.my_alias.sh" >> "$HOME/.zshrc"
        fi
    fi
fi

echo "✅ ¡Instalación finalizada!"
