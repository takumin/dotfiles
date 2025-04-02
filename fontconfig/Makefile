include ../Makefile.env

.PHONY: default
default: install

.PHONY: install
install: \
	${HOME}/.config/fontconfig \
	${HOME}/.config/fontconfig/fonts.conf

.PHONY: clean
clean:
	@rm -fr ${HOME}/.config/fontconfig

${HOME}/.config/fontconfig:
	@mkdir -p $@
${HOME}/.config/fontconfig/fonts.conf:
	@ln -s ../../${DOTDIR_NAME}/fontconfig/fonts.conf $@
