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
echo -e "${BOLD}Adding APT repositories${NONE}"
sudo add-apt-repository -y ppa:neovim-ppa/unstable
curl -fsSL https://deb.nodesource.com/setup_current.x -o nodesource_setup.sh
sudo -E bash nodesource_setup.sh 
echo -e "${BOLD}${GREEN}Complete${NONE}"
echo -e ""

echo -e "${BOLD}Starting APT update/upgrade${NONE}"
sudo apt-get -y -o Dpkg::Progress-Fancy="1" -qq update 
sudo apt-get -y -o Dpkg::Progress-Fancy="1" -qq upgrade
echo -e "${BOLD}${GREEN}Complete${NONE}"
echo -e ""

echo -e "${BOLD}Starting APT package downloads${NONE}"
sudo apt-get -y -o Dpkg::Progress-Fancy="1" -qq install ripgrep nodejs fd-find bat less nnn neovim stow zsh git pandoc curl clang zip unzip moreutils

ln -s /usr/bin/batcat ~/.local/bin/bat
mkdir -p "$(batcat --config-dir)/themes"
curl https://raw.githubusercontent.com/neuromaancer/everforest_collection/main/bat/everforest-soft.tmTheme > "$(batcat --config-dir)/themes/everforest-soft.tmTheme"

batcat cache --build
echo -e "${BOLD}${GREEN}Complete${NONE}"
echo -e ""

echo -e "${BOLD}Installing lazygit${NONE}"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
echo -e "${BOLD}${GREEN}Complete${NONE}"
echo -e ""

echo -e "${BOLD}Installing fzf${NONE}"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
chmod +x ~/.fzf/install
~/.fzf/install
echo -e "${BOLD}${GREEN}Complete${NONE}"
echo -e ""

cd $HOME

rm -r lazygit lazygit.tar.gz nodesource_setup.sh
