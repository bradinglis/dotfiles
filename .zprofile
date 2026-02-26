if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.local/share/nvim/mason/bin" ] ; then
    PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
fi

if [ -d "/usr/local/go/bin" ] ; then
    PATH="/usr/local/go/bin:$PATH"
fi

if [ -d "$HOME/.metamorphosis/bin" ] ; then
    PATH="$HOME/.metamorphosis/bin:$PATH"
fi

PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"

export EDITOR=nvim
export VISUAL=nvim
export BAT_THEME="everforest2"
export COLORTERM=truecolor

export TRANSFORMS_REPO="$HOME/transforms"
export TRANSFORMS_LIB="$HOME/.metamorphosis/lib"

export PATH="$HOME/.elan/bin:$PATH"
