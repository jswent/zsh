# ~/.zsh/snippets/prompt.zsh

function check_last_exit_code() {
  local LAST_EXIT_CODE=$?
  if [[ $LAST_EXIT_CODE -ne 0 ]]; then
    local EXIT_CODE_PROMPT=' '
    EXIT_CODE_PROMPT+="%{$fg_bold[red]%}%{$reset_color%}"
    EXIT_CODE_PROMPT+="%{$fg_bold[red]%}$LAST_EXIT_CODE  %{$reset_color%}"
    echo "$EXIT_CODE_PROMPT"
  else 
    echo "%{$fg_bold[green]%}  %{$reset_color%}"
  fi
}

PROMPT=$'%B%{\e[1;34m%}[%{\e[1;93m%}%n%{\e[1;36m%}@%{\e[1;93m%}%m%{\e[1;34m%}] %{\e[1;90m%}%~ $(gitprompt)%{\e[1;34m%}❯%b %{\e[0m%}'
RPROMPT='$(check_last_exit_code)'
