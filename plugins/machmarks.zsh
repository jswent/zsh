#!/bin/bash

# USAGE:
# machmarks -s bookmarkname - saves the current dir as bookmarkname
# machmarks -g bookmarkname - jumps to that bookmark
# machmarks -g b[TAB] - tab completion is available
# machmarks -p bookmarkname - prints the bookmark
# machmarks -p b[TAB] - tab completion is available
# machmarks -d bookmarkname - deletes the bookmark
# machmarks -d [TAB] - tab completion is available
# machmarks -l - list all bookmarks
# machmarks -f - use fzf to select a bookmark and insert the navigation command

# Setup file to store bookmarks
_mm_file_name="machmarks"
if [ -z "$MMFILE" ]; then
	if [ -n "$XDG_CONFIG_HOME" ]; then
		config_dir="$XDG_CONFIG_HOME"
	else
		config_dir="$HOME/Library/Application Support"
	fi
	mkdir -p "$config_dir/machmarks"
	MMFILE="$config_dir/machmarks/$_mm_file_name"
fi

if [ ! -f "$MMFILE" ]; then
	touch "$MMFILE"
fi

# Error message and exit
_mm_error() {
	case "$1" in
	1) echo "Error: Wrong usage of arguments!" ;;
	2) echo "Error: Machmark name required!" ;;
	3) echo "Error: Bookmark name is not valid!" ;;
	4) echo "Error: Provided with 2 directories but no machmark name!" ;;
	5) echo "Error: No valid directory provided!" ;;
	6) echo "Error: Shouldn't have reached this point." ;;
	7) echo "Error: Machmark already exists." ;;
	8) echo "Error: Directory does not exist!" ;;
	9) echo "Error: Machmark does not exist!" ;;
	10) echo "Error: fzf is not installed. Please install it to use this feature." ;;
	*) ;;
	esac
	if [ "$#" = 1 ]; then
		exit 1
	fi
}

# Print out help for the forgetful
_print_help() {
	cat <<EOF

Usage: machmarks [OPTIONS] [MACHMARK...] [DIRECTORY]

  -d, --delete  Deletes MACHMARKs from list
  -g, --go      Goes (cd) to the directory pointed to by MACHMARK
  -p, --print   Prints the directories pointed to by MACHMARKs
  -s, --set     Saves DIRECTORY or else \$PWD as MACHMARK
  -h, --help    Lists all available machmarks
  -l, --list    Lists all available machmarks
  -L, --listdir Lists all available machmarks and the directories they point to
  -f, --fzf     Use fzf to select a bookmark and insert the navigation command

EOF
}

_check_mm() {
	# Check if machmark name is valid. If not, exit with error
	_mm="$1"
	if echo "$_mm" | grep -qE "[^a-zA-Z0-9_]"; then
		_mm_error 3
	fi
	# Check if MM already exists in MMFILE.
	if grep -qE "^$_mm " "$MMFILE"; then
		_mm_e=1
	else
		_mm_e=0
	fi
}

# Save current directory to bookmarks
_set_mm() {
	_mm="///"
	_mm_dir="///"
	_mm_erff=0
	if [ "$#" -eq 3 ]; then
		if [ -d "$2" ]; then
			_mm_dir="$2"
		else
			_mm="$2"
		fi
		if [ -d "$3" ]; then
			_mm_dir="$3"
		else
			_mm="$3"
		fi
		if [ "$_mm" = "///" ]; then
			_mm_error 4 0
			_mm_erff=1
		fi
		if [ "$_mm_dir" = "///" ]; then
			_mm_error 5 0
			_mm_erff=1
		fi
		if [ "$_mm_erff" = 1 ]; then
			_mm_error -1
		fi
	elif [ "$#" -eq 2 ]; then
		_mm="$2"
		_mm_dir=$(pwd)
	else
		_mm_error 6
	fi

	_mm_dir=$(echo "$_mm_dir" | sed -E 's:(/Users/[^/]+):~:')
	_check_mm "$_mm"
	if [ "$_mm_e" = 1 ]; then
		_mm_error 7
	else
		echo "$_mm $_mm_dir" >>"$MMFILE"
	fi
}

