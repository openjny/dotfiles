#!/bin/bash
# Ensure the login shell is set to zsh
# This script is a fallback; install.sh handles this during bootstrap.
# Prefers Nix zsh, then system zsh. Skips silently if no zsh found.

set -euo pipefail

# Find zsh: prefer Nix, then common system paths
for candidate in "$HOME/.nix-profile/bin/zsh" /usr/bin/zsh /bin/zsh; do
  if [ -x "$candidate" ]; then
    ZSH_PATH="$candidate"
    break
  fi
done

if [ -z "${ZSH_PATH:-}" ]; then
  echo "No zsh found. Install zsh first (e.g., via install.sh or apt install zsh)."
  exit 0
fi

CURRENT_SHELL=$(getent passwd "$(whoami)" | cut -d: -f7)

if [ "$CURRENT_SHELL" = "$ZSH_PATH" ]; then
  exit 0
fi

echo "Changing login shell from $CURRENT_SHELL to $ZSH_PATH"

if ! grep -qxF "$ZSH_PATH" /etc/shells 2>/dev/null; then
  echo "$ZSH_PATH" | sudo tee -a /etc/shells
fi

chsh -s "$ZSH_PATH"
echo "Login shell changed to $ZSH_PATH"
