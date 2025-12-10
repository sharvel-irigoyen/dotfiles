# .bashrc for Linux/Bash


# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Source common aliases
if [ -f "$HOME/dotfiles/common/.my_alias.sh" ]; then
    source "$HOME/dotfiles/common/.my_alias.sh"
fi

# Basic prompt if oh-my-posh is not present
if ! command -v oh-my-posh &> /dev/null; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi
