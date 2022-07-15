# Snippet manager for easy .zshrc readability

is_snippet () {
  local name=$1
  builtin test -f $ZSH/plugins/$name.zsh 
}

source_snippet () {
  local name=$1
  if [ -n "$name" ]; then
    [ -f "$ZSH/plugins/$name.zsh" ] && source "$ZSH/plugins/$name.zsh"
  fi
}

if [ -n "$snippets" ]; then
  for snippet in $=snippets; do
    if is_snippet "$snippet"; then
      source_snippet "$snippet"
    fi
  done
fi
