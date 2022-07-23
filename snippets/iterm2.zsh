# Activates iTerm2 shell integration
local OS=$(uname -s)

if [ "$OS" = 'Darwin' ]; then
  test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
  unalias imgcat
fi
