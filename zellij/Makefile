.POSIX:

include ../Makefile.env

.PHONY: default
default: install

.PHONY: install
install: \
	${HOME}/.config/zellij \
	${HOME}/.config/zellij/config.kdl

.PHONY: clean
clean:
	@rm -rf ${HOME}/.cache/zellij
	@rm -rf ${HOME}/.config/zellij
	@rm -rf ${HOME}/.local/share/zellij

${HOME}/.config/zellij:
	@install -d -m 0755 $@

${HOME}/.config/zellij/config.kdl:
	@ln -s ../../${DOTDIR_NAME}/zellij/config.kdl $@
