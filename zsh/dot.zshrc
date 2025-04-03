#!/usr/bin/env zsh
# vim: set ft=zsh ts=2 sw=2 sts=0 noet :



## reload .zshenv
#
source "${HOME}/.zshenv"



## vscode integration
#
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
	if [[ -x "$(whence -- code)" ]]; then
		source "$(code --locate-shell-integration-path zsh)"
	fi
fi



## jetbrains integration
#
if [[ -n "${INTELLIJ_ENVIRONMENT_READER}" ]]; then
	# Workaround
	return
fi



## alias configuration
#
[[ -r "${ZDOTDIR}/.zsh_alias" ]] && source "${ZDOTDIR}/.zsh_alias"



## coredump size
[[ ${OSTYPE} != "cygwin" ]] && limit coredumpsize 0
## new file mask
umask="022"

## auto change directory
setopt auto_cd
## auto directory pushd that you can get dirs list by cd -[tab]
setopt auto_pushd
## no arg pushd(1) to pushd ${HOME}
setopt pushd_to_home
## ignore duplication directory
setopt pushd_ignore_dups
## show 8-bit file name (e.x. japanese file name)
setopt print_eight_bit
## command correct edition before each completion attempt
setopt correct
## no remove postfix slash of command line
setopt noautoremoveslash
## suspension process on resume
setopt auto_resume
## jobs command default long prot
setopt long_list_jobs
## show control code
setopt prompt_subst



## Keybind configuration
#
# emacs like keybind (e.x. Ctrl-a goes to head of a line and Ctrl-e goes 
#   to end of it)
#
bindkey -e

# historical backward/forward search with linehead string binded to ^P/^N
#
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

# Delete Home End key
#
bindkey "^?" backward-delete-char
bindkey "^H" backward-delete-char
bindkey "^[[3~" delete-char
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line



## Command history configuration
#
if [[ "${UID}" != 0 ]]; then
	HISTFILE="${ZDOTDIR}/.zsh_history"
	HISTSIZE=10000
	SAVEHIST=10000
fi
setopt extended_history     # record date and time
setopt hist_ignore_dups     # before command to not history list
setopt hist_ignore_all_dups # delete of duplication command history list
setopt hist_ignore_space    # ignore head space command history list
setopt hist_save_no_dups    # ignore duplication command history list
setopt hist_no_store        # ignore history(1) command
setopt hist_reduce_blanks   # remove the extra space
setopt share_history        # share command history data



## Completion configuration
#
# list color
if [[ -r "${HOME}/.dir_colors" ]]; then
	if [[ -x "`whence -- dircolors`" ]]; then
		eval $(dircolors "${HOME}/.dir_colors")
	fi
fi
# menu list with window max
LISTMAX=0
# auto completion list
setopt auto_menu
# compacked complete list display
setopt list_packed
# completion list show file type
setopt list_types
# no beep sound when complete list displayed
setopt nolistbeep
# completion command "=" after
setopt magic_equal_subst
# add alias completion
setopt complete_aliases
# ignore gorups
# zstyle ':completion:*'                    group-name ''
# directory first
# zstyle ':completion:*'                    list-dirs-first true
# enable cache
zstyle ':completion:*'                    use-cache on
# cache dir
zstyle ':completion:*'                    cache-path "${ZDOTDIR}/cache"
# list of cursor select
zstyle ':completion:*:default'            menu select=1
# separator
zstyle ':completion:*'                    list-separator '-->'
# list color
zstyle ':completion:*:default'            list-colors ${(s.:.)LS_COLORS}
# ambiguous match
zstyle ':completion:*'                    matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
# cd with cdpath
zstyle ':completion:*:cd:*'               tag-order local-directories path-directories
# ignore parents
zstyle ':completion:*:cd:*'               ignore-parents parent pwd
# kill command
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*'             command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
# completer
zstyle ':completion:*'                    completer _complete _ignored
# compinstall
zstyle :compinstall                       filename "${ZDOTDIR}/.zshrc"



## completion
#
# compinit
autoload -Uz compinit && compinit -u
# bashcompinit
autoload -U +X bashcompinit && bashcompinit



## zsh editor
#
autoload -Uz zed



## set prompt
#
if [[ -x "$(whence -- starship)" ]]; then
	eval "$(starship init zsh)"
else
	autoload -Uz promptinit
	promptinit
	prompt adam1
fi



# set terminal title including current directory
#
case "${TERM}" in
kterm*|xterm*)
	precmd() {
		echo -ne "\033];${USER}@${HOST%%.*} ${PWD}\007"
	}
	;;
screen*)
	precmd() {
		echo -ne "\033P\033]0;${USER}@${HOST} ${PWD}\007\033\\"
		echo -ne "\033k[`basename ${PWD}`]\033\\"
	}
	;;
esac



# `cd` after auto  `ls`
#
chpwd() {
	ls
}



# loading sheldon plugins
#
if [[ -x "$(whence -- sheldon)" ]]; then
	eval "$(sheldon source)"
fi



## reload .zshenv
#
[[ -r "${ZDOTDIR}/.zsh_completion" ]] && source "${ZDOTDIR}/.zsh_completion"



## load user .zshrc configuration file
#
[[ -r "${ZDOTDIR}/.zshrc.local" ]] && source "${ZDOTDIR}/.zshrc.local"
