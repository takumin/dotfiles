include ../Makefile.env

.PHONY: default
default: install

.PHONY: install
install: \
	${HOME}/.profile \
	${HOME}/.shrc

.PHONY: clean
clean:
	@rm -f ${HOME}/.profile
	@rm -f ${HOME}/.shrc

${HOME}/.profile:
	@ln -s ${DOTDIR_NAME}/sh/dot.profile $@
${HOME}/.shrc:
	@ln -s ${DOTDIR_NAME}/sh/dot.shrc $@
