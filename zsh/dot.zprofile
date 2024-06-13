#!/usr/bin/env zsh
# vim: set ft=zsh ts=2 sw=2 sts=0 noet :

## vscode
#
if [[ -n "${VSCODE_PID}" ]]; then
	if [[ "${TERM_PROGRAM}" != "vscode" ]]; then
		return
	fi
fi

## secretive
#
if [[ -e "${HOME}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh" ]]; then
	export SSH_AUTH_SOCK="${HOME}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"
fi

## ssh-tpm-agent
#
if [[ -x "$(whence -- ssh-tpm-agent)" ]]; then
	if [[ -e "$(ssh-tpm-agent --print-socket)" ]]; then
		export SSH_AUTH_SOCK="$(ssh-tpm-agent --print-socket)"
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

## tmux
#
if [[ -x "$(whence -- tmux)" ]]; then
	if [[ -z "${TMUX}" ]]; then
		case "$TERM" in
			mlterm*)    args="-2u" && export TERM_PROGRAM="mlterm" ;;
			*256color)  args="-2u" ;;
			*)          args="-u"  ;;
		esac

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
	if [[ -z "${TMUX}" ]]; then
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
