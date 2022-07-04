#!/bin/zsh 

# check if .zsh already exists, if so backup
if [ -d "$HOME/.zsh" ]; then
  while true; do
    read -p "Existing zsh config found, do you wish to overwrite? Existing config will be stored in '$HOME/.zsh.old' (Y/n) " yn
    case $yn in
        [Yy]* ) mv -f "$HOME/.zsh" "$HOME/.zsh.old"; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
  done
fi

# check if .zshrc already exists, if so backup 
if [ -f "$HOME/.zshrc" ]; then
  mv -f "$HOME/.zshrc" "$HOME/.zshrc.old"
fi 

# clone new zsh config 
git clone https://github.com/jswent/zsh "$HOME/.zsh" 

# link zsh config to .zshrc 
echo "Creating symlink $HOME/.zsh/.zshrc -> $HOME/.zshrc"
ln -s "$HOME/.zsh/.zshrc" "$HOME/.zshrc"


