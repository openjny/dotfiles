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

# Editor
[[ -n "$(command -v nvim)" ]] && alias vim="nvim"

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# bat (cat replacement)
if command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
  alias catp='bat'
fi

# Starship + vivid theme switcher
starship-theme() {
  local themes_dir="${XDG_CONFIG_HOME:-$HOME/.config}/starship/themes"
  # Map starship theme name -> vivid theme name
  local -A vivid_map=(
    [catppuccin-mocha]=catppuccin-mocha
    [gruvbox-dark]=gruvbox-dark
    [tokyo-night]=tokyonight-night
    [dracula]=dracula
    [nord]=nord
    [rose-pine]=rose-pine
    [one-dark]=one-dark
  )
  if [[ -z "$1" ]]; then
    echo "Available themes:"
    ls "$themes_dir"/*.toml 2>/dev/null | xargs -I{} basename {} .toml
    echo "\nUsage: starship-theme <name>"
    return
  fi
  local theme="$themes_dir/$1.toml"
  if [[ ! -f "$theme" ]]; then
    echo "Theme not found: $1"
    return 1
  fi
  cp "$theme" "${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
  # Switch vivid LS_COLORS if available
  local vt="${vivid_map[$1]}"
  if [[ -n "$vt" ]] && command -v vivid &>/dev/null; then
    export THEME_VIVID="$vt"
    export LS_COLORS="$(vivid generate "$vt")"
  fi
  echo "Switched to: $1 (starship + LS_COLORS)"
}
_starship-theme() {
  local themes_dir="${XDG_CONFIG_HOME:-$HOME/.config}/starship/themes"
  compadd -- ${${(f)"$(ls "$themes_dir"/*.toml 2>/dev/null)"}:t:r}
}
compdef _starship-theme starship-theme

# Helpers
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias df='df -h'
alias du='du -h -c'
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'

# Git shortcuts
alias gs='git status -sb'
alias glog='git log --oneline --graph --decorate -20'
alias gd='git diff'
alias gds='git diff --staged'

# tmux
alias ta='tmux attach'
alias tls='tmux ls'
alias tat='tmux attach -t'
alias tns='tmux new-session -s'

# Utility
alias lpath='echo $PATH | tr ":" "\n"'
alias ip='ip -color=auto'
