
### ZSH HOME
export ZSH=$HOME/.zsh

## Load colors
autoload -U colors && colors

## Choose theme (p10k, agnoster, ...)
export THEME='custom'

## EDTIOR
export EDITOR='nvim'
export VISUAL='nvim'

## ZSH HISTORY
export HISTFILE=$ZSH/.zsh_history
export HISTSIZE=100000000
export SAVEHIST=100000000
setopt appendhistory
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

## SELECT PLUGINS
export plugins=(
  zsh-syntax-highlighting
  zsh-autosuggestions
  nvm 
  git-prompt
  fzf
  navi-plugin
)

# Source snippets
source $ZSH/snippets/init.zsh

## ENABLE PLUGIN MANAGER 
source $ZSH/plugins/zpm.zsh

# Source aliases
source $ZSH/.aliases

# If no theme or custom selected load prompt
if [ -z "$THEME" ] || [ "$THEME" = "custom" ]; then
  source $ZSH/snippets/prompt.zsh
fi

# Zsh to use the same colors as ls
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Change terminal theme if on my arch systems
if [ "$(hostname)" = "arch-turbo" ] || [ "$(hostname)" = "arch-blade" ]; then
  /home/jswent/scripts/termtheme nord.yml
fi 

# Keymaps 
source $ZSH/keymaps.zsh

# display hardware
sfetch

