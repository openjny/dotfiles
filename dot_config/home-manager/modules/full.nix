{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # GitHub
    gh

    # Azure
    azure-cli
    # azd: install via `curl -fsSL https://aka.ms/install-azd.sh | bash`

    # Cloud & container tools
    kubectl
    helm
    opentofu  # terraform-compatible, open-source

    # Development
    prek
    shellcheck

    # Programming languages & runtimes
    nodejs
    pnpm
    bun
    python3
    go
    cargo

    # Documents
    pandoc

    # Networking
    nmap
    openssh
  ];
}
