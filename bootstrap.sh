#!/usr/bin/env bash

set -euo pipefail

OS="$(uname -s | tr "[:upper:]" "[:lower:]")"
ARCH="$(uname -m)"

MITAMAE_VERSION="v1.14.2"
MITAMAE_URL="https://github.com/itamae-kitchen/mitamae/releases/download/${MITAMAE_VERSION}/mitamae-${ARCH}-${OS}"

################################################################################
# mitamae
################################################################################

# user bin dir
if [[ ! -d "$HOME/.usr/bin" ]]; then
	mkdir -p "$HOME/.usr/bin"
fi

# user bin path
if [[ ":$PATH:" != *":$HOME/.usr/bin:"* ]]; then
	export PATH="$HOME/.usr/bin:$PATH"
fi

# install mitamae
if [[ ! -f "$HOME/.usr/bin/mitamae" ]]; then
	if [[ -x "$(command -v curl)" ]]; then
		CMD="curl"
		ARG=("-fsSL" "-o" "$HOME/.usr/bin/mitamae")
	elif [[ -x "$(command -v wget)" ]]; then
		CMD="wget"
		ARG=("-q" "-O" "$HOME/.usr/bin/mitamae")
	else
		echo 'required curl or wget'
		exit 1
	fi

	echo "Download mitamae ${MITAMAE_VERSION}"
	"${CMD}" "${ARG[@]}" "${MITAMAE_URL}"
fi

# permission mitamae
if [[ ! -x "$HOME/.usr/bin/mitamae" ]]; then
	chmod +x "$HOME/.usr/bin/mitamae"
fi

################################################################################
# dotfiles
################################################################################

# ghq dir
if [[ ! -d "$HOME/.usr/src/github.com/takumin" ]]; then
	mkdir -p "$HOME/.usr/src/github.com/takumin"
fi

# clone repository
if [[ ! -f "$HOME/.usr/src/github.com/takumin/dotfiles/.git/HEAD" ]]; then
	git clone -q "https://github.com/takumin/dotfiles.git" "$HOME/.usr/src/github.com/takumin/dotfiles"
fi

# symlink dotfiles
if [[ ! -L "$HOME/.dotfiles" ]]; then
	ln -s ".usr/src/github.com/takumin/dotfiles" "$HOME/.dotfiles"
fi

################################################################################
# homebrew
################################################################################

# install homebrew
if [[ ! -x "$(command -v brew)" ]]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# shellenv homebrew
case "${OS}" in
linux)
	if [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	fi
	;;
darwin)
	if [[ -x "/opt/homebrew/bin/brew" ]]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	elif [[ -x "/usr/local/bin/brew" ]]; then
		eval "$(/usr/local/bin/brew shellenv)"
	fi
	;;
*)
	echo 'unsupported os type'
	exit 1
	;;
esac

# bundle homebrew
if ! brew bundle check >/dev/null 2>&1; then
	brew bundle install
fi
