#!/bin/bash
# vim: set ft=bash noet :

## Path Configuration
#

if [[ -d "/usr/local/sbin" ]]; then
	export PATH="/usr/local/sbin:${PATH}"
fi

if [[ -d "/usr/local/bin" ]]; then
	export PATH="/usr/local/bin:${PATH}"
fi

if [[ -d "${HOME}/.usr/bin" ]]; then
	export PATH="${HOME}/.usr/bin:${PATH}"
fi

if [[ -d "${HOME}/.local/bin" ]]; then
	export PATH="${HOME}/.local/bin:${PATH}"
fi

if [[ -d "${HOME}/.cargo/bin" ]]; then
	export PATH="${HOME}/.cargo/bin:${PATH}"
fi

## Homebrew on Linux
#

if [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

## Language configuration
#
export LANG="ja_JP.UTF-8"
export LC_CTYPE="ja_JP.UTF-8"
export LC_COLLATE="ja_JP.UTF-8"
export LC_TIME="ja_JP.UTF-8"
export LC_NUMERIC="ja_JP.UTF-8"
export LC_MONETARY="ja_JP.UTF-8"
export LC_MESSAGES="ja_JP.UTF-8"
export LC_ALL="ja_JP.UTF-8"
export LANGUAGE="ja_JP.UTF-8"

## Timezone configuration
#
export TZ="JST-9"

## size of block
#
export BLOCKSIZE="K"

## editor of vim(1) or vi(1)
#
if [[ -x "$(command -v vim)" ]]; then
	export EDITOR="vim"
	export VISUAL="vim"
else
	export EDITOR="vi"
	export VISUAL="vi"
fi

## pager of lv(1) or jless(1) or less(1) or more(1)
#
if [[ -x "$(command -v lv)" ]]; then
	export PAGER="lv"
elif [[ -x "$(command -v jless)" ]]; then
	export PAGER="jless"
elif [[ -x "$(command -v less)" ]]; then
	export PAGER="less"
else
	export PAGER="more"
fi

## ls(1) color configuration
#
case "${OSTYPE}" in
freebsd* | darwin*)
	export LSCOLORS="gxfxcxdxbxegedabagacad"
	;;
*)
	if [[ -x "$(command -v dircolors)" ]]; then
		if [[ -r "${HOME}/.dircolors" ]]; then
			eval "$(dircolors -b "${HOME}/.dircolors")"
		else
			eval "$(dircolors -b)"
		fi
	else
		export LS_COLORS="di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30"
	fi
	;;
esac

## less(1) or jless(1) configuration
#
if [[ -x "$(command -v less)" ]] || [[ -x "$(command -v jless)" ]]; then
	# command line option
	#export LESS="-r"
	# ignore history file
	export LESSHISTFILE="-"
	# charset encoding
	#export LESSCHARSET="utf-8"
fi

## lv(1) configuration
#
if [[ -x "$(command -v lv)" ]]; then
	export LV="-la -Ou8 -c"
fi

## set ${REMOTEHOST} of remote client connection address
#
if [[ -n "${REMOTEHOST}${SSH_CONNECTION}" ]]; then
	REMOTEHOST="$(echo "${SSH_CLIENT}" | cut -d " " -f 1)"
	export REMOTEHOST
fi

## include ${HOME}/.bashrc if it exists
#
if [[ -r "${HOME}/.bashrc" ]]; then
	# shellcheck source=/dev/null
	source "${HOME}/.bashrc"
fi
