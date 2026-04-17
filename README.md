# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/), [Nix (home-manager)](https://nix-community.github.io/home-manager/), and [sheldon](https://sheldon.cli.rs/).

## Quick Start

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply openjny/dotfiles
```

You'll be prompted to choose:

| Prompt | Description |
|--------|-------------|
| **profile** | `minimal` / `full` / `desktop` |
| **email** | Git email |
| **name** | Git user name |

## Profiles

| Profile | Use case | What's included |
|---------|----------|-----------------|
| **minimal** | VM, one-off environments | zsh, tmux, fzf, ripgrep, bat, git, starship |
| **full** | WSL, Codespaces, dev VMs | + gh, azure-cli, azd, kubectl, terraform |
| **desktop** | Ubuntu Desktop | + xremap, fonts |

## Stack

| Layer | Tool | Role |
|-------|------|------|
| Dotfile management | chezmoi | Template-based file placement, profile switching |
| Package management | Nix (home-manager) | Declarative, reproducible, user-space packages |
| Zsh plugins | sheldon | TOML config, fast Rust binary |
| Prompt | starship | Cross-shell, TOML config, azure/k8s context |

## Structure

```
.chezmoi.toml.tmpl              # Profile selection on init
.chezmoiignore                  # Profile-based file exclusion
.chezmoiscripts/                # Nix + home-manager auto-install
dot_config/
  home-manager/
    flake.nix                   # Nix flake
    home.nix.tmpl               # Profile-aware imports (chezmoi template)
    modules/
      core.nix                  # fzf, ripgrep, bat, eza, zoxide, tmux, sheldon, starship
      full.nix                  # gh, azure-cli, azd, kubectl, terraform
      desktop.nix               # xremap, fonts
  sheldon/plugins.toml          # zsh-completions, autosuggestions, fzf-tab, syntax highlighting
  starship.toml                 # Prompt config (azure, k8s enabled)
  tmux/tmux.conf
  nvim/init.vim                 # Minimal (no plugins)
  xremap/config.yml             # Desktop only: CapsLock → Super/Esc
dot_zshrc                       # Entry point: sheldon + split configs
dot_zshenv                      # Env vars, PATH, Nix setup
dot_zsh/                        # Split zsh configs
  00_options.zsh                # General options, vi mode
  10_completion.zsh             # Tab completion
  11_history.zsh                # History settings
  20_alias.zsh                  # Aliases (eza, git, tmux)
  21_keybind.zsh                # Key bindings
dot_gitconfig.tmpl              # Git config with delta
```

## Reconfigure

```bash
chezmoi init                    # Re-run profile/email/name prompts
chezmoi apply                   # Apply changes
```

## Legacy

Previous dotfiles (stow + Homebrew + zinit) are preserved at tag `v1-legacy`:

```bash
git show v1-legacy:zsh/.zshrc   # View old files
git diff v1-legacy..main        # Compare with current
```

## Testing

```bash
docker build -t dotfiles-test .
docker run -it --rm dotfiles-test bash
# Then inside the container:
chezmoi init --apply openjny/dotfiles --exclude=scripts
```
