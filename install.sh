#!/usr/bin/env bash
# Bootstrap dotfiles on a fresh machine
# Usage: curl -fsSL https://raw.githubusercontent.com/openjny/dotfiles/main/install.sh | bash
#   or:  ./install.sh [--profile minimal|full|desktop]

set -euo pipefail

REPO="openjny/dotfiles"
PROFILE="${1:-}"

info()  { printf '\033[1;34m[info]\033[0m %s\n' "$*"; }
error() { printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2; }

# -----------------------------------------------------------
# Step 1: Install Nix (if not present)
# -----------------------------------------------------------
if ! command -v nix &>/dev/null; then
  info "Installing Nix..."
  curl -L https://nixos.org/nix/install | sh -s -- --daemon --yes
  # Source for current session
  if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
  fi
else
  info "Nix already installed"
fi

# Enable flakes
mkdir -p ~/.config/nix
grep -q 'experimental-features' ~/.config/nix/nix.conf 2>/dev/null || \
  echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf

# -----------------------------------------------------------
# Step 2: Install zsh via Nix (if no zsh available)
# -----------------------------------------------------------
if ! command -v zsh &>/dev/null; then
  info "Installing zsh via Nix..."
  nix profile install "nixpkgs#zsh"
fi

# -----------------------------------------------------------
# Step 3: Set login shell to zsh
# -----------------------------------------------------------
ZSH_PATH="$(command -v zsh)"
CURRENT_SHELL=$(getent passwd "$(whoami)" | cut -d: -f7)

if [ "$CURRENT_SHELL" != "$ZSH_PATH" ]; then
  info "Setting login shell to $ZSH_PATH"
  # Must be in /etc/shells for chsh to accept it
  if ! grep -qxF "$ZSH_PATH" /etc/shells 2>/dev/null; then
    info "Adding $ZSH_PATH to /etc/shells (requires sudo)"
    echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
  fi
  # chsh may prompt for password
  sudo chsh -s "$ZSH_PATH" "$(whoami)"
fi

# -----------------------------------------------------------
# Step 4: Install chezmoi (if not present)
# -----------------------------------------------------------
if ! command -v chezmoi &>/dev/null; then
  info "Installing chezmoi..."
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
  export PATH="$HOME/.local/bin:$PATH"
fi

# -----------------------------------------------------------
# Step 5: Initialize and apply dotfiles
# -----------------------------------------------------------
info "Initializing dotfiles..."
if [ -n "$PROFILE" ]; then
  info "Profile: $PROFILE (non-interactive prompts not supported, will ask)"
fi
chezmoi init --apply "$REPO" --exclude=scripts

# -----------------------------------------------------------
# Step 6: Install packages via home-manager
# -----------------------------------------------------------
info "Installing packages via home-manager..."
nix run home-manager/master -- switch --flake "$HOME/.config/home-manager#default"

# -----------------------------------------------------------
# Done
# -----------------------------------------------------------
info "Dotfiles installed successfully!"
info ""
info "Next steps:"
info "  1. Open a new terminal (or run: exec zsh)"
info "  2. Verify: sheldon --version && starship --version"
info ""
info "Optional:"
info "  - azd:  curl -fsSL https://aka.ms/install-azd.sh | bash -s -- --install-folder ~/.local/bin --symlink-folder ~/.local/bin"
info "  - prek: nix shell nixpkgs#cargo nixpkgs#rustc -c cargo install prek"
