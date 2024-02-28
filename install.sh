#!/bin/bash

install_packages() {
    echo -e "[setup] ->> updating packages"
    sudo apt-get update
    sudo apt-get upgrade

    echo -e "\n\n\n\n[setup] ->> installing development tools"
    sudo apt install \
    	git \
        zsh \
    	curl \
        tmux \

    echo -e "\n\n\n\n[setup] ->> installing essential packages"
    sudo apt install \
    	build-essential \
    	cmake \
    	pkg-config \
    	libfreetype6-dev \
    	libfontconfig1-dev \
    	libxcb-xfixes0-dev \
    	libxkbcommon-dev \
    	python3 \
        xclip \
        fd-find \
        jq

    echo -e "\n\n\n\n[setup] ->> installing fonts"
    sudo apt install \
        fonts-firacode
}

setup_shell() {
    if [ -n "$ZSH_VERSION" ]; then
    	echo -e "[setup] ->> zsh is already installed"
    else
    	chsh -s $(which zsh)
    	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
}

runtime_cargo() {
    if ! command cargo &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        source ~/.zshenv
    else
        echo "[setup] ->> rust is already installed"
    fi
}

runtime_go() {
    if ! command -v go &> /dev/null; then
        go_version=$(curl -sS https://go.dev/dl/?mode=json | jq -r '.[0].version')
        wget "https://go.dev/dl/$go_version.linux-amd64.tar.gz"
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf $go_version.linux-amd64.tar.gz
        rm -f $go_version.linux-amd64.tar.gz
    else
        echo "[setup] ->> go is already installed"
    fi
}

runtime_node() {
    if ! command -v nvm &> /dev/null; then
        nvm_version=$(curl -sS "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | jq -r '.tag_name')

        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$nvm_version/install.sh | bash
        nvm install --lts
        npm install -g
    else
        echo "[setup] ->> node is already installed"
    fi
}

runtime_docker() {
    if ! command -v docker &> /dev/null; then
        curl -o- https://get.docker.com | bash
        sudo usermod -aG docker $USER
        newgrp docker
    else
        echo "[setup] ->> docker is already installed"
    fi
}

install_runtimes() {
    echo -e "\n\n\n\n[setup] ->> runtimes"
    runtime_cargo
    runtime_node
    runtime_go
    runtime_docker
}

install_tools_from_pkg_managers() {
    cargo install tree-sitter-cli
    cargo install ripgrep
}

setup_editor() {
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    sudo mv ./nvim.appimage /usr/bin/nvim
}

setup_term() {
    echo -e "\n\n\n\n[setup] ->> terminal"
    if [ -e "$HOME/.local/kitty.app/bin/kitty"]; then
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    	sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $HOME/.local/kitty.app/bin/kitty 50
    else
       	echo "[setup] ->> alacritty is already installed"
    fi
}

symlink_configs() {
    rm -f ~/.config/nvim && ln -s ~/dotfiles/nvim ~/.config/nvim
    rm -f ~/.tmux.conf && ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
    rm -f ~/.zshrc && ln -s ~/dotfiles/.zshrc ~/.zshrc
    rm -f ~/.gitconfig && ln -s ~/dotfiles/.gitconfig ~/.gitconfig
    rm -f ~/.gitconfig-work && ln -s ~/dotfiles/.gitconfig-work ~/.gitconfig-work
    rm -f ~/.config/kitty/kitty.conf && ln -s ~/dotfiles/kitty.conf ~/.config/kitty/kitty.conf
}

install_packages
setup_shell
install_runtimes
install_tools_from_pkg_managers
setup_editor
setup_term
symlink_configs
runtime_node
