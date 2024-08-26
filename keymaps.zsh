# $ZSH/keymaps.zsh

bindkey '^ ' autosuggest-accept

# Launch functions
launchneovim () { nvim . }
zle -N launchneovim

launchranger () { ranger <$TTY; zle redisplay; }
launchfiles () { 
  if command -v yazi >/dev/null 2>&1; then
    yazi <$TTY
  elif command -v ranger >/dev/null 2>&1; then
    ranger <$TTY
  else
    echo "Error: No TUI file manager found."
  fi
  zle redisplay
}
zle -N launchfiles

# Launch applications
bindkey '^f' launchfiles
bindkey '^v' launchneovim
