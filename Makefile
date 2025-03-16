include Makefile.env

SUBDIRS := $(shell find . -mindepth 2 -maxdepth 2 -type f -name 'Makefile' | awk -F '/' '{print $$2}')

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
	@ln -s ${CURDIR} $@
