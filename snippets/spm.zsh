# Snippet manager for easy .zshrc readability

is_snippet () {
  local name=$1
  builtin test -f $ZSH/snippets/$name.zsh 
}

source_snippet () {
  local name=$1
  if [ -n "$name" ]; then
    [ -f "$ZSH/snippets/$name.zsh" ] && source "$ZSH/snippets/$name.zsh"
  fi
}

if [ -n "$snippets" ]; then
  for snippet in $=snippets; do
    if is_snippet "$snippet"; then
      source_snippet "$snippet"
    fi
  done
fi
