include Makefile.env

SUBDIRS := $(shell find . -mindepth 2 -maxdepth 2 -type f -name 'Makefile' | awk -F '/' '{print $$2}')

.PHONY: default
default: install

.PHONY: install
install: ${DOTDIR_PATH} ${SUBDIRS} private

.PHONY: update
update: ${DOTDIR_PATH} ${SUBDIRS} private

.PHONY: clean
clean: ${SUBDIRS} private

.PHONY: ${SUBDIRS}
${SUBDIRS}:
	@${MAKE} --no-print-directory -C $@ $(filter-out private,${MAKECMDGOALS})

.PHONY: private
private: ${SUBDIRS}
	@if [ -f "${PRIVATE_DIR}/Makefile" ]; then \
		${MAKE} --no-print-directory -C "${PRIVATE_DIR}" $(filter-out private,${MAKECMDGOALS}); \
	fi

${DOTDIR_PATH}:
	@ln -s ${CURDIR} $@
