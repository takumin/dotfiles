.POSIX:

include ../Makefile.env

DIRS = \
	${HOME}/.ssh \
	${HOME}/.ssh/config.d \
	${HOME}/.ssh/privkeys.d \
	${HOME}/.ssh/pubkeys.d \
	${HOME}/.ssh/session.d \
	${HOME}/.ssh/sigkeys.d

FILES = \
	${HOME}/.ssh/authorized_keys \
	${HOME}/.ssh/config \
	${HOME}/.ssh/config.d/aws-ssm.conf \
	${HOME}/.ssh/config.d/vagrant.conf \
	${HOME}/.ssh/pubkeys.d/takumiiinn@gmail.com.pub \
	${HOME}/.ssh/sigkeys.d/takumiiinn@gmail.com.sig

.PHONY: default
default: install

.PHONY: install
install: ${DIRS} ${FILES}

.PHONY: clean
clean:
	@rm -f ${FILES}
	@rm -fr ${HOME}/.ssh/config.d
	@rm -fr ${HOME}/.ssh/pubkeys.d
	@rm -fr ${HOME}/.ssh/sigkeys.d

${HOME}/.ssh:
	@install -d -m 0700 $@
${HOME}/.ssh/config.d:
	@install -d -m 0700 $@
${HOME}/.ssh/privkeys.d:
	@install -d -m 0700 $@
${HOME}/.ssh/pubkeys.d:
	@install -d -m 0700 $@
${HOME}/.ssh/session.d:
	@install -d -m 0700 $@
${HOME}/.ssh/sigkeys.d:
	@install -d -m 0700 $@

${HOME}/.ssh/authorized_keys: ${HOME}/.ssh/pubkeys.d/takumiiinn@gmail.com.pub
	@echo "$$(cat $<) takumiiinn@gmail.com" > $@

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

${HOME}/.ssh/pubkeys.d/takumiiinn@gmail.com.pub:
	@op item get hxmssmkgndajd3sor6lerazky4 --fields 'public key' > $@
${HOME}/.ssh/sigkeys.d/takumiiinn@gmail.com.sig: ${HOME}/.ssh/pubkeys.d/takumiiinn@gmail.com.pub
	@echo "takumiiinn@gmail.com namespace=\"git\" $$(cat $<)" > $@
