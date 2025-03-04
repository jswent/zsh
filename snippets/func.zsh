git_author_stats() {
  if [ -n "$1" ]; then
    # If an author name is provided, run stats for that author.
    git log --author="$1" --pretty=tformat: --numstat |
      awk -v author="$1" '{
        add += $1; subs += $2; loc += $1 - $2
      } END {
        printf "%s: added lines: %s, removed lines: %s, total lines: %s\n", author, add, subs, loc
      }'
  else
    # No author provided; find all unique authors in the repository.
    local authors
    IFS=$'\n' read -d '' -r -A authors < <(git log --format='%aN' | sort -u && printf '\0')
    for author in "${authors[@]}"; do
      git log --author="$author" --pretty=tformat: --numstat |
        awk -v author="$author" '{
          add += $1; subs += $2; loc += $1 - $2
        } END {
          printf "%s: added lines: %s, removed lines: %s, total lines: %s\n", author, add, subs, loc
        }'
    done
  fi
}

zhelp() {
  local header_color=$fg_bold[cyan]
  local section_color=$fg_bold[magenta]
  local key_color=$fg_bold[yellow]
  local desc_color=$fg[white]
  local reset_color=$reset_color

  echo "${header_color}ZSH Configuration Help${reset_color}"
  echo "${header_color}====================${reset_color}\n"

  echo "${section_color}About:${reset_color}"
  echo "This ZSH configuration is designed to be fast, minimal, and easily extensible"
  echo "with all the features of a modern terminal. It supports Oh-My-ZSH themes and plugins."
  echo "Current theme: ${key_color}$THEME${reset_color}\n"

  echo "${section_color}Active Plugins:${reset_color}"
  for plugin in $plugins; do
    echo "  - ${key_color}$plugin${reset_color}"
  done
  echo ""

  echo "${section_color}Key Bindings:${reset_color}"
  
  # Autosuggestions
  echo "  ${key_color}Autosuggestions:${reset_color}"
  echo "    ${key_color}Ctrl+Space${reset_color} - ${desc_color}Accept current suggestion${reset_color}"
  
  # FZF
  echo "  ${key_color}FZF (Fuzzy Finder):${reset_color}"
  echo "    ${key_color}Ctrl+R${reset_color} - ${desc_color}Search command history${reset_color}"
  echo "    ${key_color}Ctrl+T${reset_color} - ${desc_color}Search for files in current directory${reset_color}"
  echo "    ${key_color}Alt+C${reset_color} - ${desc_color}Change to subdirectory${reset_color}"
  
  # FZF Git
  if [[ $plugins[(ie)fzf] -le $#plugins ]]; then
    echo "  ${key_color}FZF Git:${reset_color}"
    echo "    ${key_color}Ctrl+G+F${reset_color} - ${desc_color}Git files${reset_color}"
    echo "    ${key_color}Ctrl+G+B${reset_color} - ${desc_color}Git branches${reset_color}"
    echo "    ${key_color}Ctrl+G+T${reset_color} - ${desc_color}Git tags${reset_color}"
    echo "    ${key_color}Ctrl+G+R${reset_color} - ${desc_color}Git remotes${reset_color}"
    echo "    ${key_color}Ctrl+G+H${reset_color} - ${desc_color}Git hashes${reset_color}"
  fi
  
  # FZF Brew
  if [[ $+commands[brew] -eq 1 && $plugins[(ie)fzf] -le $#plugins ]]; then
    echo "  ${key_color}FZF Brew:${reset_color}"
    echo "    ${key_color}fbi${reset_color} - ${desc_color}Fuzzy brew install${reset_color}"
    echo "    ${key_color}fbui${reset_color} - ${desc_color}Fuzzy brew uninstall${reset_color}"
    echo "    ${key_color}fci${reset_color} - ${desc_color}Fuzzy cask install${reset_color}"
    echo "    ${key_color}fcui${reset_color} - ${desc_color}Fuzzy cask uninstall${reset_color}"
    echo "    ${key_color}Ctrl+Space${reset_color} - ${desc_color}Open homepage of selected formula/cask${reset_color}"
  fi
  
  # File manager and editor shortcuts
  echo "  ${key_color}Applications:${reset_color}"
  echo "    ${key_color}Ctrl+F${reset_color} - ${desc_color}Launch file manager (ranger/yazi)${reset_color}"
  echo "    ${key_color}Ctrl+V${reset_color} - ${desc_color}Launch neovim in current directory${reset_color}"
  echo "    ${key_color}Ctrl+G${reset_color} - ${desc_color}Launch lazygit${reset_color}"
  
  # Machmarks
  if [[ $plugins[(ie)machmarks] -le $#plugins ]]; then
    echo "  ${key_color}Machmarks:${reset_color}"
    echo "    ${key_color}Ctrl+E${reset_color} - ${desc_color}Fuzzy find bookmarks${reset_color}"
    echo "    ${key_color}machmarks -s <name>${reset_color} - ${desc_color}Save current directory as bookmark${reset_color}"
    echo "    ${key_color}machmarks -g <name>${reset_color} - ${desc_color}Go to bookmark${reset_color}"
    echo "    ${key_color}machmarks -l${reset_color} - ${desc_color}List all bookmarks${reset_color}"
  fi
  
  echo "\n${section_color}Common Git Aliases:${reset_color}"
  echo "  ${key_color}ggs${reset_color} - ${desc_color}git status${reset_color}"
  echo "  ${key_color}gga${reset_color} - ${desc_color}git add${reset_color}"
  echo "  ${key_color}ggc${reset_color} - ${desc_color}git commit -m${reset_color}"
  echo "  ${key_color}ggp${reset_color} - ${desc_color}git push to all remote branches${reset_color}"
  
  echo "\n${section_color}Useful Functions:${reset_color}"
  echo "  ${key_color}git_author_stats [author]${reset_color} - ${desc_color}Show git contribution statistics${reset_color}"
  
  echo "\n${section_color}Configuration:${reset_color}"
  echo "  Configuration files are located in ${key_color}$ZSH${reset_color}"
  echo "  To add plugins, edit ${key_color}~/.zshrc${reset_color} and modify the 'plugins' array"
  echo "  To change theme, set ${key_color}THEME='theme_name'${reset_color} in ${key_color}~/.zshrc${reset_color}"
  
  echo "\n${section_color}For more information:${reset_color}"
  echo "  Visit ${key_color}https://github.com/jswent/zsh${reset_color}"
}
