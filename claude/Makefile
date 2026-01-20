include ../Makefile.env

.PHONY: default
default: install

.PHONY: install
install: \
	${HOME}/.claude \
	${HOME}/.claude/agents \
	${HOME}/.claude/hooks \
	${HOME}/.claude/rules \
	${HOME}/.claude/skills \
	${HOME}/.claude/CLAUDE.md

.PHONY: clean
clean:
	@rm -fr ${HOME}/.claude
	@rm -fr ${HOME}/.claude.json
	@rm -fr ${HOME}/.claude.json.backup

${HOME}/.claude:
	@mkdir -p $@
${HOME}/.claude/agents:
	@mkdir -p $@
${HOME}/.claude/hooks:
	@mkdir -p $@
${HOME}/.claude/rules:
	@mkdir -p $@
${HOME}/.claude/skills:
	@mkdir -p $@

${HOME}/.claude/CLAUDE.md:
	@ln -s ../${DOTDIR_NAME}/claude/CLAUDE.md $@

.PHONY: login
login:
	@claude setup-token
