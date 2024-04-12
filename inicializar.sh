#!/bin/bash

atualizar() {
    sudo apt update
    sudo apt upgrade -y
}

zshinstall() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
    echo "zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions" >> /$HOME/.zshrc

    mkdir ~/.fonts
    wget -P ~/.fonts 'https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/BitstreamVeraSansMono.zip' 
    unzip ~/.fonts/BitstreamVeraSansMono.zip -d ~/.fonts

    if [ -e /$HOME/powerlevel10k ];then
        cp /$HOME/powerlevel10k $HOME/.oh-my-zsh/themes/powerlevel10k
    fi
    echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

    sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc
}

flatpak() {
    sudo apt install flatpak -y
    sudo add-apt-repository ppa:alexlarsson/flatpak
    sudo apt update
    sudo apt install --install-recommends flatpak
}

travas_apt() {
    sudo rm /var/lib/dpkg/lock-frontend
    sudo rm /var/cache/apt/archives/lock
}

instalacaodebarray=(
    "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    "https://objects.githubusercontent.com/github-production-release-asset-2e65be/16408992/612a4416-1cc3-409b-b2f6-17761c1c8976?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAVCODYLSA53PQK4ZA%2F20240407%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20240407T080410Z&X-Amz-Expires=300&X-Amz-Signature=da326590fc234fc1cd7cc3a1a34adf997eb35e3b048cc41d786a02a260b15913&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=16408992&response-content-disposition=attachment%3B%20filename%3Dnvim-linux64.tar.gz&response-content-type=application%2Foctet-stream"
    https://codeload.github.com/dracula/tilix/zip/refs/heads/master
)
installdracula() {
    wget 
}
limpeza() {
    atualizar
    sudo apt autoremove -y
    sudo apt remove -y
}

instalardeb() {

    mkdir $HOME/Downloads/programas

    cd $HOME/Downloads/programas

    for url in "${instalacaodebarray[@]}"; do
        wget $url
    done
    sudo dpkg -i ./*.deb
    if [ -e $HOME/.config/tilix/ ];then
        if [ -e tilix-master.zip ]; then
            unzip tilix-master.zip
            cd tilix-master
            cp Dracula.json $HOME/.conf/tilix/schemes
        fi
        xdg-mime default org.gnome.Terminal.desktop application/x-vnd.vte-terminal
    fi
    
}
aptinstall() {
    apks=("fonts-firacode" "curl" "git" "zsh")
    for apk in "${apks[@]}";do
        sudo apt install "$apk" -y;
    done
}
snapsinstallI() {
    snaps=("ranger" "code --classic" "intellij-idea-community --classic" "tilix")
    for s in "${snaps[@]}";do
        sudo snap install "$s"
    done
}

main() {
    atualizar
    travas_apt
    aptinstall
    zshinstall
    instalardeb
    flatpak
    snapsinstallI
    limpeza
}
main