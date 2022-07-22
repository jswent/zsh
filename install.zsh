#!/bin/zsh 

autoload -U colors && colors

local dependencies=( fzf neofetch exa navi entr )

# check if .zsh already exists, if so backup
if [ -d "$HOME/.zsh" ]; then
  while true; do
    read "?Existing zsh config found, do you wish to overwrite? Existing config will be stored in '$HOME/.zsh.old' (Y/n): " yn
    case $yn in
        [Yy]* ) mv -f "$HOME/.zsh" "$HOME/.zsh.old"; break;;
        [Nn]* ) break;;
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
echo "$fg_bold[green]Creating symlink $HOME/.zsh/.zshrc -> $HOME/.zshrc$reset_color"
ln -s "$HOME/.zsh/.zshrc" "$HOME/.zshrc"

# Install plugin from github 
install_plugin () {
  local author=$1
  local plugin=$2
  print "$fg_bold[green]Installing $plugin in $ZSH/plugins$reset_color\n"
  git clone "https://github.com/$author/$plugin" "$ZSH/plugins/$plugin"
}

# Install base plugins
install_plugin "zsh-users" "zsh-syntax-highlighting"
install_plugin "zsh-users" "zsh-autosuggestions"

OS=""
VER=""

# get os name
if [ -f /etc/os-release ]; then
  # freedesktop.org and systemd
  . /etc/os-release
  OS=$NAME
  VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
elif [ -f /etc/SuSe-release ]; then
    # Older SuSE/etc.
    ...
elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    ...
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
fi

# installs program with os-specific package manager from passed argument
install_program () {
  if [[ "$OS" = "Arch Linux" ]]; then
    sudo pacman -S "$1"
  elif [[ "$OS" = "Ubuntu" ]]; then
    sudo apt install "$1"
  elif [[ "$OS" = "Darwin" ]]; then
    brew install "$1"
  else 
    echo "Failed to install $1, please install manually"
  fi
}

# checks if the program passed to the function is installed, if not prompts the user
check_program () { 
  if ! command -v "$1" &> /dev/null; then
    while true; do
      read "?$fg_bold[red][ERROR] $1 was not found on your system, would you like to install it (Y/n)$reset_color " yn
      case $yn in 
        [Yy]* ) install_program "$1"; break;;
        [Nn]* ) break;;
        * ) echo "Please enter yes or no.";;
      esac
    done
  fi
}

# Check for dependencies
print "\n$fg_bold[green][!!] Now checking for dependencies, please only install dependencies of plugins you wish to use. If you are unsure, install all.$reset_color\n"
for dependency in $=dependencies; do
  check_program "$dependency"
done


