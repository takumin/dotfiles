include ../Makefile.env

.PHONY: default
default: install

.PHONY: install
install: \
	${HOME}/.bashrc \
	${HOME}/.bash_login \
	${HOME}/.bash_logout \
	${HOME}/.bash_profile \
	${HOME}/.bash_alias \
	${HOME}/.bash_color

.PHONY: clean
clean:
	@rm -f ${HOME}/.bashrc
	@rm -f ${HOME}/.bash_login
	@rm -f ${HOME}/.bash_logout
	@rm -f ${HOME}/.bash_profile
	@rm -f ${HOME}/.bash_alias
	@rm -f ${HOME}/.bash_color

${HOME}/.bashrc:
	@ln -s ${DOTDIR_NAME}/bash/dot.bashrc $@
${HOME}/.bash_login:
	@ln -s ${DOTDIR_NAME}/bash/dot.bash_login $@
${HOME}/.bash_logout:
	@ln -s ${DOTDIR_NAME}/bash/dot.bash_logout $@
${HOME}/.bash_profile:
	@ln -s ${DOTDIR_NAME}/bash/dot.bash_profile $@
${HOME}/.bash_alias:
	@ln -s ${DOTDIR_NAME}/bash/dot.bash_alias $@
${HOME}/.bash_color:
	@ln -s ${DOTDIR_NAME}/bash/dot.bash_color $@
