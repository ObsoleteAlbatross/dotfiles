export FPATH=$FPATH:$HOME/.config/zsh/plugins:$HOME/.config/zsh/plugins/zsh-completions/src

export PF_INFO="ascii title os kernel wm pkgs editor shell"
pfetch

autoload -U colors && colors
stty stop undef

# command history
HISTFILE=~/.cache/shell_history
HISTISZE=10000
SAVEHIST=10000

unsetopt beep
autoload -U compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=*' 'l:|=* r:|=*'
zstyle ':completion:*' gain privileges 1
zmodload zsh/complist
compinit
_comp_options+=(globdots)

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

source "$HOME/.config/aliasrc"
source "$HOME/.config/zsh/plugins/fsh/fast-syntax-highlighting.plugin.zsh"

PS1=" > "

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow'

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
