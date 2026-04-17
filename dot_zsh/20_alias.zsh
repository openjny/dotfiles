# 20_alias.zsh — Aliases

# Reload zsh config
alias reload!='exec zsh'

# Modern replacements (from Nix)
if command -v eza &>/dev/null; then
  alias ls='eza'
  alias l='eza -lah'
  alias la='eza -a'
  alias ll='eza -lh'
  alias lla='eza -lah'
  alias tree='eza --tree'
else
  if ls --color &>/dev/null 2>&1; then
    alias ls='ls --color=auto'
  fi
  alias l='ls -lah'
  alias la='ls -AF'
  alias ll='ls -lFh'
  alias lla='ls -lAFh'
fi

# Use nvim
[[ -n "$(command -v nvim)" ]] && alias vim="nvim"

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Helpers
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h -c'

# Git shortcuts
alias gs='git status -sb'
alias glog='git log --oneline --graph --decorate -20'

# tmux
alias ta='tmux attach'
alias tls='tmux ls'
alias tat='tmux attach -t'
alias tns='tmux new-session -s'

# PATH display
alias lpath='echo $PATH | tr ":" "\n"'

# man page colors
export MANROFFOPT='-c'
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2)
export LESS_TERMCAP_md=$(tput bold; tput setaf 6)
export LESS_TERMCAP_me=$(tput sgr0)
