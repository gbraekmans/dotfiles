IMAGE_MAGICK=convert
DIR :=$(shell pwd)

.PHONY: all help bash zsh vim tmux X debian_wallpaper freebsd_wallpaper gentoo_wallpaper update

all: zsh tmux X debian_wallpaper

help:
	@echo "Please use one of the following:"
	@echo "  bash                   install a symlink to this bashrc"
	@echo "  zsh                    install a symlink to this zshrc"
	@echo "  vim                    install a symlink to this vim configuration"
	@echo "  tmux                   install a symlink to this tmux configuration"
	@echo "  X                      install a symlink to this X/i3 configuration"
	@echo "  debian_wallpaper       create a ~/.wallpaper.png for Debian"
	@echo "  freebsd_wallpaper      create a ~/.wallpaper.png for Freebsd"
	@echo "  gentoo_wallpaper       create a ~/.wallpaper.png for Gentoo"
	@echo "  update                 update all external sources"

bash:
	ln -sf $(DIR)/bash/bashrc ${HOME}/.bashrc
	ln -sfn $(DIR)/bash/completion ${HOME}/.bash_completions

zsh:
	ln -sf $(DIR)/zsh/zshrc ${HOME}/.zshrc

vim:
	ln -sf $(DIR)/vim/vimrc ${HOME}/.vimrc
	mkdir -p ${HOME}/.vim
	ln -sfn $(DIR)/vim/autoload ${HOME}/.vim/autoload
	ln -sfn $(DIR)/vim/bundle ${HOME}/.vim/bundle
	ln -sfn $(DIR)/vim/ftplugin ${HOME}/.vim/ftplugin
	ln -sfn $(DIR)/vim/spell ${HOME}/.vim/spell
	vim -c ":e ${HOME}/.vim/spell/en.utf-8.add" -c ':silent mkspell! %' -c ':q'
	vim -c ':Helptags' -c ':q'

tmux:
	ln -sf $(DIR)/tmux/tmux.conf ${HOME}/.tmux.conf

X:
	mkdir -p ${HOME}/.config
	ln -sf $(DIR)/X/gtk/gtk2 ${HOME}/.gtkrc-2.0
	mkdir -p ${HOME}/.config/gtk-3.0
	ln -sf $(DIR)/X/gtk/gtk3 ${HOME}/.config/gtk-3.0/settings.ini
	ln -sf $(DIR)/X/Xresources ${HOME}/.Xresources
	ln -sfn $(DIR)/X/i3 ${HOME}/.config/i3
	ln -sfn $(DIR)/X/i3status ${HOME}/.config/i3status

debian_wallpaper:
	$(IMAGE_MAGICK) X/wallpapers/debian_swirl_badwolf.svg ${HOME}/.wallpaper.png

freebsd_wallpaper:
	$(IMAGE_MAGICK) X/wallpapers/debian_swirl_badwolf.svg ${HOME}/.wallpaper.png

gentoo_wallpaper:
	$(IMAGE_MAGICK) X/wallpapers/gentoo_logo_badwolf.svg ${HOME}/.wallpaper.png

update:
	mkdir -p vim/bundle
	git submodule foreach git pull origin master
	mkdir -p bash/completion
	wget -q https://raw.githubusercontent.com/Bash-it/bash-it/master/completion/available/pip.completion.bash -O bash/completion/pip.completion.bash
	wget -q https://raw.githubusercontent.com/Bash-it/bash-it/master/completion/available/tmux.completion.bash -O bash/completion/tmux.completion.bash
	wget -q https://raw.githubusercontent.com/Bash-it/bash-it/master/completion/available/apm.completion.bash -O bash/completion/apm.completion.bash

# bsd:
# 	echo "zsh"
# 	ln -sf $(.CURDIR)/zsh/zshrc ${HOME}/.zshrc
# 	echo "vim"
# 	ln -sf $(.CURDIR)/vim/vimrc ${HOME}/.vimrc
# 	mkdir -p ${HOME}/.vim
# 	ln -sF $(.CURDIR)/vim/autoload ${HOME}/.vim/autoload
# 	ln -sF $(.CURDIR)/vim/bundle ${HOME}/.vim/bundle
# 	ln -sF $(.CURDIR)/vim/ftplugin ${HOME}/.vim/ftplugin
# 	ln -sF $(.CURDIR)/vim/spell ${HOME}/.vim/spell
# 	vim -c ":e ${HOME}/.vim/spell/en.utf-8.add" -c ':silent mkspell! %' -c ':q'
# 	vim -c ':Helptags' -c ':q'
# 	mkdir -p ${HOME}/.config
# 	ln -sf $(.CURDIR)/X/Xresources ${HOME}/.Xresources
# 	ln -sF $(.CURDIR)/X/i3 ${HOME}/.i3
# 	ln -sF $(.CURDIR)/X/i3status ${HOME}/.i3status
# 	$(IMAGE_MAGICK) X/wallpapers/freebsd_orb_badwolf.svg ${HOME}/.wallpaper.png
