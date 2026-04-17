# 00_options.zsh — General zsh options

# Vi mode
bindkey -v
export KEYTIMEOUT=1

# General
setopt aliases
setopt rm_star_silent
setopt brace_ccl
setopt promptcr
setopt interactivecomments
setopt extended_glob

# Directory traversal
DIRSTACKSIZE=100
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups

# Job control
export REPORTTIME=10
setopt no_bg_nice
setopt no_hup
setopt no_list_beep
setopt local_options
setopt local_traps
