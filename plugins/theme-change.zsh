
theme_change () {
  local name=$1
  if [ "$name" = "custom" ]; then 
    source "$ZSH/snippets/prompt.zsh"
  elif [ -n "$name" ]; then
    for file in $ZSH/themes/*; do 
      local noext=$(basename $file | cut -f1 -d ".")
      if [ "$noext" = "$name" ]; then 
        export THEME="$name"
        export disable_neofetch="true"
        source "$file"
        unset disable_neofetch
      fi
    done
  else 
    return 1
  fi 
}
