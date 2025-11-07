#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
NONE='\033[00m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
PURPLE='\033[35m'
BLUE='\033[34m'
CYAN='\033[36m'
WHITE='\033[37m'
BOLD='\033[1m'
ITALIC='\033[3m'
UNDERLINE='\033[4m'

cd $HOME

mkdir -p ~/.local/bin

echo -e "${BOLD}Adding APT repositories${NONE}"
sudo add-apt-repository -y ppa:neovim-ppa/unstable > /dev/null
curl -fsSL https://deb.nodesource.com/setup_current.x -o nodesource_setup.sh
sudo -E bash nodesource_setup.sh &> /dev/null
echo -e "${BOLD}${GREEN}Complete${NONE}"
echo -e ""

echo -e "${BOLD}Starting APT update/upgrade${NONE}"
sudo apt-get -y -o Dpkg::Progress-Fancy="1" -qq update 
sudo apt-get -y -o Dpkg::Progress-Fancy="1" -qq upgrade
echo -e "${BOLD}${GREEN}Complete${NONE}"
echo -e ""

echo -e "${BOLD}Starting APT package downloads${NONE}"
sudo apt-get -y -o Dpkg::Progress-Fancy="1" -qq install nodejs fd-find fzf bat less nnn neovim stow zsh git pandoc curl clang zip unzip moreutils

ln -s /usr/bin/batcat ~/.local/bin/bat
mkdir -p "$(bat --config-dir)/themes"
curl https://raw.githubusercontent.com/neuromaancer/everforest_collection/main/bat/everforest-soft.tmTheme > "$(bat --config-dir)/themes/everforest-soft.tmTheme"

batcat cache --build
echo -e "${BOLD}${GREEN}Complete${NONE}"
echo -e ""

echo -e "${BOLD}Setting up clipboard tools${NONE}"
curl -L https://github.com/memoryInject/wsl-clipboard/releases/download/v0.1.0/wclip.exe -o ~/wclip.exe
curl -L https://github.com/memoryInject/wsl-clipboard/releases/download/v0.1.0/wcopy -o ~/.local/bin/wcopy
chmod +x ~/.local/bin/wcopy
curl -L https://github.com/memoryInject/wsl-clipboard/releases/download/v0.1.0/wpaste -o ~/.local/bin/wpaste
chmod +x ~/.local/bin/wpaste
echo -e "${BOLD}${GREEN}Complete${NONE}"
echo -e ""

echo -e "${BOLD}Setting up git credential mannager${NONE}"
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
git config --global credential.https://dev.azure.com.useHttpPath true
git config --global pull.rebase true
git config --global user.name "Brad Inglis"
echo -e "${BOLD}${GREEN}Complete${NONE}"
echo -e ""

echo -e "${BOLD}Installing lazygit${NONE}"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
echo -e "${BOLD}${GREEN}Complete${NONE}"
echo -e ""
 
echo -e "${BOLD}Installing oh-my-posh${NONE}"
curl -L https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -o ~/.local/bin/oh-my-posh
chmod +x ~/.local/bin/oh-my-posh
echo -e "${BOLD}${GREEN}Complete${NONE}"
echo -e ""

echo -e "${BOLD}Sourcing dotfiles${NONE}"
cd $HOME
git clone https://github.com/bradinglis/dotfiles.git


cd ./dotfiles
git config user.email "brad.inglis@gmail.com"
stow .

nvim --headless -E '+Lazy install' +MasonInstallAll +qall

echo -e "${BOLD}${GREEN}Complete${NONE}"
echo -e ""

cd $HOME

rm -r lazygit lazygit.tar.gz nodesource_setup.sh

echo -e "${BOLD}Starting Shell${NONE}"
sudo chsh -s /usr/bin/zsh
zsh

