include ../Makefile.env

DIRS = \
	${HOME}/.ssh \
	${HOME}/.ssh/config.d

FILES = \
	${HOME}/.ssh/config

.PHONY: default
default: install

.PHONY: install
install: ${DIRS} ${FILES}

.PHONY: clean
clean:
	@rm -f ${FILES}
	@rm -fr ${HOME}/.ssh/config.d

${HOME}/.ssh:
	@install -d -m 0700 $@
${HOME}/.ssh/config.d:
	@install -d -m 0700 $@

${HOME}/.ssh/config: config
	@ln -s ../${DOTDIR_NAME}/ssh/config $@
