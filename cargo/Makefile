include ../Makefile.env

.PHONY: default
default: install

.PHONY: install
install: \
	${HOME}/.cargo \
	${HOME}/.cargo/env \
	${HOME}/.cargo/config.toml

.PHONY: clean
clean:
	@rm -fr ${HOME}/.cargo

${HOME}/.cargo:
	@mkdir -p $@
${HOME}/.cargo/env:
	@rustup-init -y --no-modify-path
${HOME}/.cargo/config.toml:
	@ln -s ../${DOTDIR_NAME}/cargo/config.toml $@
