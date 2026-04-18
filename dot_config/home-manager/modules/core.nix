{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Shell essentials
    zsh
    tmux
    sheldon
    neovim

    # Search & navigation
    fzf
    ripgrep
    fd
    bat
    eza
    zoxide

    # Data processing
    jq
    yq-go

    # Git
    git
    delta  # git-delta for better diffs

    # System tools
    curl
    wget
    htop
    tree
    unzip
  ];

  # Starship prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = false;  # init via sheldon (chezmoi manages .zshrc)
  };

  # fzf integration
  programs.fzf = {
    enable = true;
    enableZshIntegration = false;  # init via sheldon
    defaultCommand = "rg --files --hidden --follow --glob '!.git/*'";
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
    fileWidgetCommand = "rg --files --hidden --follow --glob '!.git/*'";
    fileWidgetOptions = [ "--preview 'bat --color=always --style=header,grid --line-range :100 {}'" ];
  };

  # zoxide (z replacement)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = false;  # init via sheldon
  };

  # bat (cat replacement)
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      style = "header,grid";
    };
  };

  # direnv (per-directory env)
  programs.direnv = {
    enable = true;
    enableZshIntegration = false;  # init via sheldon
    nix-direnv.enable = true;
  };
}
