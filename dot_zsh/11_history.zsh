# 11_history.zsh — History settings

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt bang_hist
setopt extended_history
setopt hist_reduce_blanks
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
