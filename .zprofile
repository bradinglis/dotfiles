if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.local/share/nvim/mason/bin" ] ; then
    PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
fi

fpath=( ~/lib "${fpath[@]}" )
export EDITOR=nvim
export VISUAL=nvim
