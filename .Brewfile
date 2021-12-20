if OS.mac?
    # taps
    tap "homebrew/cask"
    tap "homebrew/cask-fonts"

    brew "noti" # utility to display notifications from scripts
    brew "trash" # rm, but put in the trash rather than completely delete

    # Applications
    cask "kitty" # a better terminal emulator
    cask "imageoptim" # a tool to optimize images

    # Fonts
    cask "font-fira-code"
    cask "font-jetbrains-mono"
    cask "font-cascadia-mono"
    cask "font-3270-nerd-font"
elsif OS.linux?
    brew "xclip" # access to clipboard (similar to pbcopy/pbpaste)
end

tap "homebrew/bundle"
tap "homebrew/core"

# packages
brew "fzf" # Fuzzy file searcher, used in scripts and in vim
brew "git" # Git version control (latest version)
brew "grep" # grep (latest)
brew "jq" # work with JSON files in shell scripts
brew "neovim" # A better vim
brew "python" # python (latst)
brew "stow" # For symoblic file management 
brew "tmux" # terminal multiplexer
brew "tree" # pretty-print directory contents
brew "wget" # internet file retriever
brew "z" # switch between most used directories
brew "zsh" # zsh (latest)
brew "zsh-completions" # zsh-users/zsh-completions