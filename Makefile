include Makefile.dirname

SUBDIRS := $(shell find . -mindepth 1 -maxdepth 1 -type d -not -name '.git' -printf '%f\n')

.PHONY: default
default: install

.PHONY: install
install: ${DOTDIR_PATH} ${SUBDIRS}

.PHONY: update
update: ${DOTDIR_PATH} ${SUBDIRS}

.PHONY: clean
clean: ${SUBDIRS}

.PHONY: ${SUBDIRS}
${SUBDIRS}:
	@${MAKE} --no-print-directory -C $@ ${MAKECMDGOALS}

${DOTDIR_PATH}:
	@ln -fs ${CURDIR} $@
