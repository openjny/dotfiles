#!/bin/bash
# Install Nix (multi-user) if not already installed
# {{ template "chezmoi_profile" . }}

set -euo pipefail

if command -v nix &>/dev/null; then
  echo "Nix is already installed"
  exit 0
fi

echo "Installing Nix..."
curl -L https://nixos.org/nix/install | sh -s -- --daemon --yes

# Source nix profile for current session
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

echo "Nix installed successfully"
