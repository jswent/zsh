

for file in $ZSH/themes/*
do
  name=$(basename "$file" | sed 's/\..*$//')
  if [[ "$THEME" == "$name" ]]; then
    source "$file"
  fi
done

