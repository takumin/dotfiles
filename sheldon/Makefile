include ../Makefile.env

.PHONY: default
default: install

.PHONY: install
install: \
	${HOME}/.config/sheldon \
	${HOME}/.config/sheldon/plugins.toml

.PHONY: clean
clean:
	@rm -fr ${HOME}/.config/sheldon

${HOME}/.config/sheldon:
	@mkdir -p $@
${HOME}/.config/sheldon/plugins.toml:
	@ln -s ../../${DOTDIR_NAME}/sheldon/plugins.toml $@
