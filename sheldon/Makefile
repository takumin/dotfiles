include ../Makefile.env

.PHONY: default
default: install

.PHONY: install
install: \
	${HOME}/.config/sheldon \
	${HOME}/.local/share/sheldon \
	${HOME}/.config/sheldon/plugins.toml \
	${HOME}/.local/share/sheldon/plugins.lock

.PHONY: clean
clean:
	@rm -fr ${HOME}/.config/sheldon
	@rm -fr ${HOME}/.local/share/sheldon

${HOME}/.config/sheldon:
	@mkdir -p $@
${HOME}/.local/share/sheldon:
	@mkdir -p $@
${HOME}/.config/sheldon/plugins.toml:
	@ln -s ../../${DOTDIR_NAME}/sheldon/plugins.toml $@
${HOME}/.local/share/sheldon/plugins.lock: ${HOME}/.config/sheldon/plugins.toml
	@sheldon lock
