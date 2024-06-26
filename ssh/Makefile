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

${HOME}/.ssh/config.d/aws-ssm.conf:
	@if [ -f "/usr/local/sessionmanagerplugin/bin/session-manager-plugin" ]; then \
		echo "# vim: set ft=sshconfig ts=8 sw=8 sts=0 noet :" > $@; \
		echo "# AWS SSM Session Manager" >> $@; \
		echo "host i-* mi-*" >> $@; \
		echo "	ProxyCommand		sh -c \"aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'\"" >> $@; \
		echo "	UserKnownHostsFile	/dev/null" >> $@; \
		echo "	StrictHostKeyChecking	no" >> $@; \
		echo "	LogLevel		FATAL" >> $@; \
	fi

${HOME}/.ssh/config.d/vagrant.conf:
	@if [ -f "${HOME}/.vagrant.d/insecure_private_key" ]; then \
		echo "# vim: set ft=sshconfig ts=8 sw=8 sts=0 noet :" > $@; \
		echo "# Vagrant/Libvirt" >> $@; \
		echo "Host vagrant" >> $@; \
		echo "	HostName		172.28.128.2" >> $@; \
		echo "	User			vagrant" >> $@; \
		echo "	UserKnownHostsFile	/dev/null" >> $@; \
		echo "	StrictHostKeyChecking	no" >> $@; \
		echo "	LogLevel		FATAL" >> $@; \
		echo "	IdentityFile		~/.vagrant.d/insecure_private_key" >> $@; \
		echo "	IdentitiesOnly		yes" >> $@; \
	fi
