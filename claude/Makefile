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
	@rm -fr ${HOME}/.claude/agents
	@rm -fr ${HOME}/.claude/hooks
	@rm -fr ${HOME}/.claude/rules
	@rm -fr ${HOME}/.claude/skills
	@rm -fr ${HOME}/.claude/CLAUDE.md

${HOME}/.claude:
	@mkdir -p $@
${HOME}/.claude/agents:
	@ln -s ../${DOTDIR_NAME}/claude/agents $@
${HOME}/.claude/hooks:
	@ln -s ../${DOTDIR_NAME}/claude/hooks $@
${HOME}/.claude/rules:
	@ln -s ../${DOTDIR_NAME}/claude/rules $@
${HOME}/.claude/skills:
	@ln -s ../${DOTDIR_NAME}/claude/skills $@

${HOME}/.claude/CLAUDE.md:
	@ln -s ../${DOTDIR_NAME}/claude/CLAUDE.md $@

.PHONY: login
login:
	@claude setup-token
