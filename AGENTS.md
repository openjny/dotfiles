# Dotfiles — Agent Guide

## Commands

```bash
./test.sh                    # Test all profiles (minimal/full/desktop) in Docker
./test.sh desktop            # Test single profile
REBUILD=1 ./test.sh          # Force Docker image rebuild
chezmoi apply --exclude=scripts  # Apply dotfiles (skip scripts)
home-manager switch --flake "$HOME/.config/home-manager#default"  # Apply Nix packages
```

## Architecture

Four layers, tightly coupled:

| Layer | Tool | What it does |
|-------|------|-------------|
| Orchestration | chezmoi | Templates (`dot_` prefix → `~/.`), profile switching, scripts |
| Packages | home-manager (Nix) | Declarative install. `enableZshIntegration = false` for all tools |
| Plugin loading | sheldon | Zsh plugin init in strict order. Owns `eval "$(tool init zsh)"` |
| Shell config | zsh split files | `00_options` → `10_completion` → `20_alias` → `21_keybind` |

**Why sheldon owns init, not home-manager**: chezmoi manages `.zshrc`, so home-manager's `enableZshIntegration` has no effect.

## Profile system

Three profiles set in `~/.config/chezmoi/chezmoi.toml`:
- **minimal**: core CLI tools only
- **full**: + cloud/dev tools (azure-cli, kubectl, terraform, gh)
- **desktop**: + xremap, Nerd Fonts, desktop apt packages

Profiles control: `.chezmoiignore` (file exclusion), `home.nix.tmpl` (module imports), `desktop-apt-packages.sh.tmpl` (conditional scripts).

## Critical rules

### Sheldon load order matters

```
zsh-completions (fpath) → compinit → fzf → fzf-tab → autosuggestions → history-substring-search → fast-syntax-highlighting → zoxide → direnv → starship
```

Breaking this order causes: fzf-tab not working, completions missing, TAB bound to wrong widget.

### Powerline/Nerd Font characters in starship.toml

- **Use TOML `\uXXXX` escapes** for Powerline arrows (`\uE0B0`, `\uE0B6`, `\uE0A0`)
- The `replace_string_in_file` editor tool **drops Unicode Private Use Area characters**. Always use `\uXXXX` escapes or write via terminal/Python
- Nerd Font icons in `symbol =` fields must also use `\uXXXX` or be written via Python
- **Font Awesome basic set** (U+F000–U+F2FF) is reliably rendered. Higher codepoints may not display

### LS_COLORS must be set before completions

`vivid generate` runs in `00_options.zsh` (not `20_alias.zsh`) so that `10_completion.zsh` can use it for `list-colors`.

### fzf --zsh clears FZF_DEFAULT_OPTS

The sheldon fzf plugin re-applies FZF vars from `hm-session-vars.sh` after `eval "$(fzf --zsh)"`.

### chezmoi lock contention

`chezmoistate.boltdb` allows only one process. Kill stale processes before running `chezmoi apply`:
```bash
pkill -9 -f chezmoi; sleep 1; chezmoi apply
```

### apt scripts are idempotent

`run_once_after_desktop-apt-packages.sh.tmpl` checks `command -v docker` and `dpkg -s` before installing. No unnecessary `sudo`.

## Theming

Catppuccin Mocha is the default. Unified across: starship, vivid (LS_COLORS), eza (EZA_COLORS), fzf, bat, delta, fast-syntax-highlighting.

Theme switcher: `starship-theme <name>` — switches starship + vivid LS_COLORS simultaneously.

Available themes: catppuccin-mocha, gruvbox-dark, tokyo-night, dracula, nord, rose-pine, one-dark.

## Validation checklist

Before committing changes:

1. `sheldon source > /dev/null` — plugins.toml is valid
2. `zsh -c 'source <(sheldon source)'` — generated source parses
3. `zsh -n ~/.zshrc` — zshrc syntax OK
4. `starship prompt` — no parse errors
5. `./test.sh` — all profiles pass