# Jump to bookmark
_go_mm() {
  echo "$1" >> ~/Scripts/out.log
	_check_mm "$1"
	if [ "$_mm_e" = 1 ]; then
    echo "Check mm successful" >> ~/Scripts/out.log
		# Get dir by dereferencing mm in MMFILE
		_mm_dir=$(grep "^$1 " "$MMFILE" | awk '{print $2}' | sed -E "s:~:$HOME:")
    echo "$mm_dir" >> ~/Scripts/out.log

		# Check if dir exists
		if [ -d "$_mm_dir" ]; then
			cd "$_mm_dir"
		else
			_mm_error 8
		fi
	else
		_mm_error 9
	fi
}

# Print bookmark
_print_mm() {
	inc=0
	for _mm_ar in "$@"; do
		inc=$((inc + 1))
		if [ "$inc" -gt 1 ]; then
			_check_mm "$_mm_ar"
			if [ "$_mm_e" = 1 ]; then
				_mm_dir=$(grep "^$_mm_ar " "$MMFILE" | awk '{print $2}' | sed -E "s:~:$HOME:")
				echo "$_mm_dir"
			else
				if [ "$#" -eq 1 ]; then
					_mm_error 9
				else
					_mm_error 9 0
				fi
			fi
		fi
	done
}

# Delete bookmark
_delete_mm() {
	inc=0
	for _mm_ar in "$@"; do
		inc=$((inc + 1))
		if [ "$inc" -gt 1 ]; then
			_check_mm "$_mm_ar"
			if [ "$_mm_e" = 1 ]; then
				sed -i '' "/^$_mm_ar /d" "$MMFILE"
			else
				if [ "$#" -eq 1 ]; then
					_mm_error 9
				else
					_mm_error 9 0
				fi
			fi
		fi
	done
}

# List bookmarks with dirname
_list_mm_dir() {
	cat "$MMFILE"
}

# List bookmarks without dirname
_list_mm() {
	num_bookmarks=$(wc -l <"$MMFILE" | tr -d ' ')
	echo "📚 Total Bookmarks: $num_bookmarks"

	while IFS= read -r line; do
		mm_name=$(echo "$line" | awk '{print $1}')
		mm_dir=$(echo "$line" | awk '{print $2}' | sed -E "s:~:$HOME:")

		if [ -d "$mm_dir" ]; then
			echo -e "  \033[34m $mm_name\033[0m"
		else
			echo -e "  \033[34m $mm_name\033[0m \033[31m✖️\033[0m"
		fi
	done < <(sort "$MMFILE")
}

_fzf_mm_fzf() {
	fzf --height=50% --tmux 90%,70% \
		--layout=reverse --multi --min-height=20 --border \
		--border-label-pos=2 \
		--color='header:italic:underline,label:blue' \
		--preview-window='right,50%,border-left' \
		--bind='ctrl-/:change-preview-window(down,50%,border-top|hidden|)' "$@"
}

_fzf_machmarks() {
	selected=$(
		awk '{printf "\033[34m %s\033[0m \t\033[33m%s\033[0m\n", $1, $2}' "$MMFILE" |
			column -ts$'\t' |
			_fzf_mm_fzf -m --ansi --nth 2..,.. \
				--border-label '📚 Machmarks' \
				--header $'CTRL-O (open in finder) ╱ ALT-E (open in editor)\n\n' \
				--bind "ctrl-o:execute-silent:open '{3}'" \
				--bind "alt-e:execute-silent:$EDITOR '{3}'" \
				--preview "eza -l --icons --color=always --group-directories-first '{3}'"
	)
	if [ -n "$selected" ]; then
		machmark=$(echo "$selected" | awk '{print $2}')
    _go_mm "$machmark"
    echo "machmarks -g $machmark"
	fi
}

