#!/bin/bash

atualizar() {
    sudo apt update
    sudo apt upgrade -y
}

sudo apt install ranger -y
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
)
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
}

snapsinstallI() {
    sudo snap install code -y
    sudo snap install intellij-idea-community --classic -y
}

main() {
    atualizar
    travas_apt

    snapsinstallI
    instalardeb
    limpeza
}
