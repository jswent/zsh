# $ZSH/keymaps.zsh

bindkey '^ ' autosuggest-accept

# Launch functions
launchneovim () { nvim . }
zle -N launchneovim

launchranger () { ranger <$TTY; zle redisplay; }
zle -N launchranger 

# Launch applications
bindkey '^f' launchranger
bindkey '^v' launchneovim
