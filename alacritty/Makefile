.POSIX:

include ../Makefile.env

.PHONY: default
default: install

.PHONY: install
install: \
	${HOME}/.config/alacritty \
	${HOME}/.config/alacritty/alacritty.toml

.PHONY: clean
clean:
	@rm -rf ${HOME}/.config/alacritty

${HOME}/.config/alacritty:
	@install -d -m 0755 $@

${HOME}/.config/alacritty/alacritty.toml:
	@ln -s ../../${DOTDIR_NAME}/alacritty/alacritty.toml $@
