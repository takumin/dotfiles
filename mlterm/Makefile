.POSIX:

include ../Makefile.env

.PHONY: default
default: install

.PHONY: install
install: \
	${HOME}/.mlterm \
	${HOME}/.mlterm/main \
	${HOME}/.mlterm/font \
	${HOME}/.mlterm/vfont \
	${HOME}/.mlterm/tfont \
	${HOME}/.mlterm/aafont \
	${HOME}/.mlterm/vaafont \
	${HOME}/.mlterm/taafont \
	${HOME}/.mlterm/color \
	${HOME}/.mlterm/key \
	${HOME}/.mlterm/termcap \
	${HOME}/.mlterm/xim \
	${HOME}/.mlterm/menu

.PHONY: clean
clean:
	@rm -fr ${HOME}/.mlterm

${HOME}/.mlterm:
	@mkdir $@

${HOME}/.mlterm/main:
	@ln -s ../${DOTDIR_NAME}/mlterm/main $@
${HOME}/.mlterm/font:
	@ln -s ../${DOTDIR_NAME}/mlterm/font $@
${HOME}/.mlterm/vfont:
	@ln -s ../${DOTDIR_NAME}/mlterm/vfont $@
${HOME}/.mlterm/tfont:
	@ln -s ../${DOTDIR_NAME}/mlterm/tfont $@
${HOME}/.mlterm/aafont:
	@ln -s ../${DOTDIR_NAME}/mlterm/aafont $@
${HOME}/.mlterm/vaafont:
	@ln -s ../${DOTDIR_NAME}/mlterm/vaafont $@
${HOME}/.mlterm/taafont:
	@ln -s ../${DOTDIR_NAME}/mlterm/taafont $@
${HOME}/.mlterm/color:
	@ln -s ../${DOTDIR_NAME}/mlterm/color $@
${HOME}/.mlterm/key:
	@ln -s ../${DOTDIR_NAME}/mlterm/key $@
${HOME}/.mlterm/termcap:
	@ln -s ../${DOTDIR_NAME}/mlterm/termcap $@
${HOME}/.mlterm/xim:
	@ln -s ../${DOTDIR_NAME}/mlterm/xim $@
${HOME}/.mlterm/menu:
	@ln -s ../${DOTDIR_NAME}/mlterm/menu $@
