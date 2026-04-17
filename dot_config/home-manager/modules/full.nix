{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # GitHub
    gh

    # Azure
    azure-cli
    azd

    # Cloud & container tools
    kubectl
    kubernetes-helm
    terraform

    # Development
    nodejs
    pnpm
    python3
    go

    # Documents
    pandoc

    # Networking
    nmap
    openssh
  ];
}
