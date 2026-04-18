# 10_completion.zsh — Completion settings

# Cached compinit: only regenerate dump once per day
autoload -Uz compinit
_comp_dump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
[[ -d "${_comp_dump:h}" ]] || mkdir -p "${_comp_dump:h}"
if [[ -n "$_comp_dump"(#qN.mh+24) ]]; then
  compinit -d "$_comp_dump"
else
  compinit -C -d "$_comp_dump"
fi
unset _comp_dump

# Load bash completions (needed for az cli, etc.)
autoload -Uz bashcompinit && bashcompinit

# Options
setopt complete_in_word       # complete from cursor position, not end
setopt always_to_end          # move cursor to end after completion
setopt auto_list              # list choices on ambiguous completion
setopt auto_menu              # show menu on second tab press
setopt list_packed            # compact completion list
setopt list_types             # show file types in list
setopt magic_equal_subst      # complete after = in --opt=val
setopt auto_param_keys        # auto-remove trailing space when needed
setopt auto_param_slash       # append / to dirs
setopt mark_dirs              # append / to dir in glob
setopt auto_remove_slash      # remove trailing / when not needed
setopt no_list_beep           # no beep on ambiguous completion

# Shift-Tab for reverse menu
bindkey "^[[Z" reverse-menu-complete

# Menu selection with highlighting
zstyle ':completion:*:*:*:*:*' menu select

# fzf-tab preview
zstyle ':fzf-tab:complete:*' fzf-preview 'bat --color=always --style=header,grid --line-range=:50 $realpath 2>/dev/null || eza -la $realpath 2>/dev/null'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --tree --level=2 $realpath 2>/dev/null'
zstyle ':fzf-tab:' use-fzf-default-opts yes

# Case-insensitive, partial-word, and substring matching
zstyle ':completion:*' matcher-list \
  'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' \
  'r:|=*' 'l:|=* r:|=*'

# Complete . and .. special directories
zstyle ':completion:*' special-dirs true

# Pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# Completer chain
zstyle ':completion:*' completer _expand _complete _files _correct _approximate

# Use LS_COLORS for colorized completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Caching (speeds up apt, docker, etc.)
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compcache"

# Description formatting
zstyle ':completion:*:descriptions' format '%F{yellow}completing %B%d%b%f'
zstyle ':completion:*:corrections' format '%F{green}!- %d (errors: %e) -!%f'
zstyle ':completion:*:warnings' format '%F{red}No matches for: %F{yellow}%d%f'
zstyle ':completion:*:messages' format '%F{yellow}%d%f'
zstyle ':completion:*:options' description yes
zstyle ':completion:*:manuals' separate-sections true

# Ignore parent directory in ../
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# Kill process completion with colors
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USERNAME -o pid,user,comm -w -w"

# Exclude uninteresting system users
zstyle ':completion:*:*:*:users' ignored-patterns \
  adm amanda apache avahi bin clamav daemon dbus distcache dovecot fax ftp \
  games gdm gopher hacluster halt hsqldb ident junkbust kdm ldap lp mail \
  mailman mailnull man messagebus mysql nagios named netdump news nfsnobody \
  nobody nscd ntp nut nx openvpn operator pcap polkitd postfix postgres \
  privoxy pulse pvm quagga radvd rpc rpcuser rpm rtkit shutdown squid sshd \
  statd svn sync sys tftp usbmux uucp www-data
