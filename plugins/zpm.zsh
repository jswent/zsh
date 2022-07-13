#!/bin/zsh
#
# Minimal zsh plugin manager to source local and omz plugins

is_local_plugin () {
  local name=$1
  builtin test -f $ZSH/plugins/$name.zsh || builtin test -f $ZSH/plugins/$name.plugin.zsh || builtin test -d $ZSH/plugins/$name
}

source_local_plugin () {
  local name=$1
  if [ -n "$name" ]; then
    [ -f "$ZSH/plugins/$name.zsh" ] && source "$ZSH/plugins/$name.zsh"
    [ -f "$ZSH/plugins/$name.plugin.zsh" ] && source "$ZSH/plugins/$name.plugin.zsh"
    
    if [ -d "$ZSH/plugins/$name" ]; then
      for file in $ZSH/plugins/$name/*.zsh; do 
        local strip=$(basename -s .zsh $file)
        local noext=$(basename $file | cut -f1 -d".")
        [ "$noext" = "$strip" ] && source "$file"
      done
    fi
  fi
}

is_omz_plugin () {
  local name=$1
  local omz_plugins=$(<$ZSH/plugins/omz-plugins.txt)
  for omz_plugin in $=omz_plugins; do 
    if [ "$omz_plugin" = "$name" ]; then
      return true
    else 
      return false
    fi 
  done
}

source_omz_plugin () {
  local name=$1
  if [ -n "$name" ]; then
    print -P "%{$fg_bold[green]%}ZPM: Downloading $name plugin from oh-my-zsh...\n%{$reset_color%}"
    curl "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/$name/$name.plugin.zsh" >> $ZSH/plugins/$name.plugin.zsh 
    [ -f "$ZSH/plugins/$name.plugin.zsh" ] && source "$ZSH/plugins/$name.plugin.zsh"
    print -P "\n%{$fg_bold[green]%}ZPM: $name successfully installed\n%{$reset_color%}"
  fi 
}

if [ -n "$plugins" ]; then
  for plugin in $=plugins; do
    # Source config files before loading plugin
    [ -f "$ZSH/config/$plugin.zsh" ] && source "$ZSH/config/$plugin.zsh"
    
    if is_local_plugin "$plugin"; then
      source_local_plugin "$plugin"
    elif is_omz_plugin "$plugin"; then
      source_omz_plugin "$plugin"
    fi

  done 
fi   
