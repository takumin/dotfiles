include ../Makefile.env

.PHONY: default
default: install

.PHONY: install
install: \
	${HOME}/.codex \
	${HOME}/.codex/AGENTS.md

.PHONY: clean
clean:
	@rm -fr ${HOME}/.codex/AGENTS.md

${HOME}/.codex:
	@mkdir -p $@

${HOME}/.codex/AGENTS.md:
	@ln -s ../${DOTDIR_NAME}/codex/AGENTS.md $@

.PHONY: login
login:
	@codex login
