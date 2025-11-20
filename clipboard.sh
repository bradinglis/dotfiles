#!/bin/bash

. ~/.profile
export EDITOR=nvim
export VISUAL=nvim
PATH="$HOME/.local/bin:$PATH"
PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"
export BAT_THEME="everforest2"

export CFILE=/tmp/clipboard

win32yank -o > $CFILE
rm -f /tmp/ext

bash $HOME/transform.sh $CFILE

tocopy=$(cat $CFILE)

if [ "$tocopy" != "<no-copy>" ]; then
  echo -E "$tocopy" |
  sed -z "s/\n$//g" |
  wcopy
fi

