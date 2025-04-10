.POSIX:

include ../Makefile.env

.PHONY: default
default: install

.PHONY: install
install: ${HOME}/.gemrc

.PHONY: clean
clean:
	@rm -f ${HOME}/.gemrc

${HOME}/.gemrc:
	@ln -s ${DOTDIR_NAME}/gem/dot.gemrc $@
