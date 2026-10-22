#!/usr/bin/env zsh
# vim: set ft=zsh ts=2 sw=2 sts=0 noet :

## compile startup files in the background
#
# zsh only picks up <file>.zwc right next to the file it reads, so the compiled
# startup files stay beside them; only the completion dump lives in cache
{
	autoload -Uz zrecompile
	for zfile in \
		"${HOME}/.zshenv" \
		"${ZDOTDIR}"/.{zshenv,zprofile,zshrc,zlogin,zlogout,zsh_alias,zsh_completion}(N) \
		"${ZDOTDIR}/cache/zcompdump"(N) \
	; do
		zrecompile -pq "${zfile}"
	done
} &!
