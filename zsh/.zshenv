# .zshenv is sourced on all invocations of the shell, unless the -f option is set.
# It should contain commands to set the command search path, plus other important environment variables.
# .zshenv' should not contain commands that produce output or assume the shell is attached to a tty.

# Homebrew on Linux
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

export DOTFILES="$(dirname "$(dirname "$(readlink "${(%):-%N}")")")"
export CACHEDIR="$HOME/.local/share"
export VIM_TMP="$HOME/.vim-tmp"

[[ -d "$CACHEDIR" ]] || mkdir -p "$CACHEDIR"
[[ -d "$VIM_TMP" ]] || mkdir -p "$VIM_TMP"

[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local

fpath=(
    $HOME/.zsh/completion
    $HOME/.zsh/functions
    /usr/local/share/zsh/site-functions
    $fpath
)

typeset -aU path

export EDITOR='nvim'
export GIT_EDITOR='nvim'

# export LANG=ja_JP.UTF-8

# Cargo
if command -v cargo &>/dev/null; then
    CARGO_HOME="$HOME/.cargo"
    export PATH="$CARGO_HOME/bin:$PATH"
    source "$CARGO_HOME/env"
fi

# Golang
if command -v go &>/dev/null; then
    GOPATH=$(go env GOPATH)
    export PATH="$GOPATH/bin:$PATH"
fi

. "$HOME/.local/bin/env"
