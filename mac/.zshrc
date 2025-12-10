# .zshrc for Mac


# Source common aliases
if [ -f "$HOME/dotfiles/common/.my_alias.sh" ]; then
    source "$HOME/dotfiles/common/.my_alias.sh"
fi

# Enable colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Oh-My-Posh
if command -v oh-my-posh &> /dev/null; then
    eval "$(oh-my-posh init zsh --config $HOME/dotfiles/themes/easy-term.omp.json)"
else
    PROMPT='%F{cyan}%n@%m%f:%F{blue}%~%f$ '
fi
