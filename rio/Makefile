.POSIX:

include ../Makefile.env

.PHONY: default
default: install

.PHONY: install
install: \
	${HOME}/.config/rio \
	${HOME}/.config/rio/config.toml

.PHONY: clean
clean:
	@rm -rf ${HOME}/.config/rio

${HOME}/.config/rio:
	@install -d -m 0755 $@

${HOME}/.config/rio/config.toml:
	@ln -s ../../${DOTDIR_NAME}/rio/config.toml $@
