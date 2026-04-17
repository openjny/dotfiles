{ config, pkgs, ... }:

let
  # Read profile from chezmoi data (set via environment variable or default)
  profile = builtins.getEnv "DOTFILES_PROFILE";
  isMinimal = profile == "minimal";
  isFull = profile == "full" || profile == "desktop";
  isDesktop = profile == "desktop";
in {
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  imports = [
    ./modules/core.nix
  ] ++ (if isFull || isDesktop then [ ./modules/full.nix ] else [])
    ++ (if isDesktop then [ ./modules/desktop.nix ] else []);
}
