include ../Makefile.env

.PHONY: default
default: install

.PHONY: install
install: \
	${HOME}/.config/yamlfmt \
	${HOME}/.config/yamlfmt/yamlfmt.yml

.PHONY: clean
clean:
	@rm -fr ${HOME}/.config/yamlfmt

${HOME}/.config/yamlfmt:
	@mkdir -p $@
${HOME}/.config/yamlfmt/yamlfmt.yml:
	@ln -s ../../${DOTDIR_NAME}/yamlfmt/yamlfmt.yml $@
