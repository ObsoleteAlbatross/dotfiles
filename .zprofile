export PATH="$PATH:$(du "$HOME/.local/bin/" | cut -f2 | paste -sd ':')"
export PATH="$PATH:$(du "$HOME/src/idea-IC-202.7660.26/bin" | cut -f2 | paste -sd ':')"
export XCURSOR_PATH="$XCURSOR_PATH:$HOME/.local/share/icons"

# Default programs:
export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="firefox"
export READER="zathura"

# ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/inputrc"
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export PASSWORD_STORE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/password-store"
export HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/shell_history"
export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc-2.0"
export XAUTHORITY="$XDG_CONFIG_HOME/Xauthority"
export STACK_ROOT="$XDG_DATA_HOME/stack"

export _JAVA_AWT_WM_NONREPARENTING=1	# Java bug fix