# Bash Autocomplete function
_machmarks_complete() {
	local cur prev opts
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD - 1]}"
	opts="-s -g -p -d -l -L -f --set --go --print --delete --list --listdir --fzf"

	if [[ ${prev} == "machmarks" ]]; then
		COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
		return 0
	fi

	case "${prev}" in
	-g | --go | -p | --print | -d | --delete)
		COMPREPLY=($(compgen -W "$(awk '{print $1}' "$MMFILE")" -- ${cur}))
		return 0
		;;
	-s | --set)
		# For -s, we don't provide completions as it's for creating new bookmarks
		return 0
		;;
	*) ;;
	esac

	COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
	return 0
}

# ZSH completion function
_machmarks_zsh_complete() {
	local state

	_arguments \
		'1: :->command' \
		'*:: :->argument'

	case $state in
	command)
		_arguments '1:command:((-s\:"set bookmark" -g\:"go to bookmark" -p\:"print bookmark" -d\:"delete bookmark" -l\:"list bookmarks" -L\:"list bookmarks with paths" -f\:"fuzzy find bookmark"))'
		;;
	argument)
		case ${words[1]} in
		-g | --go | -p | --print | -d | --delete)
			if ((CURRENT == 2)); then
				_values 'bookmarks' $(awk '{print $1}' "$MMFILE")
			else
				_message 'no more arguments'
			fi
			;;
		-s | --set)
			if ((CURRENT == 2)); then
				_message 'enter new bookmark name'
			elif ((CURRENT == 3)); then
				_files -/
			else
				_message 'no more arguments'
			fi
			;;
		*) ;;
		esac
		;;
	esac
}

machmarks() {
	# Main script logic
	if [ "$#" -gt 0 ]; then
		case "$1" in
		-d | --delete)
			if [ "$#" -gt 1 ]; then
				_delete_mm "$@"
			else
				_mm_error 1
			fi
			;;
		-g | --go)
			if [ "$#" = 2 ]; then
				_go_mm "$2"
			else
				_mm_error 1
			fi
			;;
		-h | --help)
			if [ "$#" = 1 ]; then
				_print_help
			else
				_mm_error 1
			fi
			;;
		-l | --list)
			if [ "$#" = 1 ]; then
				_list_mm
			else
				_mm_error 1
			fi
			;;
		-L | --listdir)
			if [ "$#" = 1 ]; then
				_list_mm_dir
			else
				_mm_error 1
			fi
			;;
		-p | --print)
			if [ "$#" -gt 1 ]; then
				_print_mm "$@"
			else
				_mm_error 1
			fi
			;;
		-s | --set)
			if [ "$#" -gt 1 ] && [ "$#" -lt 4 ]; then
				_set_mm "$@"
			else
				_mm_error 1
			fi
			;;
		-f | --fzf)
			if [ "$#" = 1 ]; then
				_fzf_machmarks
			else
				_mm_error 1
			fi
			;;
		*)
			_mm_error 1
			;;
		esac
	else
		_print_help
	fi
}

# ZSH-specific widget creation
if [[ -n "$ZSH_VERSION" ]]; then
  # Create the widget
  fzf_machmarks_widget() {
      local result
      result=$(_fzf_machmarks)  # Capture the result from the function

      # Reset the prompt even if no selection is made
      zle reset-prompt

      if [ -n "$result" ]; then
        eval "$result"
        # append the result to LBUFFER
        LBUFFER+="$result"
      fi
  }

  # Bind the widget to CTRL+S
  zle -N fzf_machmarks_widget
  bindkey '^e' fzf_machmarks_widget
fi

# Setup completions based on the shell
if [[ -n "$ZSH_VERSION" ]]; then
	autoload -U compinit && compinit
	compdef _machmarks_zsh_complete machmarks
elif [[ -n "$BASH_VERSION" ]]; then
	complete -F _machmarks_complete machmarks
fi
