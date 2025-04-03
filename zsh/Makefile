include ../Makefile.env

DIRS = \
	${HOME}/.zsh \
	${HOME}/.zsh/functions

FILES = \
	${HOME}/.zshenv \
	${HOME}/.zsh/.zshenv \
	${HOME}/.zsh/.zlogin \
	${HOME}/.zsh/.zlogout \
	${HOME}/.zsh/.zprofile \
	${HOME}/.zsh/.zsh_alias \
	${HOME}/.zsh/.zsh_completion \
	${HOME}/.zsh/.zshrc

PLUGINS = \
	${HOME}/.zsh/zsh-completions \
	${HOME}/.zsh/zsh-autosuggestions \
	${HOME}/.zsh/zsh-syntax-highlighting \
	${HOME}/.zsh/zsh-history-substring-search \
	${HOME}/.zsh/conda-zsh-completion \
	${HOME}/.zsh/zload

.PHONY: default
default: install

.PHONY: install
install: ${DIRS} ${FILES} ${PLUGINS}

.PHONY: update
update: ${PLUGINS}

.PHONY: clean
clean:
	@rm -f ${FILES}
	@rm -f ${HOME}/.zsh/.zcompdump
	@rm -fr ${PLUGINS}
	@rm -fr ${HOME}/.zsh/cache
	@rm -fr ${HOME}/.zsh/functions

${HOME}/.zsh:
	@mkdir $@
${HOME}/.zsh/functions:
	@ln -fs ../${DOTDIR_NAME}/zsh/functions $@

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

${HOME}/.zsh/zsh-completions:
	@if test ! -d $@; then \
		git clone https://github.com/zsh-users/zsh-completions.git $@; \
	else \
		cd $@ && git pull; \
	fi
${HOME}/.zsh/zsh-autosuggestions:
	@if test ! -d $@; then \
		git clone https://github.com/zsh-users/zsh-autosuggestions.git $@; \
	else \
		cd $@ && git pull; \
	fi
${HOME}/.zsh/zsh-syntax-highlighting:
	@if test ! -d $@; then \
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $@; \
	else \
		cd $@ && git pull; \
	fi
${HOME}/.zsh/zsh-history-substring-search:
	@if test ! -d $@; then \
		git clone https://github.com/zsh-users/zsh-history-substring-search.git $@; \
	else \
		cd $@ && git pull; \
	fi
${HOME}/.zsh/conda-zsh-completion:
	@if test ! -d $@; then \
		git clone https://github.com/conda-incubator/conda-zsh-completion $@; \
	else \
		cd $@ && git pull; \
	fi
${HOME}/.zsh/zload:
	@if test ! -d $@; then \
		git clone https://github.com/mollifier/zload.git $@; \
	else \
		cd $@ && git pull; \
	fi
