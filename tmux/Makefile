include ../Makefile.env

.PHONY: default
default: install

.PHONY: install
install: \
	${HOME}/.tmux \
	${HOME}/.tmux/session \
	${HOME}/.tmux.conf

.PHONY: clean
clean:
	@rm -f ${HOME}/.tmux.conf

${HOME}/.tmux:
	@mkdir $@
${HOME}/.tmux/session:
	@mkdir -m 0700 $@

${HOME}/.tmux.conf:
	@ln -s ${DOTDIR_NAME}/tmux/dot.tmux.conf $@
