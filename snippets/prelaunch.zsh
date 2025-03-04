# Include fzf-git bindings
source $ZSH/plugins/fzf/fzf-git.sh

# Initialize zoxide only if it exists
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
