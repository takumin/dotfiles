.POSIX:

include ../Makefile.env

.PHONY: default
default: install

.PHONY: install
install: ${HOME}/.npmrc

.PHONY: clean
clean:
	@rm -f ${HOME}/.npmrc

${HOME}/.npmrc:
	@ln -s ${DOTDIR_NAME}/npm/dot.npmrc $@
