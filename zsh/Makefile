include ../Makefile.env

DIRS = \
	${HOME}/.zsh

FILES = \
	${HOME}/.zshenv \
	${HOME}/.zsh/.zshenv \
	${HOME}/.zsh/.zlogin \
	${HOME}/.zsh/.zlogout \
	${HOME}/.zsh/.zprofile \
	${HOME}/.zsh/.zsh_alias \
	${HOME}/.zsh/.zsh_completion \
	${HOME}/.zsh/.zshrc

.PHONY: default
default: install

.PHONY: install
install: ${DIRS} ${FILES}

.PHONY: clean
clean:
	@rm -f ${FILES}
	@rm -f ${HOME}/.zsh/.zcompdump
	@rm -fr ${PLUGINS}
	@rm -fr ${HOME}/.zsh/cache

${HOME}/.zsh:
	@mkdir $@

${HOME}/.zshenv:
	@ln -s ${DOTDIR_NAME}/zsh/dot.zshenv $@
${HOME}/.zsh/.zshenv:
	@ln -s ../${DOTDIR_NAME}/zsh/dot.zshenv $@
${HOME}/.zsh/.zlogin:
	@ln -s ../${DOTDIR_NAME}/zsh/dot.zlogin $@
${HOME}/.zsh/.zlogout:
	@ln -s ../${DOTDIR_NAME}/zsh/dot.zlogout $@
${HOME}/.zsh/.zprofile:
	@ln -s ../${DOTDIR_NAME}/zsh/dot.zprofile $@
${HOME}/.zsh/.zsh_alias:
	@ln -s ../${DOTDIR_NAME}/zsh/dot.zsh_alias $@
${HOME}/.zsh/.zsh_completion:
	@ln -s ../${DOTDIR_NAME}/zsh/dot.zsh_completion $@
${HOME}/.zsh/.zshrc:
	@ln -s ../${DOTDIR_NAME}/zsh/dot.zshrc $@
