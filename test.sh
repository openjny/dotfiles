#!/bin/bash
# Test dotfiles across all profiles using Docker
# Usage: ./test.sh [profile]       # test all or single profile
#        REMOTE=1 ./test.sh        # test from GitHub (pushed state)
#        REBUILD=1 ./test.sh       # force Docker image rebuild

set -euo pipefail

IMAGE="dotfiles-test"
REPO="openjny/dotfiles"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Build test image if needed
if ! docker image inspect "$IMAGE" &>/dev/null || [[ "${REBUILD:-}" == "1" ]]; then
  echo "Building test image..."
  docker build -t "$IMAGE" "$SCRIPT_DIR"
fi

# Determine init method: local mount or remote clone
if [[ "${REMOTE:-}" == "1" ]]; then
  MOUNT_ARGS=""
  INIT_CMD="chezmoi init $REPO 2>&1"
  echo "Mode: REMOTE (testing pushed state from GitHub)"
else
  MOUNT_ARGS="-v $SCRIPT_DIR:/dotfiles-src:ro"
  INIT_CMD="chezmoi init --source /dotfiles-src 2>&1"
  echo "Mode: LOCAL (testing working directory)"
fi

test_profile() {
  local profile=$1
  local failed=0

  echo ""
  echo "=========================================="
  echo "  TEST: $profile"
  echo "=========================================="

  local output
  output=$(docker run --rm $MOUNT_ARGS "$IMAGE" bash -c "
    set -e
    mkdir -p ~/.config/chezmoi
    cat > ~/.config/chezmoi/chezmoi.toml <<EOF
[data]
  profile = \"$profile\"
  email = \"test@example.com\"
  name = \"testuser\"
EOF
    $INIT_CMD
    chezmoi apply --no-tty --exclude=scripts 2>&1
    chezmoi verify --exclude=scripts 2>&1

    # Common checks
    for f in .zshrc .zshenv .gitconfig .config/sheldon/plugins.toml .config/starship.toml .config/tmux/tmux.conf .config/nvim/init.vim .config/home-manager/home.nix .config/home-manager/modules/core.nix; do
      [ -f ~/\$f ] && echo \"OK \$f\" || echo \"FAIL \$f\"
    done

    # Template checks
    grep -q neovim ~/.config/home-manager/modules/core.nix && echo 'OK core.nix has neovim' || echo 'FAIL core.nix missing neovim'
    grep -q testuser ~/.gitconfig && echo 'OK gitconfig templated' || echo 'FAIL gitconfig not templated'

    # Profile-specific
    case $profile in
      minimal)
        [ ! -d ~/.config/xremap ] && echo 'OK no xremap' || echo 'FAIL xremap present'
        [ ! -f ~/.config/home-manager/modules/full.nix ] && echo 'OK no full.nix' || echo 'FAIL full.nix present'
        [ ! -f ~/.config/systemd/user/xremap.service ] && echo 'OK no xremap.service' || echo 'FAIL xremap.service present'
        ;;
      full)
        [ ! -d ~/.config/xremap ] && echo 'OK no xremap' || echo 'FAIL xremap present'
        [ -f ~/.config/home-manager/modules/full.nix ] && echo 'OK full.nix' || echo 'FAIL no full.nix'
        grep -q pnpm ~/.config/home-manager/modules/full.nix && echo 'OK full.nix has pnpm' || echo 'FAIL full.nix no pnpm'
        [ ! -f ~/.config/home-manager/modules/desktop.nix ] && echo 'OK no desktop.nix' || echo 'FAIL desktop.nix present'
        grep -q './modules/full.nix' ~/.config/home-manager/home.nix && echo 'OK home.nix imports full' || echo 'FAIL home.nix no full import'
        ;;
      desktop)
        [ -f ~/.config/xremap/config.yml ] && echo 'OK xremap' || echo 'FAIL no xremap'
        [ -f ~/.config/home-manager/modules/full.nix ] && echo 'OK full.nix' || echo 'FAIL no full.nix'
        [ -f ~/.config/home-manager/modules/desktop.nix ] && echo 'OK desktop.nix' || echo 'FAIL no desktop.nix'
        [ -f ~/.config/systemd/user/xremap.service ] && echo 'OK xremap.service' || echo 'FAIL no xremap.service'
        grep -q nix-profile ~/.config/systemd/user/xremap.service && echo 'OK xremap.service nix path' || echo 'FAIL xremap.service path'
        grep -q './modules/desktop.nix' ~/.config/home-manager/home.nix && echo 'OK home.nix imports desktop' || echo 'FAIL home.nix no desktop import'
        ;;
    esac

    # Syntax check
    zsh -n ~/.zshrc 2>&1 && echo 'OK zshrc syntax' || echo 'FAIL zshrc syntax'
  " 2>&1)

  echo "$output"

  # Count failures
  local fails
  fails=$(echo "$output" | grep -c "^FAIL" || true)
  if [[ $fails -gt 0 ]]; then
    echo "  ❌ $fails FAILED"
    return 1
  else
    local oks
    oks=$(echo "$output" | grep -c "^OK" || true)
    echo "  ✅ $oks passed"
    return 0
  fi
}

profiles=("${@:-minimal full desktop}")
total_failed=0

for profile in $profiles; do
  if ! test_profile "$profile"; then
    ((total_failed++))
  fi
done

echo ""
echo "=========================================="
if [[ $total_failed -eq 0 ]]; then
  echo "  ALL TESTS PASSED"
else
  echo "  $total_failed PROFILE(S) FAILED"
  exit 1
fi
echo "=========================================="
