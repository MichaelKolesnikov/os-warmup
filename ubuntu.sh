#!/bin/bash

sudo apt update && sudo apt upgrade -y

# google chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt install -f
rm google-chrome-stable_current_amd64.deb
echo "Google was installed"

# Brave
if ! command -v brave-browser &> /dev/null; then
    sudo apt install apt-transport-https curl -y
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install brave-browser -y
    echo "brave was intalled"
else
    echo "Brave уже установлен."
fi

# flatpack
if ! command -v flatpak &> /dev/null; then
    if sudo apt install flatpak -y && sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo; then
        echo "Flatpak успешно установлен и настроен"
    else
        echo "Ошибка при установке Flatpak" >&2
        exit 1
    fi
else
    echo "Flatpak уже установлен."
fi

# snapd
if ! command -v snap &> /dev/null; then
    sudo apt install snapd -y
    sudo systemctl enable --now snapd.apparmor
    sudo systemctl start snapd
    echo "snap was intalled"
else
    echo "Snapd уже установлен."
fi

sh <(curl -L https://nixos.org/nix/install) --daemon

# VSCode
if ! command -v code &> /dev/null; then
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt update
    sudo apt install code -y
    echo "vs code was intalled"
else
    echo "Visual Studio Code уже установлен."
fi

# Git
if ! command -v git &> /dev/null; then
    sudo apt install git -y
    echo "git was intalled"
else
    echo "Git уже установлен."
fi

# virt-manager
if ! command -v virt-manager &> /dev/null; then
    sudo apt install virt-manager -y
    echo "virt-manager was intalled"
else
    echo "virt-manager уже установлен."
fi

# Obsidian
if ! command -v obsidian &> /dev/null; then
    OBSIDIAN_LATEST=$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | grep browser_download_url | grep amd64.deb | cut -d '"' -f 4)
    wget -O obsidian_latest.deb "$OBSIDIAN_LATEST"
    sudo dpkg -i obsidian_latest.deb
    sudo apt -f install -y # Для устранения возможных зависимостей
    rm obsidian_latest.deb
    echo "obsidian was intalled"
else
    echo "Obsidian уже установлен."
fi

# Bottle
if ! flatpak list | grep -q "com.usebottles.bottles"; then
    flatpak install flathub com.usebottles.bottles -y
    echo "bottle was intalled"
else
    echo "Bottle уже установлен."
fi

# VLC
if ! command -v vlc &> /dev/null; then
    sudo apt install vlc -y
    echo "vlc was intalled"
else
    echo "VLC уже установлен."
fi

# PyCharm
if ! snap list | grep -q "pycharm-community"; then
    sudo snap install pycharm-community --classic
    echo "pycharm was intalled"
else
    echo "PyCharm уже установлен."
fi

# Discord
if ! snap list | grep -q "discord"; then
    sudo snap install discord
    echo "discord was intalled"
else
    echo "Discord уже установлен."
fi


wget https://download.oracle.com/java/23/latest/jdk-23_linux-x64_bin.deb
sudo dpkg -i jdk-23_linux-x64_bin.deb
rm jdk-23_linux-x64_bin.deb
echo "jdk23 was intalled"

wget https://blog.llinh9ra.ru/wp-content/uploads/2022/12/jetbra-ded4f9dc4fcb60294b21669dafa90330f2713ce4.zip
unzip jetbra-ded4f9dc4fcb60294b21669dafa90330f2713ce4.zip -d ~/
rm jetbra-ded4f9dc4fcb60294b21669dafa90330f2713ce4.zip
bash ~/jetbra/scripts/install.sh

# pdf & images processing
sudo apt-get install pdftk imagemagick

# pyenv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
exec "$SHELL"
sudo apt install build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl git \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
echo "pyenv was intalled"


# docker
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo systemctl status docker
sudo usermod -aG docker ${USER}
su - ${USER}
id -nG


# tex & typst
sudo apt install texlive-xetex texlive-lang-cyrillic texlive-fonts-recommended texlive-fonts-extra ttf-mscorefonts-installer texlive-latex-extra
sudo snap install typst

# hunspell
sudo apt install hunspell hunspell-ru hunspell-en-us libhunspell-dev

# KeePassXC
flatpak install --user flathub org.keepassxc.KeePassXC

# VPN
sudo apt install openresolv wireguard

# Qt5
sudo apt install qtcreator qtbase5-dev qtbase5-dev-tools qtchoose cmake clang libqt5pdf5 libqt5pdfwidgets5 qtpdf5-dev poppler-utils

# yandex disk
echo "deb http://repo.yandex.ru/yandex-disk/deb/ stable main" | sudo tee /etc/apt/sources.list.d/yandex-disk.list
wget https://repo.yandex.ru/yandex-disk/YANDEX-DISK-KEY.GPG -O- | sudo apt-key add -
sudo apt update
sudo apt install yandex-disk
yandex-disk setup

# Rust
sudo snap install rustup --classic
rustup default stable
rustup update

sudo snap install postman

flatpak install flathub org.telegram.desktop

flatpak install flathub com.obsproject.Studio
