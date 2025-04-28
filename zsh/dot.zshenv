#!/usr/bin/env zsh
# vim: set ft=zsh ts=2 sw=2 sts=0 noet :

## Machine architecture
#
ARCH="$(uname -m)"

## Linuxbrew environment variables
#
case "${OSTYPE}" in
	linux*)
		if [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
			eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
		fi
		;;
esac

## Execute path configuration
#
path=(
	${HOME}/.local/sbin(N-/)
	${HOME}/.local/bin(N-/)
	${HOME}/.usr/sbin(N-/)
	${HOME}/.usr/bin(N-/)
	${HOME}/.opt/*/sbin(N-/)
	${HOME}/.opt/*/bin(N-/)
	${HOME}/.anyenv/bin(N-/)
	${HOME}/.anyenv/envs/*/bin(N-/)
	${HOME}/.anyenv/envs/*/shims(N-/)
	${HOME}/.local/share/mise/shims(N-/)
	${HOME}/.local/share/aquaproj-aqua/bin(N-/)
	${HOME}/.nix-profile/bin(N-/)
	${HOME}/.local/share/pnpm(N-/)
	${HOME}/.yarn/bin(N-/)
	${HOME}/.config/yarn/global/node_modules/.bin(N-/)
	${HOME}/.gem/ruby/*/bin(N-/)
	${HOME}/.miniconda3/bin(N-/)
	${HOME}/.cargo/bin(N-/)
	${HOME}/.go/bin(N-/)
	${HOME}/.goenv/bin(N-/)
	${HOME}/.tfenv/bin(N-/)
	${HOME}/.deno/bin(N-/)
	${HOME}/.dotnet/tools(N-/)
	${HOME}/Android/Sdk/cmdline-tools/bin(N-/)
	"${HOME}/Library/Application Support/JetBrains/Toolbox/scripts"(N-/)
	/nix/var/nix/profiles/default/bin(N-/)
	/home/linuxbrew/.linuxbrew/opt/ccache/libexec(N-/)
	/home/linuxbrew/.linuxbrew/bin(N-/)
	/home/linuxbrew/.linuxbrew/lib/ruby/gems/*/bin(N-/)
	/usr/local/opt/coreutils/bin(N-/)
	/usr/local/opt/llvm/bin(N-/)
	/usr/local/libexec/ccache(N-/)
	/usr/local/*/sbin(N-/)
	/usr/local/*/bin(N-/)
	/usr/local/sbin(N-/)
	/usr/local/bin(N-/)
	/opt/homebrew/opt/libtool/libexec/gnubin(N-/)
	/opt/homebrew/opt/ruby/bin(N-/)
	/opt/*/sbin(N-/)
	/opt/*/bin(N-/)
	/opt/sbin(N-/)
	/opt/bin(N-/)
	/snap/bin(N-/)
	/usr/lib/ccache/bin(N-/)
	/usr/lib/ccache(N-/)
	/usr/sbin(N-/)
	/usr/bin(N-/)
	/sbin(N-/)
	/bin(N-/)
	/usr/local/games(N-/)
	/usr/games(N-/)
	"$path[@]"(N)
)
typeset -U path

## Manpages path configuration
#
manpath=(
	${HOME}/.local/share/man/ja(N-/)
	${HOME}/.local/share/man(N-/)
	${HOME}/.local/man/ja(N-/)
	${HOME}/.local/man(N-/)
	${HOME}/.usr/share/man/ja(N-/)
	${HOME}/.usr/share/man(N-/)
	${HOME}/.usr/man/ja(N-/)
	${HOME}/.usr/man(N-/)
	/home/linuxbrew/.linuxbrew/share/man/ja(N-/)
	/home/linuxbrew/.linuxbrew/share/man(N-/)
	/usr/local/*/share/man/ja(N-/)
	/usr/local/*/share/man(N-/)
	/usr/local/*/man/ja(N-/)
	/usr/local/*/man(N-/)
	/usr/local/share/man/ja(N-/)
	/usr/local/share/man(N-/)
	/usr/local/man/ja(N-/)
	/usr/local/man(N-/)
	/opt/*/share/man/ja(N-/)
	/opt/*/share/man(N-/)
	/opt/*/man/ja(N-/)
	/opt/*/man(N-/)
	/opt/share/man/ja(N-/)
	/opt/share/man(N-/)
	/opt/man/ja(N-/)
	/opt/man(N-/)
	/usr/man/ja(N-/)
	/usr/man(N-/)
	/usr/share/man/ja(N-/)
	/usr/share/man(N-/)
	"$manpath[@]"(N)
)
typeset -U manpath

## Zsh function path configuration
#
fpath=(
	${ZDOTDIR}/completions(N-/)
	${HOME}/.rustup/toolchains/*/share/zsh/site-functions(N-/)
	/home/linuxbrew/.linuxbrew/share/zsh-completions(N-/)
	/home/linuxbrew/.linuxbrew/share/zsh/site-functions(N-/)
	/opt/homebrew/share/zsh/site-functions(N-/)
	/opt/vagrant/embedded/gems/*/gems/vagrant-*/contrib/zsh(N-/)
	/usr/local/share/zsh/site-functions(N-/)
	/usr/local/share/zsh-completions(N-/)
	/usr/share/zsh/vendor-completions(N-/)
	"$fpath[@]"(N)
)
typeset -U fpath

## Run library path configuration
#
# typeset -xT LD_RUN_PATH ld_run_path
# ld_run_path=(
# 	${HOME}/.local/lib(N-/)
# 	${HOME}/.local/lib64(N-/)
# 	${HOME}/.local/lib32(N-/)
# 	${HOME}/.usr/lib(N-/)
# 	${HOME}/.usr/lib64(N-/)
# 	${HOME}/.usr/lib32(N-/)
# 	# /home/linuxbrew/.linuxbrew/opt/*/lib(N-/)
# 	# /home/linuxbrew/.linuxbrew/lib(N-/)
# 	/usr/local/*/lib(N-/)
# 	/usr/local/*/lib64(N-/)
# 	/usr/local/*/lib32(N-/)
# 	/usr/local/lib(N-/)
# 	/usr/local/lib64(N-/)
# 	/usr/local/lib32(N-/)
# 	/opt/*/lib(N-/)
# 	/opt/*/lib64(N-/)
# 	/opt/*/lib32(N-/)
# 	/opt/lib(N-/)
# 	/opt/lib64(N-/)
# 	/opt/lib32(N-/)
# 	/usr/lib(N-/)
# 	/usr/lib64(N-/)
# 	/usr/lib32(N-/)
# 	/lib(N-/)
# 	/lib64(N-/)
# 	/lib32(N-/)
# )
# typeset -U ld_run_path

## Search library path configuration
#
# typeset -xT LD_LIBRARY_PATH ld_library_path
# ld_library_path=(
# 	${HOME}/.local/lib(N-/)
# 	${HOME}/.local/lib64(N-/)
# 	${HOME}/.local/lib32(N-/)
# 	${HOME}/.usr/lib(N-/)
# 	${HOME}/.usr/lib64(N-/)
# 	${HOME}/.usr/lib32(N-/)
# 	# /home/linuxbrew/.linuxbrew/opt/*/lib(N-/)
# 	# /home/linuxbrew/.linuxbrew/lib(N-/)
# 	/usr/local/*/lib(N-/)
# 	/usr/local/*/lib64(N-/)
# 	/usr/local/*/lib32(N-/)
# 	/usr/local/lib(N-/)
# 	/usr/local/lib64(N-/)
# 	/usr/local/lib32(N-/)
# 	/opt/*/lib(N-/)
# 	/opt/*/lib64(N-/)
# 	/opt/*/lib32(N-/)
# 	/opt/lib(N-/)
# 	/opt/lib64(N-/)
# 	/opt/lib32(N-/)
# 	/usr/lib(N-/)
# 	/usr/lib64(N-/)
# 	/usr/lib32(N-/)
# 	/lib(N-/)
# 	/lib64(N-/)
# 	/lib32(N-/)
# )
# typeset -U ld_library_path

## C/C++ include path configuration
#
# typeset -xT CPATH cpath
# cpath=(
# 	${HOME}/.local/include(N-/)
# 	${HOME}/.usr/include(N-/)
# 	# /home/linuxbrew/.linuxbrew/opt/*/include(N-/)
# 	# /home/linuxbrew/.linuxbrew/include(N-/)
# 	/usr/local/*/include(N-/)
# 	/usr/local/include(N-/)
# 	/opt/*/include(N-/)
# 	/opt/include(N-/)
# 	/usr/include(N-/)
# )
# typeset -U cpath

## library path configuration
#
# ldflags=()
# if [[ -d "/opt/homebrew/opt/ruby/lib" ]]; then
# 	ldflags+=("-L/opt/homebrew/opt/ruby/lib")
# fi
# typeset -xTU LDFLAGS ldflags

## preprocess path configuration
#
# cppflags=()
# if [[ -d "/opt/homebrew/opt/ruby/include" ]]; then
# 	cppflags+=("-I/opt/homebrew/opt/ruby/include")
# fi
# typeset -xTU CPPFLAGS cppflags

## pkg-config path configuration
#
typeset -xT PKG_CONFIG_PATH pkg_config_path
pkg_config_path=(
	# ${HOME}/.local/share/pkgconfig(N-/)
	# ${HOME}/.local/libdata/pkgconfig(N-/)
	# ${HOME}/.local/lib/pkgconfig(N-/)
	# ${HOME}/.local/lib64/pkgconfig(N-/)
	# ${HOME}/.local/lib32/pkgconfig(N-/)
	# ${HOME}/.usr/share/pkgconfig(N-/)
	# ${HOME}/.usr/libdata/pkgconfig(N-/)
	# ${HOME}/.usr/lib/pkgconfig(N-/)
	# ${HOME}/.usr/lib64/pkgconfig(N-/)
	# ${HOME}/.usr/lib32/pkgconfig(N-/)
	# /home/linuxbrew/.linuxbrew/opt/*/lib/pkgconfig(N-/)
	# /home/linuxbrew/.linuxbrew/lib/pkgconfig(N-/)
	# /opt/*/share/pkgconfig(N-/)
	# /opt/*/libdata/pkgconfig(N-/)
	# /opt/*/lib/pkgconfig(N-/)
	# /opt/*/lib64/pkgconfig(N-/)
	# /opt/*/lib32/pkgconfig(N-/)
	# /opt/share/pkgconfig(N-/)
	# /opt/libdata/pkgconfig(N-/)
	# /opt/lib/pkgconfig(N-/)
	# /opt/lib64/pkgconfig(N-/)
	# /opt/lib32/pkgconfig(N-/)
	/usr/local/*/share/pkgconfig(N-/)
	/usr/local/*/lib/${ARCH}-linux-gnu/pkgconfig(N-/)
	/usr/local/*/lib/pkgconfig(N-/)
	/usr/local/*/libdata/pkgconfig(N-/)
	/usr/local/*/lib64/pkgconfig(N-/)
	/usr/local/*/lib32/pkgconfig(N-/)
	/usr/local/share/pkgconfig(N-/)
	/usr/local/lib/x86_64-linux-gnu/pkgconfig(N-/)
	/usr/local/lib/aarch64-linux-gnu/pkgconfig(N-/)
	/usr/local/lib/pkgconfig(N-/)
	/usr/local/libdata/pkgconfig(N-/)
	/usr/local/lib64/pkgconfig(N-/)
	/usr/local/lib32/pkgconfig(N-/)
	/usr/share/pkgconfig(N-/)
	/usr/lib/${ARCH}-linux-gnu/pkgconfig(N-/)
	/usr/lib/pkgconfig(N-/)
	/usr/libdata/pkgconfig(N-/)
	/usr/lib64/pkgconfig(N-/)
	/usr/lib32/pkgconfig(N-/)
)
typeset -U pkg_config_path

## cmake path configuration
#
# typeset -xT CMAKE_MODULE_PATH cmake_module_path
# cmake_module_path=(
# 	${HOME}/.local/share/cmake(N-/)
# 	${HOME}/.local/cmake(N-/)
# 	${HOME}/.usr/share/cmake(N-/)
# 	${HOME}/.usr/cmake(N-/)
# 	${HOME}/.cmake(N-/)
# 	# /home/linuxbrew/.linuxbrew/share/cmake(N-/)
# 	/usr/local/*/share/cmake(N-/)
# 	/usr/local/share/cmake(N-/)
# 	/opt/*/share/cmake(N-/)
# 	/opt/share/cmake(N-/)
# )
# typeset -U cmake_module_path

## ccache path configuration
#
# typeset -xT CCACHE_PATH ccache_path
# ccache_path=(
# 	${HOME}/.local/bin(N-/)
# 	${HOME}/.usr/bin(N-/)
# 	/home/linuxbrew/.linuxbrew/bin(N-/)
# 	/usr/local/bin(N-/)
# 	/usr/bin(N-/)
# 	/bin(N-/)
# )
# typeset -U ccache_path

## cdpath
#
cdpath=(
	${HOME}/.usr/src/*(N-/)
	${HOME}/.go/src/*(N-/)
	${HOME}/.ghq/*(N-/)
	${HOME}
)
typeset -U cdpath

## ZDOTDIR directory
#
if [[ -d "${HOME}/.zsh" ]]; then
	export ZDOTDIR="${HOME}/.zsh"
	if [[ -x "$(whence -- code)" ]]; then
		export USER_ZDOTDIR="${HOME}/.zsh"
	fi
fi

## OS Release configuration
#
if [[ -r "/etc/lsb-release" ]]; then
	source "/etc/lsb-release"
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
export TZ="Asia/Tokyo"

## size of block
#
export BLOCKSIZE="K"

## ftp passive mode
#
export FTP_PASSIVE_MODE="Y"

## use ccache
#
if [[ -x "$(whence -- ccache)" ]]; then
	export CCACHE_DIR="${HOME}/.ccache"
fi

## editor of nvim(1) or vim(1) or vi(1)
#
if [[ -x "$(whence -- nvim)" ]]; then
	export EDITOR="nvim"
	export VISUAL="nvim"
elif [[ -x "$(whence -- vim)" ]]; then
	export EDITOR="vim"
	export VISUAL="vim"
else
	export EDITOR="vi"
	export VISUAL="vi"
fi

## pager of less(1) or more(1)
#
# if [[ -x "$(whence -- less)" ]]; then
# 	export PAGER="less"
# else
# 	export PAGER="more"
# fi

## man configuration
#
# if [[ -x "$(whence -- less)" ]]; then
# 	export MANPAGER="less"
# else
# 	export MANPAGER="more"
# fi

## bsd ls(1) color configuration
#
case "${OSTYPE}" in
freebsd*|darwin*) export LSCOLORS="gxfxcxdxbxegedabagacad" ;;
esac

## gnu ls(1) color configuration
#
if [[ -x "$(whence -- vivid)" ]]; then
	export LS_COLORS="$(vivid generate tokyonight-night)"
elif [[ -x "$(whence -- dircolors)" ]]; then
	if [[ -r "${HOME}/.dircolors-solarized/dircolors.256dark" ]]; then
		eval "$(dircolors -b ${HOME}/.dircolors-solarized/dircolors.256dark)"
	elif [[ -r "${HOME}/.dircolors" ]]; then
		eval "$(dircolors -b ${HOME}/.dircolors)"
	else
		eval "$(dircolors -b)"
	fi
else
	export LS_COLORS="di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30"
fi

## less(1) configuration
#
if [[ -x "$(whence -- less)" ]]; then
	# command line option
	#export LESS="-r"
	# ignore history file
	# export LESSHISTFILE="${HOME}/.lesshst"
	# charset encoding
	#export LESSCHARSET="utf-8"
	# filter program
	if [[ -x "$(whence -- lesspipe.sh)" ]]; then
		export LESSOPEN="|$(whence -- lesspipe.sh) %s"
	fi
fi

## mail configuration
#
if [[ -r "${HOME}/.mailrc" ]]; then
	export MAILRC="${HOME}/.mailrc"
fi

## mailer agent
#
if [[ -x "$(whence -- msmtp)" ]]; then
	export MAIL_AGENT="$(whence -- msmtp)"
elif [[ -x "$(whence -- nbsmtp)" ]]; then
	export MAIL_AGENT="$(whence -- nbsmtp)"
fi

## w3m configuration
#
if [[ -z "${DESKTOP_SESSION}" ]]; then
	if [[ -x "$(whence -- w3m)" ]]; then
		export BROWSER="w3m"
		export HTTP_HOME="http://www.google.co.jp/"
	fi
fi

## git configuration
#
# if [[ -x "$(whence -- git)" ]]; then
# 	export GIT_EDITOR="${EDITOR}"
# 	export GIT_PAGER="${PAGER}"
# fi

## ruby configuration
#
if [[ -x "$(whence -- ruby)" ]]; then
	if [[ -r "${HOME}/.ssl.crt" ]]; then
		export SSL_CERT_FILE="${HOME}/.ssl.crt"
	elif [[ -r "/usr/local/etc/ssl/cert.pem" ]]; then
		export SSL_CERT_FILE="/usr/local/etc/ssl/cert.pem"
	elif [[ -r "/usr/local/share/certs/ca-root-nss.crt" ]]; then
		export SSL_CERT_FILE="/usr/local/share/certs/ca-root-nss.crt"
	fi
fi

## gem configuration
#
if [[ -x "$(whence -- gem)" ]]; then
	export RB_USER_INSTALL="yes"
fi

## GNU Screen configuration
#
if [[ -x "$(whence -- screen)" ]]; then
	if [[ -d "${HOME}/.screen/session" ]]; then
		export SCREENDIR="${HOME}/.screen/session"
	fi
fi

## tmux configuration
#
#if [[ -x "$(whence -- tmux)" ]]; then
#	if [[ -d "${HOME}/.tmux/session" ]]; then
#		export SCREENDIR="${HOME}/.tmux/session"
#	fi
#fi

## terminfo/termcap entry
#
if [[ -x "$(whence -- infocmp)" ]]; then
	if [[ -d "${HOME}/.terminfo" ]]; then
		export TERMINFO_DIRS="${HOME}/.terminfo"
	fi
elif [[ -r "${HOME}/.termcap" ]]; then
	TERMCAP="$(< ${HOME}/.termcap)"
	export TERMCAP
fi

## python configuration
#
export PYTHONUSERBASE="${HOME}/.usr"

## pnpm configuration
#
export PNPM_HOME="${HOME}/.local/share/pnpm"

## golang configuration
#
export GOPATH="${HOME}/.usr"
if [[ -d "/usr/local/gobs" ]]; then
	export GOROOT_BOOTSTRAP="/usr/local/gobs"
elif [[ -d "/usr/local/go-bootstrap" ]]; then
	export GOROOT_BOOTSTRAP="/usr/local/go-bootstrap"
fi
export GO111MODULE="on"

## goenv
#
if [[ -x "$(whence -- goenv)" ]]; then
	if [[ -d "${HOME}/.goenv" ]]; then
		export GOENV_ROOT="${HOME}/.goenv"
	fi
fi

## ghq
#
export GHQ_ROOT="${HOME}/.usr/src"

## aqua
#
if [[ -x "$(whence -- aqua)" ]]; then
	AQUA_ROOT_DIR="${XDG_DATA_HOME:-"${HOME}/.local/share"}/aquaproj-aqua"
fi

## etcd
#
export ETCDCTL_API=3

## docker
#
export DOCKER_BUILDKIT=1

## docker-compose
#
export COMPOSE_DOCKER_CLI_BUILD=1

## kubernetes
#
if [[ -r "${HOME}/.kube/config" ]]; then
	export KUBECONFIG="${HOME}/.kube/config"
fi

## packer
#
export PACKER_PLUGIN_PATH="${HOME}/.packer.d/plugins"

## terraform
#
export TF_CLI_ARGS_plan="-parallelism=50"
export TF_CLI_ARGS_apply="-parallelism=50"
if [[ -d "${HOME}/.cache/terraform/plugins" ]]; then
	export TF_PLUGIN_CACHE_DIR="${HOME}/.cache/terraform/plugins"
fi

## slack
#
export SLACK_SKIP_UPDATE="true"

## set FreeBSD to package site
#
case "${OSTYPE}" in
freebsd*)
	if [[ -z "${PACKAGEROOT}" ]] && [[ -z "${PACKAGESITE}" ]]; then
		export PACKAGEROOT="http://ftp.jp.freebsd.org"
	fi
	if [[ -z "${WRKDIRPREFIX}" ]]; then
		if [[ -w "/tmp" ]] ; then
			export WRKDIRPREFIX="/tmp/${USER}/ports"
		else
			export WRKDIRPREFIX="${HOME}/.ports/tmp"
		fi
	fi
	if [[ -n "${INSTALL_AS_USER}" ]]; then
		if [[ -z "${PORTSDIR}" ]] ; then
			if [[ -r "${HOME}/.ports/tree/Mk/bsd.port.mk" ]]; then
				export PORTSDIR="${HOME}/.ports/tree"
			elif [[ -r "/usr/ports/Mk/bsd.port.mk" ]]; then
				export PORTSDIR="/usr/ports"
			fi
		fi
		if [[ -z "${DISTDIR}" ]]; then
			if [[ -d "${HOME}/.ports/distfiles" ]]; then
				export DISTDIR="${HOME}/.ports/distfiles"
			fi
		fi
		if [[ -z "${PACKAGES}" ]]; then
			if [[ -d "${HOME}/.ports/packages" ]]; then
				export PACKAGES="${HOME}/.ports/packages"
			fi
		fi
		if [[ -z "${PORT_DBDIR}" ]]; then
			if [[ -d "${HOME}/.ports/options" ]]; then
				export PORT_DBDIR="${HOME}/.ports/options"
			fi
		fi
		if [[ -z "${PKG_DBDIR}" ]]; then
			if [[ -d "${HOME}/.ports/pkg" ]]; then
				export PKG_DBDIR="${HOME}/.ports/pkg"
			fi
		fi
		if [[ -z "${LOCALBASE}" ]]; then
			if [[ -d "${HOME}/.ports/local" ]]; then
				export LOCALBASE="${HOME}/.ports/local"
			fi
		fi
	fi
	;;
esac

## homebrew configuration
#
export HOMEBREW_NO_ANALYTICS=1
case "${OSTYPE}" in
	darwin*)
		if [[ -x "$(whence -- brew)" ]]; then
			# make job
			export HOMEBREW_MAKE_JOBS="$(sysctl -n hw.ncpu)"
			# homebrew-cask
			export HOMEBREW_CASK_OPTS="--appdir=/Applications --caskroom=/usr/local/Caskroom"
			# android-sdk
			if [[ -d "$(brew --prefix)/opt/android-sdk" ]]; then
				export ANDROID_SDK_ROOT="$(brew --prefix)/opt/android-sdk"
			fi
			# curl-ca-bundle
			if [[ -r "$(brew --prefix)/opt/curl-ca-bundle/share/ca-bundle.crt" ]]; then
				export SSL_CERT_FILE="$(brew --prefix)/opt/curl-ca-bundle/share/ca-bundle.crt"
			fi
		fi
		;;
esac

## vagrant
if [[ -x "$(whence vagrant)" ]]; then
	case "${OSTYPE}" in
		linux*)		export VAGRANT_DEFAULT_PROVIDER="libvirt" ;;
		*)				export VAGRANT_DEFAULT_PROVIDER="virtualbox" ;;
	esac
fi

## XDG Base directory
#
if [[ -z "${XDG_CONFIG_HOME}" ]]; then
	export XDG_CONFIG_HOME="${HOME}/.config"
fi
if [[ -z "${XDG_CACHE_HOME}" ]]; then
	export XDG_CACHE_HOME="${HOME}/.cache"
fi
if [[ -z "${XDG_DATA_HOME}" ]]; then
	export XDG_DATA_HOME="${HOME}/.local/share"
fi

## ROS
#
if [[ -x "$(whence -- roscore)" ]]; then
	# Environment Variables - System
	if [[ -r "/opt/ros/melodic/setup.zsh" ]]; then
		source "/opt/ros/melodic/setup.zsh"
	elif [[ -r "/opt/ros/lunar/setup.zsh" ]]; then
		source "/opt/ros/lunar/setup.zsh"
	elif [[ -r "/opt/ros/kinetic/setup.zsh" ]]; then
		source "/opt/ros/kinetic/setup.zsh"
	elif [[ -r "/opt/ros/indigo/setup.zsh" ]]; then
		source "/opt/ros/indigo/setup.zsh"
	fi
	# Environment Variables - User
	if [[ -r "${HOME}/catkin_ws/devel/setup.zsh" ]]; then
		source "${HOME}/catkin_ws/devel/setup.zsh"
	elif [[ -r "${HOME}/.catkin/devel/setup.zsh" ]]; then
		source "${HOME}/.catkin/devel/setup.zsh"
	elif [[ -r "${HOME}/Working/catkin/devel/setup.zsh" ]]; then
		source "${HOME}/Working/catkin/devel/setup.zsh"
	fi
	# Run
	if [[ -z "${ROS_HOSTNAME}" ]]; then
		export ROS_HOSTNAME="$(hostname)"
	fi
	export ROS_MASTER_URI="http://${ROS_HOSTNAME}:11311"
	# Build
	if [[ -x "$(whence -- nproc)" ]]; then
		export ROS_PARALLEL_JOBS="-j $(nproc)"
	fi
fi

## QT
#
typeset -A qt_versions=("5.14" "5.14.1" "5.13" "5.13.2" "5.12" "5.12.7" "5.9" "5.9.9")
for qt_version in ${(k)qt_versions}; do
	if [[ -d "/opt/qt/$qt_versions[$qt_version]" ]]; then
		export QT_DIR="/opt/qt/$qt_versions[$qt_version]"
		export QT_VERSION="$qt_versions[$qt_version]"
		export QT_API="$qt_version.0"
	fi
done

## Zephyr
#
if [[ -d "/opt/zephyr-sdk" ]]; then
	export ZEPHYR_GCC_VARIANT="zephyr"
	export ZEPHYR_SDK_INSTALL_DIR="/opt/zephyr-sdk"
fi
if [[ -d "${HOME}/Repository/zephyr" ]]; then
	export ZEPHYR_BASE="${HOME}/Repository/zephyr"
fi
if [[ -d "${HOME}/zephyrproject/zephyr" ]]; then
	export ZEPHYR_BASE="${HOME}/zephyrproject/zephyr"
fi

## aws-vault
#
if [[ -n "${WSLENV}" ]]; then
	if [[ -x "$(whence -- pass)" ]]; then
		export AWS_VAULT_BACKEND="pass"
		export AWS_VAULT_PASS_PREFIX="aws-vault"
	fi
fi

## tpm2-pkcs11
#
export TPM2_PKCS11_LOG_LEVEL="0"

## .Net Core
#
export DOTNET_CLI_TELEMETRY_OPTOUT="1"

## Wrangler telemetry
#
export WRANGLER_SEND_METRICS="false"

## set ${REMOTEHOST} of remote client connection address
#
if [[ -n "${REMOTEHOST}${SSH_CONNECTION}" ]]; then
	export REMOTEHOST="$(echo ${SSH_CLIENT} | cut -d " " -f 1)"
fi

## load user .zshenv configuration file
#
[[ -r "${HOME}/.zshenv.local" ]] && source "${HOME}/.zshenv.local"
