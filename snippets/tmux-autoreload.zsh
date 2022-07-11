typeset +x session_status=$(tmux has-session -t autoreload 2>&1 )
if [[ -n "$TMUX" ]] && [[ -n "$session_status" ]]; then
  tmux new-session -d -s autoreload 'find "$HOME/.tmux" -type f \( -name "*.tmux" -o -name "*.conf" \) | entr tmux source-file "$HOME/.tmux.conf"'
fi  
