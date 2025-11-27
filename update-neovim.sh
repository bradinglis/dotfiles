echo -e "${BOLD}Installing Neovim${NONE}"
curl -Lo nvim "https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.appimage"
chmod +x nvim
mv nvim ~/.local/bin
echo -e "${BOLD}${GREEN}Complete${NONE}"
echo -e ""
