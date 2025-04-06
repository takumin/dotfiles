#!/usr/bin/env zsh
# vim: set ft=zsh ts=2 sw=2 sts=0 noet :

## vscode
#
if [[ -n "${VSCODE_PID}" ]]; then
	if [[ "${TERM_PROGRAM}" != "vscode" ]]; then
		return
	fi
fi

## 1password
#
if [[ -z "${SSH_CONNECTION}" ]]; then
	# for macos
	if [[ -r "${HOME}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" ]]; then
		export SSH_AUTH_SOCK="${HOME}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
	fi
	# for linux
	if [[ -r "${HOME}/.1password/agent.sock" ]]; then
		export SSH_AUTH_SOCK="${HOME}/.1password/agent.sock"
	fi
	# for wsl2
	if [[ -r "${HOME}/.ssh/agent.sock" ]]; then
		export SSH_AUTH_SOCK="${HOME}/.ssh/agent.sock"
	fi
fi

## secretive
#
if [[ -z "${SSH_AUTH_SOCK}" ]]; then
	if [[ -e "${HOME}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh" ]]; then
		export SSH_AUTH_SOCK="${HOME}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"
	fi
fi

## keychain
#
if [[ -z "${SSH_AUTH_SOCK}" ]]; then
	if [[ -x "$(whence -- keychain)" ]]; then
		if [[ -r "${HOME}/.ssh/id_ed25519" ]]; then
			keychain -q "${HOME}/.ssh/id_ed25519"
		fi
		if [[ -r "${HOME}/.ssh/id_rsa" ]]; then
			keychain -q "${HOME}/.ssh/id_rsa"
		fi
		for key in "$(find ${HOME}/.ssh -type f -name '*.key')"; do
			keychain -q "${key}"
		done
		if [[ -r "${HOME}/.keychain/${HOST}-sh" ]]; then
			source "${HOME}/.keychain/${HOST}-sh"
		fi
		if [[ -r "${HOME}/.keychain/${HOST}-sh-gpg" ]]; then
			source "${HOME}/.keychain/${HOST}-sh-gpg"
		fi
	fi
fi

## zellij
#
# TODO: The key binding settings overlap with zsh and neovim, so comment them out until the adjustments are complete.
# if [[ -x "$(whence -- zellij)" ]]; then
# 	if [[ -z "$ZELLIJ" && -z "${TMUX}" ]]; then
# 		exec zellij attach -c default
# 		exit
# 	fi
# fi

## tmux
#
if [[ -x "$(whence -- tmux)" ]]; then
	if [[ -z "$ZELLIJ" && -z "${TMUX}" ]]; then
		case "$TERM" in
			mlterm*)    args="-2u" && export TERM_PROGRAM="mlterm" ;;
			*256color)  args="-2u" ;;
			*)          args="-u"  ;;
		esac

		# see also: https://github.com/hamano/locale-eaw/tree/master/fixtmux
		if [[ -f "${HOME}/.usr/lib/fixtmux.so" ]]; then
			export LD_PRELOAD="${HOME}/.usr/lib/fixtmux.so"
		fi

		if $(tmux has-session >/dev/null 2>&1); then
			exec tmux "$args" attach
		else
			exec tmux "$args"
		fi
	fi
fi

## screen
#
if [[ -x "$(whence -- screen)" ]]; then
	if [[ -z "$ZELLIJ" && -z "${TMUX}" ]]; then
		case "$TERM" in
			mlterm*)    args="-T screen-256color -S main -U -xRR" && export TERM_PROGRAM="mlterm" ;;
			*256color)  args="-T screen-256color -S main -U -xRR" ;;
			*)          args="-S main -U -xRR"  ;;
		esac

		if $(screen -list >/dev/null 2>&1); then
			exec screen "$args"
		fi
	fi
fi
