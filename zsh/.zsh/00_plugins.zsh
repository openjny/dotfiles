### Added by Zinit's installer
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

# if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
#     print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
#     command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
#     command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
#         print -P "%F{33} %F{34}Installation successful.%f%b" || \
#         print -P "%F{160} The clone has failed.%f%b"
# fi

source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# 
zinit light zsh-users/zsh-completions

# Two regular plugins loaded without tracking.
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

# https://github.com/chitoku-k/fzf-zsh-completions
zinit light chitoku-k/fzf-zsh-completions

# https://github.com/jeffreytse/zsh-vi-mode
# zinit ice depth=1
# zinit light jeffreytse/zsh-vi-mode

# use fzf in completion menu
zinit light Aloxaf/fzf-tab

# git fuzzy
zinit ice as"program" pick"bin/git-fuzzy"
zinit light bigH/git-fuzzy

# python venv
zinit wait lucid for MichaelAquilina/zsh-autoswitch-virtualenv
