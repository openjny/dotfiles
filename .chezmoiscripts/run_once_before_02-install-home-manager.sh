#!/bin/bash
# Install home-manager standalone if not already installed

set -euo pipefail

# Source nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

if command -v home-manager &>/dev/null; then
  echo "home-manager is already installed"
  exit 0
fi

echo "Installing home-manager..."
nix run home-manager/master -- init --switch
echo "home-manager installed successfully"
