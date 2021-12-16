export ZSH=$DOTFILES/zsh

# functions
if [[ -d ~/.zsh/functions ]]; then
    for func in ~/.zsh/functions/*(:t); autoload -U $func
fi

# extra path
prepend_path $DOTFILES/bin
prepend_path $HOME/bin

# tmux
if [ -z "$TMUX" ]; then
    export TERM=xterm-256color-italic
else
    export TERM=tmux-256color
fi

# completion
# ----------

# initialize autocomplete
autoload -U compinit add-zsh-hook
compinit

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending
# default to file completion
zstyle ':completion:*' completer _expand _complete _files _correct _approximate

# dev
# ---

# define the code directory
export CODE_DIR=$HOME/dev
if [[ ! -d "$CODE_DIR" ]]; then
    mkdir "$CODE_DIR"
fi

# Setopt
# ------

autoload colors
colors

setopt auto_list                # 
setopt auto_param_slash         # 
setopt mark_dirs                #
setopt list_types               # 
setopt auto_menu                # Tab to complete menue
setopt auto_param_keys
setopt magic_equal_subst
setopt extended_glob
setopt globdots
setopt brace_ccl

# display how long all tasks over 10 seconds take
export REPORTTIME=10
export KEYTIMEOUT=1              # 10ms delay for key sequences

setopt NO_BG_NICE
setopt NO_HUP                    # don't kill background jobs when the shell exits
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS
setopt LOCAL_TRAPS
setopt PROMPT_SUBST

# history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY          # write the history file in the ":start:elapsed;command" format.
setopt HIST_REDUCE_BLANKS        # remove superfluous blanks before recording entry.
setopt SHARE_HISTORY             # share history between all sessions.
setopt HIST_IGNORE_ALL_DUPS      # delete old recorded entry if new entry is a duplicate.

setopt COMPLETE_ALIASES


########################################################
# Setup
########################################################

# If a local zshrc exists, source it
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# fzf config
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# add color to man pages
export MANROFFOPT='-c'
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2)
export LESS_TERMCAP_md=$(tput bold; tput setaf 6)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7)
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)

# source z.sh if it exists
zpath="$(brew --prefix)/etc/profile.d/z.sh"
if [ -f "$zpath" ]; then
    source "$zpath"
fi

source "$HOME/.zsh/plugins.zsh"
source "$HOME/.zsh/prompt.zsh"
source "$HOME/.zsh/alias.zsh"
source "$HOME/.zsh/keybind.zsh"
source "$HOME/.zsh/utils.zsh"
