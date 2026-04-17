# 00_options.zsh — General zsh options

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
