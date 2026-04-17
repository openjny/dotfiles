# 11_history.zsh — History settings

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
[[ -d "${HISTFILE:h}" ]] || mkdir -p "${HISTFILE:h}"
HISTSIZE=100000
SAVEHIST=100000

setopt bang_hist              # ! for history expansion
setopt extended_history       # save timestamp and duration
setopt hist_reduce_blanks     # remove superfluous blanks
setopt share_history          # share between sessions
setopt hist_ignore_all_dups   # remove older duplicate
setopt hist_ignore_space      # ignore commands starting with space
setopt hist_verify            # show expanded command before executing
setopt hist_expire_dups_first # expire duplicates first when trimming
setopt hist_find_no_dups      # don't show dups when searching
setopt inc_append_history     # add commands immediately, not at shell exit
