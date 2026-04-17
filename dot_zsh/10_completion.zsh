# 10_completion.zsh — Completion settings

autoload -U compinit
compinit

# Basic settings
setopt auto_list
setopt auto_menu
setopt list_packed
setopt list_types
setopt magic_equal_subst
setopt auto_param_keys
setopt auto_param_slash
setopt mark_dirs
setopt auto_remove_slash
setopt complete_aliases
setopt hist_expand
setopt nolistbeep

# Shift-Tab for reverse completion
bindkey "^[[Z" reverse-menu-complete

# Highlight current selection
zstyle ':completion:*:default' menu select=2

# Case-insensitive matching for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# Completer chain
zstyle ':completion:*' completer _expand _complete _files _correct _approximate

# Use LS_COLORS for file type colorization
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Description formatting
zstyle ':completion:*:descriptions' format '%F{yellow}completing %B%d%b%f'
zstyle ':completion:*:warnings' format '%F{red}No matches for: %F{yellow}%d%f'
zstyle ':completion:*:messages' format '%F{yellow}%d%f'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:manuals' separate-sections true

# Ignore parent directory when completing ../
zstyle ':completion:*:cd:*' ignore-parents parent pwd
