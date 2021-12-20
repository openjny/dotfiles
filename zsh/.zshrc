export ZSH=$DOTFILES/zsh

# functions
if [[ -d ~/.zsh/functions ]]; then
    for func in ~/.zsh/functions/*(:t); autoload -U $func
fi

# extra path
prepend_path "$HOME/$DOTFILES/bin"
prepend_path $HOME/bin

# terminal settings
# if [ -z "$TMUX" ]; then
#     export TERM=xterm-256color-italic
# else
#     export TERM=tmux-256color
# fi
if tput -T xterm-256color longname >/dev/null; then
    export TERM=xterm-256color  # xterm-256color specific configuration
fi

# completion
# ----------

# initialize autocomplete

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    ZSH_AUTOSUGGESTIONS=$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    [ -e $ZSH_AUTOSUGGESTIONS ] && source $ZSH_AUTOSUGGESTIONS

    ZSH_SYNTAX_HIGHLIGHTING=$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    [ -e $ZSH_SYNTAX_HIGHLIGHTING ] && source $ZSH_SYNTAX_HIGHLIGHTING
fi

autoload -U compinit add-zsh-hook
compinit

# setopt correct # correct automatically
setopt auto_cd
setopt auto_list
setopt auto_menu
setopt auto_param_keys
setopt auto_param_slash
setopt brace_ccl
setopt complete_aliases
setopt extended_glob
setopt globdots
setopt hist_expand
setopt list_packed
setopt list_types 
setopt magic_equal_subst
setopt mark_dirs
setopt nolistbeep

# highlight current selection
zstyle ':completion:*:default' menu select=2

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending
# default to file completion
zstyle ':completion:*' completer _expand _complete _files _correct _approximate

zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true

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

# display how long all tasks over 10 seconds take
export REPORTTIME=10
export KEYTIMEOUT=1              # 10ms delay for key sequences

setopt no_bg_nice
setopt no_hup                    # don't kill background jobs when the shell exits
setopt no_list_beep
setopt local_options
setopt local_traps
setopt prompt_subst

# history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt extended_history          # write the history file in the ":start:elapsed;command" format.
setopt hist_reduce_blanks        # remove superfluous blanks before recording entry.
setopt share_history             # share history between all sessions.
setopt hist_ignore_all_dups      # delete old recorded entry if new entry is a duplicate.



########################################################
# Setup
########################################################

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

# If a local zshrc exists, source it
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local