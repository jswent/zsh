# ~/.zsh/snippets/prompt.zsh

function check_last_exit_code() {
  local LAST_EXIT_CODE=$?
  if [[ $LAST_EXIT_CODE -ne 0 ]]; then
    local EXIT_CODE_PROMPT=' '
    EXIT_CODE_PROMPT+="%{$fg_bold[red]%}$LAST_EXIT_CODE %{$reset_color%}"
    EXIT_CODE_PROMPT+="%{$fg_bold[red]%}  %{$reset_color%}"
    echo "$EXIT_CODE_PROMPT"
  else 
    echo "%{$fg_bold[green]%}  %{$reset_color%}"
  fi
}

function build_prompt_prefix() {
  local base="$fg_bold[blue]"
  local highlight="$fg_bold[cyan]"
  local text="$fg_bold[boldyellow]"
  local dim="$fg[bg-black]"

  if [ -n "$WEZTERM_EXECUTABLE" ]; then
    text="$fg_bold[white]"
  fi

  local username="%n"
  local hostname="%m"
  local current_dir="%~"
  local gitprompt_loaded=$(gitprompt)

  echo "%{$base%}[%{$text%}%n%{$highlight%}@%{$text%}%m%{$base%}] %{$dim%}%~"
}

function build_prompt_tail() {
  local base="$fg_bold[blue]"

  echo "%{$base%}❯ %{$rest_color%}"
}


PROMPT=$'%B%{\e[1;34m%}[%{\e[1;93m%}%n%{\e[1;36m%}@%{\e[1;93m%}%m%{\e[1;34m%}] %{\e[1;90m%}%~ $(gitprompt)%{\e[1;34m%}❯%b %{\e[0m%}'
RPROMPT='$(check_last_exit_code)'

if [ -n "$WEZTERM_EXECUTABLE" ]; then
  PROMPT=$'$(build_prompt_prefix) $(gitprompt)$(build_prompt_tail)'
fi
