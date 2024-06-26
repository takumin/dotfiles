include ../Makefile.env

DIRS = \
	${HOME}/.ssh \
	${HOME}/.ssh/config.d

FILES = \
	${HOME}/.ssh/config \
	${HOME}/.ssh/config.d/aws-ssm.conf \
	${HOME}/.ssh/config.d/vagrant.conf

.PHONY: default
default: install

.PHONY: install
install: ${DIRS} ${FILES}

.PHONY: clean
clean:
	@rm -f ${FILES}
	@rm -fr ${HOME}/.ssh/config.d

${HOME}/.ssh:
	@install -d -m 0700 $@
${HOME}/.ssh/config.d:
	@install -d -m 0700 $@

${HOME}/.ssh/config: config
	@ln -s ../${DOTDIR_NAME}/ssh/config $@

${HOME}/.ssh/config.d/aws-ssm.conf: config.aws-ssm
	@if [ -f "/usr/local/sessionmanagerplugin/bin/session-manager-plugin" ]; then \
		ln -s ../../${DOTDIR_NAME}/ssh/config.aws-ssm $@; \
	fi

${HOME}/.ssh/config.d/vagrant.conf: config.vagrant
	@if [ -f "${HOME}/.vagrant.d/insecure_private_key" ]; then \
		ln -s ../../${DOTDIR_NAME}/ssh/config.vagrant $@; \
	fi
