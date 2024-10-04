#!/bin/bash

atualizar() {
    sudo apt update
    sudo apt upgrade -y
}

configkitty(){
    wget -O "$HOME"/kitty-master.zip https://github.com/dracula/kitty/archive/master.zip
    git clone https://github.com/Kiritogtsa/ubuntushellautomacao.git
    mkdir -p "$HOME"/.config/kitty
    cp ubuntushellautomacao/config/kitty.config "$HOME"/.config/kitty/kitty.conf
}

zshinstall() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
    chsh -s "$(which zsh)" 
    echo "zinit light zdharma-continuum/fast-syntax-highlighting
    zinit light zsh-users/zsh-autosuggestions
    zinit light zsh-users/zsh-completions" >> "$HOME"/.zshrc
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
    mkdir -p ~/.fonts
    wget -P ~/.fonts 'https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/BitstreamVeraSansMono.zip' 
    unzip ~/.fonts/BitstreamVeraSansMono.zip -d ~/.fonts
    fc-cache -fv
    # echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> "$HOME"/.zshrc
    sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' "$HOME"/.zshrc
}

flatpak() {
    sudo add-apt-repository ppa:flatpak/stable
    sudo apt update
    sudo apt install flatpak -y
    sudo apt install gnome-software --install-suggests -y
    sudo apt install gnome-software-plugin-flatpak
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    sudo apt install --install-recommends flatpak -y
}

travas_apt() {
    sudo rm /var/lib/dpkg/lock-frontend
    sudo rm /var/cache/apt/archives/lock
}

instalacaodebarray=(
    "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    "https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb"
)

limpeza() {
    atualizar
    sudo apt autoremove -y
    sudo apt remove -y
}

instalardeb() {
    mkdir -p "$HOME"/Downloads/programas
    cd "$HOME"/Downloads/programas

    for url in "${instalacaodebarray[@]}"; do
        wget "$url"
    done
    sudo dpkg -i ./*.deb
    sudo apt install -f -y  # Corrige as dependecias que talveis estejam quebradas
}

aptinstall() {
    apks=("fonts-firacode" "curl" "git" "kitty" "tmux")
    for apk in "${apks[@]}"; do
        sudo apt install "$apk" -y
    done
}

snapsinstall() {
    snaps=("ranger" "code --classic" "intellij-idea-community --classic")
    for s in "${snaps[@]}"; do
        sudo snap install "$s"
    done
}

main() {
    if [ "$1" = "" ]; then
        atualizar
        travas_apt
        aptinstall
        instalardeb
        flatpak
        snapsinstall
        configkitty
        limpeza   
       
    elif [ "$1" ==  "zsh_confi" ];then
        atualizar
        zshinstall
        limpeza   
    else 
        echo "nada " 
    fi 
    
}

main "$1"
