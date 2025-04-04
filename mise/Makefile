include ../Makefile.env

.PHONY: default
default: install

.PHONY: install
install: \
	${HOME}/.config/mise \
	${HOME}/.config/mise/config.toml

.PHONY: clean
clean:
	@rm -fr ${HOME}/.config/mise

${HOME}/.config/mise:
	@mkdir -p $@
${HOME}/.config/mise/config.toml:
	@ln -s ../../${DOTDIR_NAME}/mise/config.toml $@
	@mise trust config.toml
