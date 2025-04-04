# Include fzf-git bindings
source $ZSH/plugins/fzf/fzf-git.sh

# Initialize starship prompt if theme is set to starship
if [[ "$THEME" == "starship" ]]; then
  eval "$(starship init zsh)"
fi

# Initialize zoxide only if it exists
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Load and initialize completions
autoload -Uz compinit
compinit -i
