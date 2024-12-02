.POSIX:

include ../Makefile.env

USER_NAME            ?= Takumi Takahashi
EMAIL_ADDRESS        ?= takumiiinn@gmail.com
COMMIT_SIGNING_KEY   ?= ~/.ssh/pubkeys.d/$(EMAIL_ADDRESS).pub
ALLOWED_SIGNERS_FILE ?= ~/.ssh/sigkeys.d/$(EMAIL_ADDRESS).sig

.PHONY: default
default: install

.PHONY: install
install: \
	${HOME}/.config/git \
	${HOME}/.config/git/attributes \
	${HOME}/.config/git/config \
	${HOME}/.config/git/ignore \
	${HOME}/.config/git/accounts

.PHONY: clean
clean:
	@rm -fr ${HOME}/.config/git

${HOME}/.config/git:
	@mkdir -p $@

${HOME}/.config/git/attributes: ${HOME}/.config/git
	@ln -fs ../../${DOTDIR_NAME}/git/dot.gitattributes $@
${HOME}/.config/git/config: ${HOME}/.config/git
	@ln -fs ../../${DOTDIR_NAME}/git/dot.gitconfig $@
${HOME}/.config/git/ignore: ${HOME}/.config/git
	@ln -fs ../../${DOTDIR_NAME}/git/dot.gitignore $@

${HOME}/.config/git/accounts: ${HOME}/.config/git
	@test -f $@ || echo '# vim: ft=gitconfig noet :' > $@
	@git config -f $@ user.name "$(USER_NAME)"
	@git config -f $@ user.email "$(EMAIL_ADDRESS)"
	@git config -f $@ user.signingkey "$(COMMIT_SIGNING_KEY)"
	@git config -f $@ commit.gpgsign "true"
	@git config -f $@ gpg.format "ssh"
	@git config -f $@ gpg.ssh.allowedSignersFile "$(ALLOWED_SIGNERS_FILE)"
