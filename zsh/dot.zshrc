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



## search manual path
#



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
if [[ -z "${POWERLINE_COMMAND}" ]]; then
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

	if [[ -d "${PWD}/.bundle/bin" ]]; then
		path=(${PWD}/.bundle/bin $path)
	fi
}



# load zsh-autosuggestions
#
if [[ -r "${ZDOTDIR}/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
	source "${ZDOTDIR}/zsh-autosuggestions/zsh-autosuggestions.zsh"
	export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=240"
fi
# load zsh-syntax-highlighting
#
if [[ -r "${ZDOTDIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
	source "${ZDOTDIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
	# bindkey '[A' history-substring-search-up
	# bindkey '[B' history-substring-search-down
	# bindkey -M emacs '^P' history-substring-search-up
	# bindkey -M emacs '^N' history-substring-search-down
	# bindkey -M vicmd 'k' history-substring-search-up
	# bindkey -M vicmd 'j' history-substring-search-down
fi
# load zsh-history-substring-search
#
if [[ -r "${ZDOTDIR}/zsh-history-substring-search/zsh-history-substring-search.zsh" ]]; then
	source "${ZDOTDIR}/zsh-history-substring-search/zsh-history-substring-search.zsh"
fi
# load zload
#
if [[ -r "${ZDOTDIR}/zload/zload" ]]; then
	autoload -Uz zload
fi
# aws-cli completion
#
if [[ -r "`whence -- aws_zsh_completer.sh`" ]]; then
	source "`whence -- aws_zsh_completer.sh`"
fi
# golang initilize
#
if [[ -r "/usr/local/share/zsh/site-functions/go" ]]; then
	source "/usr/local/share/zsh/site-functions/go"
fi
# golangci-lint completion
#
if [[ -x "`whence -- golangci-lint`" ]]; then
	source <(golangci-lint completion zsh)
fi
# direnv initilize
#
if [[ -x "`whence -- direnv`" ]]; then
	eval "$(direnv hook zsh)"
fi
# lefthook completion
#
if [[ -x "$(whence -- lefthook)" ]]; then
	source <(lefthook completion zsh)
fi
# anyenv initilize
#
if [[ -x "$(whence -- anyenv)" ]]; then
	eval "$(anyenv init -)"
fi
# goenv initilize
#
if [[ -x "$(whence -- goenv)" ]]; then
	eval "$(goenv init -)"
	path=(
		${GOROOT}/bin(N-/)
		"$path[@]"(N)
		${GOPATH}/bin(N-/)
	)
	typeset -U path
fi
# rustup initilize
#
if [[ -x "$(whence -- rustup)" ]]; then
	source <(rustup completions zsh)
fi
# travis ci completion
#
if [[ -r "${HOME}/.travis/travis.sh" ]]; then
	source "${HOME}/.travis/travis.sh"
fi
# kubectl completion
#
if [[ -x "`whence -- kubectl`" ]]; then
	source <(kubectl completion zsh)
fi
# kubeadm completion
#
if [[ -x "`whence -- kubeadm`" ]]; then
	source <(kubeadm completion zsh)
fi
# minikube completion
#
if [[ -x "`whence -- minikube`" ]]; then
	source <(minikube completion zsh)
fi
# docker completion
#
if [[ -x "$(whence -- docker)" ]]; then
	source <(docker completion zsh)
fi
# vault completion
#
if [[ -x "$(whence -- vault)" ]]; then
	complete -o nospace -C "$(whence -- vault)" vault
fi
# terraform completion
#
if [[ -x "$(whence -- terraform)" ]]; then
	complete -o nospace -C "$(whence -- terraform)" terraform
fi
# opentofu completion
#
if [[ -x "$(whence -- tofu)" ]]; then
	complete -o nospace -C "$(whence -- tofu)" tofu
fi
# nomad completion
#
if [[ -x "$(whence -- nomad)" ]]; then
	complete -o nospace -C "$(whence -- nomad)" nomad
fi
# aqua completion
#
if [[ -x "$(whence -- aqua)" ]]; then
	source <(aqua completion zsh)
fi
# 1password-cli completion
#
if [[ -x "$(whence -- op)" ]]; then
	source <(op completion zsh)
	compdef _op op
fi
# lima completion
#
if [[ -x "$(whence -- limactl)" ]]; then
	source <(limactl completion zsh)
	compdef _limactl limactl
fi
# linuxkit completion
#
if [[ -x "$(whence -- linuxkit)" ]]; then
	source <(linuxkit completion zsh)
	compdef _linuxkit linuxkit
fi
# oras completion
#
if [[ -x "$(whence -- oras)" ]]; then
	source <(oras completion zsh)
	compdef _oras oras
fi
# hugo completion
#
if [[ -x "$(whence -- hugo)" ]]; then
	if completion="$(hugo completions zsh 2>/dev/null)"; then
		source <(echo "${completion}") 2>/dev/null
		compdef _hugo hugo
	fi
fi
# yq completion
#
if [[ -x "$(whence -- yq)" ]]; then
	if completion="$(yq shell-completion zsh 2>/dev/null)"; then
		source <(echo "${completion}")
		compdef _yq yq
	fi
fi
# deno completion
#
if [[ -x "$(whence -- deno)" ]]; then
	if completion="$(deno completions zsh 2>/dev/null)"; then
		source <(echo "${completion}") 2>/dev/null
		compdef _deno deno
	fi
fi
# aws-nuke completion
#
if [[ -x "$(whence -- aws-nuke)" ]]; then
	if completion="$(aws-nuke completion zsh 2>/dev/null)"; then
		source <(echo "${completion}")
		compdef _aws-nuke aws-nuke
	fi
fi
# goreleaser completion
#
if [[ -x "$(whence -- goreleaser)" ]]; then
	if completion="$(goreleaser completion zsh 2>/dev/null)"; then
		source <(echo "${completion}")
		compdef _goreleaser goreleaser
	fi
fi
# nfpm completion
#
if [[ -x "$(whence -- nfpm)" ]]; then
	if completion="$(nfpm completion zsh 2>/dev/null)"; then
		source <(echo "${completion}")
		compdef _nfpm nfpm
	fi
fi
# trivy completion
#
if [[ -x "$(whence -- trivy)" ]]; then
	if completion="$(trivy completion zsh 2>/dev/null)"; then
		source <(echo "${completion}")
		compdef _trivy trivy
	fi
fi
# octocov completion
#
if [[ -x "$(whence -- octocov)" ]]; then
	if completion="$(octocov completion zsh 2>/dev/null)"; then
		source <(echo "${completion}")
		compdef _octocov octocov
	fi
fi
# dagger completion
#
if [[ -x "$(whence -- dagger)" ]]; then
	if completion="$(dagger completion zsh 2>/dev/null)"; then
		source <(echo "${completion}")
		compdef _dagger dagger
	fi
fi
# melange completion
#
if [[ -x "$(whence -- melange)" ]]; then
	if completion="$(melange completion zsh 2>/dev/null)"; then
		source <(echo "${completion}")
		compdef _melange melange
	fi
fi
# gotpm completion
#
if [[ -x "$(whence -- gotpm)" ]]; then
	if completion="$(gotpm completion zsh 2>/dev/null)"; then
		source <(echo "${completion}")
		compdef _gotpm gotpm
	fi
fi
# runpodctl completion
#
if [[ -x "$(whence -- runpodctl)" ]]; then
	if completion="$(runpodctl completion zsh 2>/dev/null)"; then
		source <(echo "${completion}")
		compdef _runpodctl runpodctl
	fi
fi
# aws_completer completion
#
if [[ -x "$(whence -- aws_completer)" ]]; then
	complete -C "$(whence -- aws_completer)" aws
fi
# python pip completion
#
# if [[ -x "`whence -- pip`" ]]; then
# 	eval "`pip completion --zsh --disable-pip-version-check`"
# fi
# if [[ -x "`whence -- pip3`" ]]; then
# 	eval "`pip3 completion --zsh --disable-pip-version-check`"
# fi
# powerline configuration
if [[ -x "`whence -- python`" ]] || [[ -x "`whence -- python3`" ]] ; then
	if [[ -r "${powerline_python_path}/powerline/bindings/zsh/powerline.zsh" ]]; then
		source "${powerline_python_path}/powerline/bindings/zsh/powerline.zsh"
	fi
fi
# vagrant completion
#
if [[ -d "/opt/vagrant/embedded/gems/gems" ]]; then
	if f=(/opt/vagrant/embedded/gems/gems/vagrant-*/contrib/zsh/_vagrant) 2>/dev/null; then
		source $f
		compdef _vagrant vagrant
	fi
fi
# dotnet completion
#
_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")
  reply=("${(ps:\n:)completions}")
}
if [[ -x "$(whence -- dotnet)" ]]; then
	compctl -K _dotnet_zsh_complete dotnet
fi
# gcloud completion
#
if [[ -r "/usr/share/google-cloud-sdk/completion.zsh.inc" ]]; then
	source "/usr/share/google-cloud-sdk/completion.zsh.inc"
fi
# pnpm completion
#
if [[ -x "$(whence -- pnpm)" ]]; then
	# recommends pnpm-shell-completion
	# see also: https://github.com/g-plane/pnpm-shell-completion
	if [[ -r "/usr/local/share/zsh/site-functions/_pnpm" ]]; then
		source "/usr/local/share/zsh/site-functions/_pnpm"
	fi

	alias pp="pnpm"
	alias ppx="pnpx"
	compdef pp="pnpm"
fi


## load user .zshrc configuration file
#
[[ -r "${ZDOTDIR}/.zshrc.local" ]] && source "${ZDOTDIR}/.zshrc.local"
