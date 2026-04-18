# 00_options.zsh — General zsh options

# LS_COLORS via vivid (truecolor, theme-consistent across environments)
# Must be set before 10_completion.zsh for list-colors to work
if command -v vivid &>/dev/null; then
  export LS_COLORS="$(vivid generate "${THEME_VIVID:-catppuccin-mocha}")"
  # Make eza use LS_COLORS + Catppuccin Mocha UI colors
  export EZA_COLORS="reset:\
ur=38;2;203;166;247:uw=38;2;243;139;168:ux=38;2;166;227;161:\
gr=38;2;203;166;247:gw=38;2;243;139;168:gx=38;2;166;227;161:\
tr=38;2;203;166;247:tw=38;2;243;139;168:tx=38;2;166;227;161:\
sn=38;2;166;227;161:sb=38;2;148;226;213:\
uu=38;2;205;214;244:un=38;2;88;91;112:\
gu=38;2;205;214;244:gn=38;2;88;91;112:\
da=38;2;137;180;250:\
xx=38;2;88;91;112"
fi

# Vi mode
bindkey -v
export KEYTIMEOUT=1

# General
setopt interactive_comments   # allow comments in interactive shell
setopt extended_glob          # extended globbing (#, ~, ^)
setopt no_beep                # no beep on error
setopt rm_star_silent         # don't confirm rm *
setopt brace_ccl              # brace expansion {a-z}
setopt prompt_cr              # add \n when missing in last line
setopt combining_chars        # handle Unicode combining characters
setopt rc_quotes              # allow '' inside single-quoted strings

# Directory traversal
DIRSTACKSIZE=20
setopt auto_cd                # cd without typing cd
setopt auto_pushd             # push dirs onto stack automatically
setopt pushd_ignore_dups      # no dups in dir stack
setopt pushd_minus            # swap +/- for pushd

# Job control
export REPORTTIME=10          # report time for commands > 10s
setopt long_list_jobs         # list jobs in long format
setopt no_bg_nice             # don't nice background jobs
setopt no_hup                 # don't kill bg jobs on exit
setopt no_list_beep           # no beep on ambiguous completion
setopt local_options          # options local to functions
setopt local_traps            # traps local to functions
