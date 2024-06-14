.POSIX:

include ../Makefile.env

.PHONY: default
default: install

.PHONY: install
install: \
	${HOME}/.config/nvim \
	${HOME}/.cache/nvim \
	${HOME}/.local/share/nvim \
	${HOME}/.local/state/nvim \
	${HOME}/.local/state/nvim/backup \
	${HOME}/.local/state/nvim/swap \
	${HOME}/.local/state/nvim/undo \
	${HOME}/.config/nvim/init.lua \
	${HOME}/.config/nvim/lua

.PHONY: clean
clean:
	@rm -fr ${HOME}/.config/nvim
	@rm -fr ${HOME}/.cache/nvim
	@rm -fr ${HOME}/.local/share/nvim
	@rm -fr ${HOME}/.local/state/nvim

${HOME}/.config/nvim:
	@mkdir -p $@

${HOME}/.cache/nvim:
	@mkdir -p $@

${HOME}/.local/share/nvim:
	@mkdir -p $@

${HOME}/.local/state/nvim:
	@mkdir -p $@

${HOME}/.local/state/nvim/backup: ${HOME}/.local/state/nvim
	@mkdir -p $@

${HOME}/.local/state/nvim/swap: ${HOME}/.local/state/nvim
	@mkdir -p $@

${HOME}/.local/state/nvim/undo: ${HOME}/.local/state/nvim
	@mkdir -p $@

${HOME}/.config/nvim/init.lua: ${HOME}/.config/nvim
	@ln -s $(CURDIR)/init.lua $@

${HOME}/.config/nvim/lua: ${HOME}/.config/nvim
	@ln -s $(CURDIR)/lua $@
