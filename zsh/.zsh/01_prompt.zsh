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
