#
# $ZSH/snippets/env.zsh
#

# Location environment variables
export PROJECTS="$HOME/Projects"

# Plugin environment variables
if [[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]]; then
  export FIG_ACTIVE="True"
else
  export FIG_ACTIVE="False"
fi
