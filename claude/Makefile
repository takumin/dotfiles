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
	@if [ -d $(CURDIR)/agents ]; then \
		ln -s ../${DOTDIR_NAME}/claude/agents $@; \
	fi
${HOME}/.claude/hooks:
	@if [ -d $(CURDIR)/hooks ]; then \
		ln -s ../${DOTDIR_NAME}/claude/hooks $@; \
	fi
${HOME}/.claude/rules:
	@if [ -d $(CURDIR)/rules ]; then \
		ln -s ../${DOTDIR_NAME}/claude/rules $@; \
	fi
${HOME}/.claude/skills:
	@if [ -d $(CURDIR)/skills ]; then \
		ln -s ../${DOTDIR_NAME}/claude/skills $@; \
	fi

${HOME}/.claude/CLAUDE.md:
	@if [ -f $(CURDIR)/CLAUDE.md ]; then \
		ln -s ../${DOTDIR_NAME}/claude/CLAUDE.md $@; \
	fi

.PHONY: login
login:
	@claude setup-token
