include ../Makefile.env

.PHONY: default
default: install

.PHONY: install
install: \
	${HOME}/.config/aria2 \
	${HOME}/.config/aria2/aria2.conf

.PHONY: clean
clean:
	@rm -fr ${HOME}/.config/aria2

${HOME}/.config/aria2:
	@mkdir -p $@
${HOME}/.config/aria2/aria2.conf:
	@ln -s ../../${DOTDIR_NAME}/aria2/aria2.conf $@
