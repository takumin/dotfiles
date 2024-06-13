#!/usr/bin/env zsh
# vim: set ft=zsh ts=2 sw=2 sts=0 noet :

# when leaving the console clear the screen to increase privacy
if [[ "${SHLVL}" == 1 ]]; then
	if [[ -x "$(whence -- clear_console)" ]]; then
		clear_console -q
	fi
fi
