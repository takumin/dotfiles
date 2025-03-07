# vim: set ft=sh :

# if running bash
if [ -n "$BASH_VERSION" ]; then
	# include ${HOME}/.bash_profile if it exists
	if [ -r "${HOME}/.bash_profile" ]; then
		# shellcheck source=/dev/null
		source "${HOME}/.bash_profile"
	# include ${HOME}/.bashrc if it exists
	elif [ -r "${HOME}/.bashrc" ]; then
		# shellcheck source=/dev/null
		source "${HOME}/.bashrc"
	fi
fi
