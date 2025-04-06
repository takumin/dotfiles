.POSIX:

include ../Makefile.env

.PHONY: default
default: install

.PHONY: install
install: \
	${HOME}/.config/wezterm \
	${HOME}/.config/wezterm/wezterm.lua

.PHONY: clean
clean:
	@rm -rf ${HOME}/.config/wezterm

${HOME}/.config/wezterm:
	@install -d -m 0755 $@

${HOME}/.config/wezterm/wezterm.lua:
	@ln -s ../../${DOTDIR_NAME}/wezterm/wezterm.lua $@
