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

if [ -n "$plugins" ]; then
  for plugin in $=plugins; do 
    if is_local_plugin "$plugin"; then
      source_local_plugin "$plugin"
    fi

    [ -f "$ZSH/config/$plugin.zsh" ] && source "$ZSH/config/$plugin.zsh"
  done 
fi      
