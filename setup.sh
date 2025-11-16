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
fullname=""
read -p "Enter fullname: " fullname

gemail=""
read -p "Enter global email: " gemail

zemail=""
read -p "Enter zettel email [blank does not set]: " zemail

demail_prompt="Enter dotfiles email [$zemail]: "
if [ -z "$zemail" ]; then
  demail_prompt="Enter dotfiles email [blank does not set]: "
fi

demail=""
read -p "$demail_prompt" demail

if [ -z "$demail" ]; then
  demail="$zemail"
fi

zettel=""
read -p "Enter zettel repo: " zettel

sudo echo ""

mkdir -p ~/.local/bin

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
sudo apt-get -y -o Dpkg::Progress-Fancy="1" -qq install ripgrep nodejs fd-find bat less nnn neovim stow zsh git pandoc curl clang zip unzip moreutils jq

ln -s $(which fdfind) ~/.local/bin/fd

ln -s $(which batcat) ~/.local/bin/bat
mkdir -p "$(batcat --config-dir)/themes"
curl https://raw.githubusercontent.com/neuromaancer/everforest_collection/main/bat/everforest-soft.tmTheme > "$(batcat --config-dir)/themes/everforest-soft.tmTheme"

batcat cache --build
echo -e "${BOLD}${GREEN}Complete${NONE}"
echo -e ""

echo -e "${BOLD}Setting up clipboard tools${NONE}"
mkdir -p ~/for-windows
curl -L https://github.com/memoryInject/wsl-clipboard/releases/download/v0.1.0/wclip.exe -o ~/for-windows/wclip.exe
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

if [ -n "$fullname" ]; then
  git config --global user.name $fullname
fi 

if [ -n "$gemail" ]; then
  git config --global user.email $gemail
fi 

echo -e "${BOLD}${GREEN}Complete${NONE}"
echo -e ""

echo -e "${BOLD}Installing lazygit${NONE}"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
echo -e "${BOLD}${GREEN}Complete${NONE}"
echo -e ""
 

echo -e "${BOLD}Installing tree-sitter${NONE}"
TREESITTER_VERSION=$(curl -s "https://api.github.com/repos/tree-sitter/tree-sitter/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo tree-sitter.gz "https://github.com/tree-sitter/tree-sitter/releases/download/v${TREESITTER_VERSION}/tree-sitter-linux-x64.gz"
gunzip tree-sitter.gz
chmod +x tree-sitter
mv tree-sitter ~/.local/bin
echo -e "${BOLD}${GREEN}Complete${NONE}"
echo -e ""

echo -e "${BOLD}Installing oh-my-posh${NONE}"
curl -L https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -o ~/.local/bin/oh-my-posh
chmod +x ~/.local/bin/oh-my-posh
echo -e "${BOLD}${GREEN}Complete${NONE}"
echo -e ""

echo -e "${BOLD}Installing fzf${NONE}"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
chmod +x ~/.fzf/install
~/.fzf/install
ln -s ~/.fzf/bin/fzf ~/.local/bin/fzf
echo -e "${BOLD}${GREEN}Complete${NONE}"
echo -e ""

echo -e "${BOLD}Sourcing dotfiles${NONE}"
cd $HOME

git clone https://github.com/bradinglis/dotfiles.git
cd ./dotfiles

if [ -n "$demail" ]; then
  git config user.email $demail
fi 

stow .
cp ./useful-other/clipboard.ahk ~/for-windows

nvim --headless -E '+Lazy install' +qall

sleep 5

nvim --headless -E +MasonInstallAll +qall

echo -e "${BOLD}${GREEN}Complete${NONE}"
echo -e ""

cd $HOME
git clone $zettel zettel
cd zettel

if [ -n "$zemail" ]; then
  git config user.email $zemail
fi 
cd $HOME

rm -r lazygit lazygit.tar.gz nodesource_setup.sh

echo -e "${BOLD}Starting Shell${NONE}"
sudo chsh -s /usr/bin/zsh $(whoami)

explorer.exe ~/for-windows/
echo -e "${BOLD}${GREEN}Success${NONE}"
echo -e "${BOLD}${YELLOW}Please move 'wclip.exe' to the windows path${NONE}"

rm -- "$0"

zsh


