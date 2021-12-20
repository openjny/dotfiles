#!/usr/bin/env bash

DOTFILES="$(dirname $(readlink -f $0))"
COLOR_GRAY="\033[1;38;5;243m"
COLOR_BLUE="\033[1;34m"
COLOR_GREEN="\033[1;32m"
COLOR_RED="\033[1;31m"
COLOR_PURPLE="\033[1;35m"
COLOR_YELLOW="\033[1;33m"
COLOR_NONE="\033[0m"

title() {
    echo -e "\n${COLOR_PURPLE}$1${COLOR_NONE}"
    echo -e "${COLOR_GRAY}==============================${COLOR_NONE}\n"
}

error() {
    echo -e "${COLOR_RED}Error: ${COLOR_NONE}$1"
    exit 1
}

warning() {
    echo -e "${COLOR_YELLOW}Warning: ${COLOR_NONE}$1"
}

info() {
    echo -e "${COLOR_BLUE}Info: ${COLOR_NONE}$1"
}

success() {
    echo -e "${COLOR_GREEN}$1${COLOR_NONE}"
}

get_linkables() {
    find -H "$DOTFILES" -maxdepth 3 -name '*.symlink'
}

command_exists () {
    type "$1" &> /dev/null ;
}

load_homebrew() {
    if command_exists brew; then
        return
    fi

    if [ "$(uname)" == "Linux" ]; then
        test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
        test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
}

setup_symlinks() {
    title "Creating symlinks"

    load_homebrew
    if ! command_exists brew; then
        error "Homebrew doesn't exit. Run install.sh [homebrew] first."
    fi

    if ! command_exists stow; then
        error "Need stow to locate symlinks"
    fi

    [[ ! -d "$HOME/.config" ]] && mkdir -p $HOME/.config
    stow -v zsh nvim tmux
    
    info "Created symbolic links"
}

setup_git() {
    title "Setting up Git global config"

    defaultName=$(git config user.name)
    defaultEmail=$(git config user.email)
    defaultGithub=$(git config github.user)

    read -rp "Name [$defaultName] " name
    read -rp "Email [$defaultEmail] " email
    read -rp "Github username [$defaultGithub] " github

    git config --global user.name "${name:-$defaultName}"
    git config --global user.email "${email:-$defaultEmail}"
    git config --global github.user "${github:-$defaultGithub}"
    
    # pull rebase strategy
    # hint:   git config pull.rebase false  # merge (the default strategy)
    # hint:   git config pull.rebase true   # rebase
    # hint:   git config pull.ff only       # fast-forward only
    git config --global pull.rebase false

    # master -> main
    git config --global init.defaultBranch main

    if [[ "$(uname)" == "Darwin" ]]; then
        git config --global credential.helper "osxkeychain"
    else
        read -rn 1 -p "Save user and password to an unencrypted file to avoid writing? [y/N] " save
        if [[ $save =~ ^([Yy])$ ]]; then
            git config --global credential.helper "store"
        else
            git config --global credential.helper "cache --timeout 3600"
        fi
    fi
}

setup_homebrew() {
    title "Setting up Homebrew"

    load_homebrew
    if ! command_exists brew; then
        info "Homebrew not installed. Installing."
        # Run as a login shell (non-interactive) so that the script doesn't pause for user input
        # /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login
        
        load_homebrew
        
        # bashrc
        if [ "$(uname)" == "Linux" ]; then
            info "Setup for Homebrew on Linux."
            info "~/.bashrc << eval \$($(brew --prefix)/bin/brew shellenv)"
            echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> ~/.bashrc
        fi
    else
        info "Homebrew is already installed."
    fi
    
    # install brew dependencies from Brewfile
    info "Install packages from Brewfile"
    ln -sf "${DOTFILES}/.Brewfile" "$HOME/.Brewfile"
    brew bundle --global

    # install fzf
    echo -e
    info "Installing fzf optional feature"
    "$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
}

setup_shell() {
    title "Configuring shell"

    [[ -n "$(command -v brew)" ]] && zsh_path="$(brew --prefix)/bin/zsh" || zsh_path="$(which zsh)"
    if ! grep "$zsh_path" /etc/shells; then
        info "adding $zsh_path to /etc/shells"
        echo "$zsh_path" | sudo tee -a /etc/shells
    fi

    if [[ "$SHELL" != "$zsh_path" ]]; then
        chsh -s "$zsh_path"
        info "default shell changed to $zsh_path"
    fi
}

setup_terminfo() {
    title "Configuring terminfo"

    info "adding tmux.terminfo"
    tic -x "$DOTFILES/resources/tmux.terminfo"

    info "adding xterm-256color-italic.terminfo"
    tic -x "$DOTFILES/resources/xterm-256color-italic.terminfo"
}

setup_macos() {
    title "Configuring macOS"
    if [[ "$(uname)" == "Darwin" ]]; then
        for app in Safari Finder Dock Mail SystemUIServer; do killall "$app" >/dev/null 2>&1; done
        success "Your macOS has been setup!"
    else
        warning "macOS not detected. Skipping."
    fi
}

cd "$DOTFILES"

case "$1" in
    backup)
        backup
        ;;
    symlinks)
        setup_symlinks
        ;;
    git)
        setup_git
        ;;
    homebrew)
        setup_homebrew
        ;;
    shell)
        setup_shell
        ;;
    terminfo)
        setup_terminfo
        ;;
    macos)
        setup_macos
        ;;
    all)
        setup_homebrew
        setup_symlinks
        setup_terminfo
        setup_shell
        setup_git
        setup_macos
        ;;
    *)
        echo -e $"\nUsage: $(basename "$0") {backup|link|git|homebrew|shell|terminfo|macos|all}\n"
        exit 1
        ;;
esac

echo -e
success "Done."
