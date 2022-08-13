# prompt.zsh

# enable color on prompt
autoload -Uz colors
colors

setopt prompt_subst

# Load the pure theme, with zsh-async library that's bundled with it.
# zinit ice pick"async.zsh" src"pure.zsh"
# zinit light sindresorhus/pure
zinit light agnoster/agnoster-zsh-theme
export ZSH_THEME="agnoster"

# username@hostname -> empty
prompt_context() {}

# differenciate prompt between in INSERT/NOMARL modes
function zle-line-init zle-keymap-select {
  case $KEYMAP in
    vicmd)
        prompt_context() {
            prompt_segment black default "📣 "
        }
    ;;
    main|viins)
        prompt_context() {}
    ;;
  esac
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
