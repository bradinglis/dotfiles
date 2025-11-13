#!/bin/bash

. ~/.profile
export EDITOR=nvim
export VISUAL=nvim
PATH="$HOME/.local/bin:$PATH"
PATH="${PATH:+${PATH}:}/home/inglisb/.fzf/bin"
export BAT_THEME="everforest-soft"

export CFILE=/tmp/clipboard

wpaste > $CFILE
rm -f /tmp/ext

bash $HOME/transform.sh $CFILE

tocopy=$(cat $CFILE)

if [ "$tocopy" != "<no-copy>" ]; then
  echo -E "$tocopy" |
  sed -z "s/\n$//g" |
  wcopy
fi

