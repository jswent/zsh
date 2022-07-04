
### ZSH HOME
export ZSH=$HOME/.zsh

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

# Zsh to use the same colors as ls
eval $(env TERM=alacritty-color dircolors)
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}  

# Terminal theme 
/home/jswent/scripts/termtheme nord.yml

# Keymaps 
bindkey '^ ' autosuggest-accept

# neofetch
neofetch

