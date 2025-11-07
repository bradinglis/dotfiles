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
echo "${BOLD}Adding APT repositories${NONE}"
sudo add-apt-repository -y ppa:neovim-ppa/unstable
curl -fsSL https://deb.nodesource.com/setup_current.x -o nodesource_setup.sh
sudo -E bash nodesource_setup.sh
echo "${BOLD}${GREEN}Complete${NONE}"
echo ""

echo "${BOLD}Starting APT update/upgrade${NONE}"
sudo apt-get -y -q update
sudo apt-get -y -q upgrade
echo "${BOLD}${GREEN}Complete${NONE}"
echo ""

echo "${BOLD}Starting APT package downloads${NONE}"
sudo apt-get -y -q install nodejs fdfind fzf bat less nnn neovim stow zsh git pandoc curl
echo "${BOLD}${GREEN}Complete${NONE}"
echo ""

echo "${BOLD}Setting up git credential mannager${NONE}"
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
git config --global credential.https://dev.azure.com.useHttpPath true
echo "${BOLD}${GREEN}Complete${NONE}"
echo ""

echo "${BOLD}Installing lazygit${NONE}"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
echo "${BOLD}${GREEN}Complete${NONE}"
echo ""
 
echo "${BOLD}Installing oh-my-posh${NONE}"
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
echo "${BOLD}${GREEN}Complete${NONE}"
echo ""

echo "${BOLD}Sourcing dotfiles${NONE}"
cd $HOME
git clone https://github.com/bradinglis/dotfiles.git

cd ./dotfiles
stow .
echo "${BOLD}${GREEN}Complete${NONE}"
echo ""

cd $HOME

echo "${BOLD}Starting Shell${NONE}"
chsh -s zsh
zsh

