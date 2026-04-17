{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Keyboard remapping
    xremap-gnome  # or xremap-wlroots depending on DE

    # Fonts
    nerd-fonts.meslo-lg
    nerd-fonts.fira-code
    noto-fonts-cjk-sans
    source-han-code-jp
    source-code-pro
    ubuntu-classic
  ];
}
