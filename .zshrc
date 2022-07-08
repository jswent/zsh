
### ZSH HOME
export ZSH=$HOME/.zsh

## Load colors
autoload -U colors && colors

## Choose theme
#source $ZSH/themes/p10k.zsh
#source $ZSH/themes/agnoster.zsh-theme

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

# Source snippets
source $ZSH/snippets/init.zsh

# Source plugins 
source $ZSH/plugins/init.zsh

# Source aliases
source $ZSH/.aliases

# If no theme selected load prompt
PS1=$'%B\e[1;34m[\e[1;93m%n\e[1;36m@\e[1;93m\%m\e[1;34m] \e[1;90m%~ $(gitprompt)\e[1;34m ❯%b \e[0m'

# Zsh to use the same colors as ls
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Terminal theme 
/home/jswent/scripts/termtheme nord.yml

# Keymaps 
bindkey '^ ' autosuggest-accept

# neofetch
neofetch

