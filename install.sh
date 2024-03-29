#!/bin/sh

install_applications() {
	id=$(cat /etc/os-release | grep ^ID)
	case $id in
		*arch*)
			sudo pacman -Syu
			sudo pacman -S zsh curl feh terminator ttf-ubuntu-font-family tmux
			;;
		*ubuntu*)
			sudo apt-get -y update
			sudo apt-get -y zsh curl feh terminator tmux gvim-gtk3 i3
			;;
		*)
			echo Unknown distro
			;;
	esac
}

setup_git() {
	echo "Configuring git"
	git config --global user.name "Erik Stenlund"
	git config --global user.email "erikstenlund@protonmail.com"
	git config --global alias.co checkout
	git config --global alias.br branch
	git config --global alias.st status
	git config --global alias.ci commit
	git config --global alias.cp cherry-pick
	# git config --global commit.gpgsign true
}

setup_directories_and_dotfiles() {
	echo "Setting up dotfiles into $HOMEDIR"
	mkdir -pv $HOMEDIR/.vim/.vimswapfiles
	mkdir -pv $HOMEDIR/.vim/.vimbackupfiles
	mkdir -pv $HOMEDIR/.config/terminator
	mkdir -pv $HOMEDIR/.config/Code/User

	echo "Set up symlinks to $HOMEDIR"
	ln -sv $PWD/.vimrc $HOMEDIR 
	ln -sv $PWD/.zshrc $HOMEDIR
	ln -sv $PWD/snippets $HOMEDIR/.vim/
	ln -sv $PWD/.i3 $HOMEDIR
	ln -sv $PWD/.i3status.conf $HOMEDIR
	ln -sv $PWD/terminator_config $HOMEDIR/.config/terminator/config
	ln -sv $PWD/settings.json $HOMEDIR/.config/Code/User/
	ln -sv $PWD/keybindings.json $HOMEDIR/.config/Code/User/
	ln -sv $PWD/.Xresources $HOMEDIR
	ln -sv $PWD/.doom.d $HOMEDIR
}

setup_doomemacs() {
	echo "Installing doom emacs"
	git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
	$HOMEDIR/.emacs.d/bin/doom install
	$HOMEDIR/.emacs.d/bin/doom sync
}

setup_vim() {
	echo "Cloning Vundle repo into $HOMEDIR/.vim/bundle/Vundle.vim"
	git clone https://github.com/VundleVim/Vundle.vim.git $HOMEDIR/.vim/bundle/Vundle.vim

	echo "Installing vim plugins using Vundle"
	vim +PluginInstall +qall
}

setup_sh() {
	echo "Set zsh as default shell"
	chsh -s $(which zsh)
}

HOMEDIR=${1:-/home/$USER}/

echo "Setting up system"
read -p "Do you want to install default applications? [y/N] " yn
case $yn in
	[Yy]) 
		install_applications
		;;
	*)
		;;
esac

setup_git
setup_directories_and_dotfiles
setup_vim
setup_doomemacs
setup_sh

# Missing, rclone + systemd job, vscode
