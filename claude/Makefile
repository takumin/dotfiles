include ../Makefile.env

SETTINGS := ${HOME}/.claude/settings.json
FRAGMENT := $(CURDIR)/settings.yaml

.PHONY: default
default: install

.PHONY: install
install: \
	${HOME}/.claude \
	${HOME}/.claude/agents \
	${HOME}/.claude/hooks \
	${HOME}/.claude/references \
	${HOME}/.claude/rules \
	${HOME}/.claude/skills \
	${HOME}/.claude/CLAUDE.md \
	settings

.PHONY: clean
clean:
	@rm -fr ${HOME}/.claude/agents
	@rm -fr ${HOME}/.claude/hooks
	@rm -fr ${HOME}/.claude/references
	@rm -fr ${HOME}/.claude/rules
	@rm -fr ${HOME}/.claude/skills
	@rm -fr ${HOME}/.claude/CLAUDE.md
	@if command -v yq >/dev/null 2>&1 && [ -f ${SETTINGS} ]; then \
		yq -i -o=json 'delpaths([load("${FRAGMENT}") | keys | .[] | [.]])' ${SETTINGS}; \
	fi

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
${HOME}/.claude/references:
	@if [ -d $(CURDIR)/references ]; then \
		ln -s ../${DOTDIR_NAME}/claude/references $@; \
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

.PHONY: settings
settings: ${HOME}/.claude
	@if command -v yq >/dev/null 2>&1; then \
		[ -f ${SETTINGS} ] || echo '{}' > ${SETTINGS}; \
		yq -i -o=json '. *= load("${FRAGMENT}")' ${SETTINGS}; \
	else \
		echo "yq not installed; skip ${SETTINGS}"; \
	fi

.PHONY: login
login:
	@claude setup-token
