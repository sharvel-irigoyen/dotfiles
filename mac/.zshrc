# .zshrc for Mac


# Source common aliases
if [ -f "$HOME/dotfiles/common/.my_alias.sh" ]; then
    source "$HOME/dotfiles/common/.my_alias.sh"
fi

# Enable colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Basic prompt if oh-my-posh is not present
if ! command -v oh-my-posh &> /dev/null; then
    PROMPT='%F{cyan}%n@%m%f:%F{blue}%~%f$ '
fi
