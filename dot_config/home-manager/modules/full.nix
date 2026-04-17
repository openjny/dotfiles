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
    python3
    go

    # Networking
    nmap
    openssh
  ];
}
