#!/bin/bash
# Apply home-manager configuration after chezmoi places config files

set -euo pipefail

# Source nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

if ! command -v home-manager &>/dev/null; then
  echo "home-manager not found, skipping"
  exit 0
fi

echo "Applying home-manager configuration..."
home-manager switch --flake ~/.config/home-manager
echo "home-manager applied successfully"
