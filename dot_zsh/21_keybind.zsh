# 21_keybind.zsh — Key bindings (vi mode + terminfo-safe)

# Use terminfo for portable key definitions
zmodload -i zsh/terminfo

# Home / End / Delete — terminfo-based, works across terminals
[[ -n "$terminfo[khome]" ]] && bindkey "$terminfo[khome]" beginning-of-line
[[ -n "$terminfo[kend]"  ]] && bindkey "$terminfo[kend]"  end-of-line
[[ -n "$terminfo[kdch1]" ]] && bindkey "$terminfo[kdch1]" delete-char
[[ -n "$terminfo[kcbt]"  ]] && bindkey "$terminfo[kcbt]"  reverse-menu-complete

# Also bind common escape sequences (fallback for broken terminfo)
bindkey '^[[H'  beginning-of-line   # Home
bindkey '^[[F'  end-of-line         # End
bindkey '^[[3~' delete-char         # Delete

# History substring search (zsh-history-substring-search plugin)
if (( ${+widgets[history-substring-search-up]} )); then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  bindkey -M vicmd 'k' history-substring-search-up
  bindkey -M vicmd 'j' history-substring-search-down
fi

# Magic space: inline expand !! etc.
bindkey ' ' magic-space

# Edit command in $EDITOR with Ctrl+X Ctrl+E (like bash)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
bindkey -M vicmd 'v' edit-command-line   # v in vi normal mode

# Ctrl+W: backward kill word (use WORDCHARS for sane boundaries)
WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# Vi mode: make backspace work across insert/newline
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^U' backward-kill-line

# Application mode for zle (ensures terminfo values work)
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
  function zle-line-init() { echoti smkx }
  function zle-line-finish() { echoti rmkx }
  zle -N zle-line-init
  zle -N zle-line-finish
fi
