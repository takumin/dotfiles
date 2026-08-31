include ../Makefile.env

DIRS = \
	${HOME}/.config/opencode

FILES = \
	${HOME}/.config/opencode/opencode.jsonc

.PHONY: default
default: install

.PHONY: install
install: ${DIRS} ${FILES}

.PHONY: clean
clean:
	@rm -f ${FILES}

${HOME}/.config/opencode:
	@mkdir -p $@

${HOME}/.config/opencode/opencode.jsonc:
	@ln -s ../../${DOTDIR_NAME}/opencode/opencode.jsonc $@
