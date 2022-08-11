# .zshrc

export ZSH=$DOTFILES/zsh
export DOTFILES_DIR="$HOME/$DOTFILES"

path=(
    "$HOME/$DOTFILES/bin"
    "$HOME/bin"
    $path
)

# -------------------------------------
# terminal color
# -------------------------------------

# if [ -z "$TMUX" ]; then
#     export TERM=xterm-256color-italic
# else
#     export TERM=tmux-256color
# fi

if tput -T xterm-256color longname >/dev/null; then
    export TERM=xterm-256color  # xterm-256color specific configuration
fi

# LS_COLORS
if [ -e ~/.dir_colors ]; then
    eval $(dircolors ~/.dir_colors)
elif [ -e $DOTFILES_DIR/.dir_colors ]; then
    eval $(dircolors $DOTFILES_DIR/.dir_colors)
fi


# -------------------------------------
# general
# -------------------------------------

setopt aliases                  # use extended alias
bindkey -v                      # use vim like style 
# setopt correct                # correct typo implicitly
setopt rm_star_silent           # confirm before executing "rm *"
setopt brace_ccl                # enable brace expansion (e.g. file{1-10})
setopt promptcr                 # add \n when missing it in the last line


# -------------------------------------
# completion
# -------------------------------------

# initialize autocomplete
if type brew &>/dev/null; then
    ZSH_COMPLETIONS="$(brew --prefix)/share/zsh-completions"
    [ -e $ZSH_COMPLETIONS ] && FPATH="$ZSH_COMPLETIONS:$FPATH"

    ZSH_AUTOSUGGESTIONS=$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    [ -e $ZSH_AUTOSUGGESTIONS ] && source $ZSH_AUTOSUGGESTIONS

    ZSH_SYNTAX_HIGHLIGHTING=$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    [ -e $ZSH_SYNTAX_HIGHLIGHTING ] && source $ZSH_SYNTAX_HIGHLIGHTING
fi

# enable compinit
autoload -U compinit add-zsh-hook
compinit

# basic settings
setopt auto_list                # show list
setopt auto_menu                # Tab to select
setopt list_packed              # simplify list
setopt list_types               # show file type
setopt magic_equal_subst        # keep completing after equal (e.g. --prefix=/usr)
setopt auto_param_keys          # remove trailing spaces after completion if needed
setopt auto_param_slash         # add `/` to the end of direcotryn 
setopt mark_dirs                # add `/` to the end of direcotry 
setopt auto_remove_slash        # remove `/` of the directory when inserting space after it
setopt extended_glob            # use glob to specify filename
setopt complete_aliases         # 
setopt hist_expand              # history expansion
setopt nolistbeep               # no beep sound

# Shift-Tab to move in reverse order
bindkey "^[[Z" reverse-menu-complete

# highlight current selection
zstyle ':completion:*:default' menu select=2
# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending
# default to file completion
zstyle ':completion:*' completer _expand _complete _files _correct _approximate
# use LS_COLORS to colorize file types
zstyle ':completion:*' list-colors "${LS_COLORS}"
# 
zstyle ':completion:*' list-separator '-->'
# 
# zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
# # 
# zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'

zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT

# 
zstyle ':completion:*:manuals' separate-sections true
# ignore the current direcotry when completing `../`
zstyle ':completion:*:cd:*' ignore-parents parent pwd


# -------------------------------------
# history
# -------------------------------------

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt bang_hist                    # the bang `!` to expand history
setopt extended_history             # write the history file in the ":start:elapsed;command" format.
setopt hist_reduce_blanks           # remove superfluous blanks before recording entry.
setopt share_history                # share history between all sessions.
setopt hist_ignore_all_dups         # delete old recorded entry if new entry is a duplicate.

# UP/DOWN to search history, based on the text input in command line.
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end


# -------------------------------------
# direcotry traversal
# -------------------------------------

DIRSTACKSIZE=100

setopt auto_cd                      # change dir without "cd"
setopt auto_pushd                   # "cd -<tab>" to list up visited directories
setopt pushd_ignore_dups            # ignore duplicated direcotry in pushd


# -------------------------------------
# job control
# -------------------------------------

# display how long all tasks over 10 seconds take
export REPORTTIME=10
export KEYTIMEOUT=1              # 10ms delay for key sequences

setopt no_bg_nice
setopt no_hup                    # don't kill background jobs when the shell exits
setopt no_list_beep
setopt local_options
setopt local_traps


# -------------------------------------
# other setup
# -------------------------------------

# load functions
if [ -d ~/.zsh/functions ]; then
    for func in ~/.zsh/functions/*(:t); autoload -U $func
fi

# source other zsh settings
if [ -d $HOME/.zsh ]; then
    for zsh_file in $HOME/.zsh/*.zsh; source "$zsh_file"
fi

# source local zshrc
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
