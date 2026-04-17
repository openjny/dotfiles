{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Keyboard remapping
    xremap

    # Fonts
    nerd-fonts.meslo-lg
    nerd-fonts.fira-code
    noto-fonts-cjk-sans
    source-han-code-jp
  ];
}
