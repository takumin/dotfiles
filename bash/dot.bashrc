#!/bin/bash
# vim: set ft=bash noet :

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# switch zsh
if [[ "${UID}" != 0 ]]; then
	if [[ -x "$(command -v zsh)" ]]; then
		tty -s && export SHELL="$(command -v zsh)" && exec zsh -f -c "exec - zsh"
	fi
fi

# color profile
if [[ -r "${HOME}/.bash_color" ]]; then
	source "${HOME}/.bash_color"
fi

## Default shell configuration
#
# set prompt
#
case "${UID}" in
0)
	case "${TERM}" in
	*)
		if [[ -n "${REMOTEHOST}${SSH_CONNECTION}" ]]; then
			PROMPT_COMMAND='echo -ne "\033]0;[$(whoami)@$(hostname)] $(pwd | sed "s@$HOME@\~@g")\007"'
			PS1=""
		else
			PROMPT_COMMAND='echo -ne "\033]0;[$(whoami)] $(pwd | sed "s@$HOME@\~@g")\007"'
			PS1=""
		fi
		PS2="\$ "
		;;
	screen*)
		if [[ -n "${REMOTEHOST}${SSH_CONNECTION}" ]]; then
			PROMPT_COMMAND 'echo -n -e "\033k[$(whoami)@$(hostname)][${WINDOW}] $(pwd | sed "s@$HOME@\~@g")\033\134"'
			PS1=""
		else
			PROMPT_COMMAND 'echo -n -e "\033k[$(whoami)][${WINDOW}] $(pwd | sed "s@$HOME@\~@g")\033\134"'
			PS1=""
		fi
		PS2="[${WINDOW}]\$ "
		;;
	esac
	;;
*)
	case "${TERM}" in
	*)
		if [[ -n "${REMOTEHOST}${SSH_CONNECTION}" ]]; then
			PROMPT_COMMAND='echo -ne "\033]0;[$(whoami)@$(hostname)] $(pwd | sed "s@$HOME@\~@g")\007"'
			PS1="${COLOR_FG_5FD75F}${STYLE_BOLD}[\D{%Y/%m/%d} \A]${STYLE_DEFAULT}${COLOR_FG_5FD7FF}[\u@\H]${STYLE_DEFAULT} ${COLOR_FG_FFFF87}\w${STYLE_DEFAULT}\n\$ "
		else
			PROMPT_COMMAND='echo -ne "\033]0;[$(whoami)] $(pwd | sed "s@$HOME@\~@g")\007"'
			PS1="${COLOR_FG_5FD75F}${STYLE_BOLD}[\D{%Y/%m/%d} \A]${STYLE_DEFAULT}${COLOR_FG_5FD7FF}[\u]${STYLE_DEFAULT} ${COLOR_FG_FFFF87}\w${STYLE_DEFAULT}\n\$ "
		fi
		PS2="\$ "
		;;
	screen*)
		if [[ -n "${REMOTEHOST}${SSH_CONNECTION}" ]]; then
			PROMPT_COMMAND 'echo -n -e "\033k[$(whoami)@$(hostname)][${WINDOW}] $(pwd | sed "s@$HOME@\~@g")\033\134"'
			PS1=""
		else
			PROMPT_COMMAND 'echo -n -e "\033k[$(whoami)][${WINDOW}] $(pwd | sed "s@$HOME@\~@g")\033\134"'
			PS1=""
		fi
		PS2="[${WINDOW}]\$ "
		;;
	esac
	;;
esac

## Command history configuration
#
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTIGNORE="ls:ll"
export HISTCONTROL=ignoreboth

## Alias configuration
#
if [[ -r "${HOME}/.bash_alias" ]]; then
	source "${HOME}/.bash_alias"
fi

## Completion configuration
#
# system bash completion
if ! shopt -oq posix; then
	if [[ -r "/usr/share/bash-completion/bash_completion" ]]; then
		source "/usr/share/bash-completion/bash_completion"
	elif [[ -r "/etc/bash_completion" ]]; then
		source "/etc/bash_completion"
	fi
fi
#
# homebrew completion
if [[ -x "$(command -v brew)" ]]; then
	if [[ -r "$(brew --prefix)/etc/bash_completion" ]]; then
		source "$(brew --prefix)/etc/bash_completion"
	fi
fi
#
# vault completion
if [[ -x "$(command -v vault)" ]]; then
	complete -C "$(command -v vault)" vault
fi
#
# user bash completion
if [[ -r "${HOME}/.bash_completion" ]]; then
	source "${HOME}/.bash_completion"
fi
