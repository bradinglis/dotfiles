#!/bin/sh

export EDITOR=nvim
export VISUAL=nvim
PATH="$HOME/.local/bin:$PATH"
PATH="${PATH:+${PATH}:}/home/inglisb/.fzf/bin"
export BAT_THEME="everforest-soft"

export CFILE=/tmp/clipboard

wpaste > $CFILE

$HOME/transform.sh $CFILE

cat $CFILE |
  sed -z "s/\n$//g" |
  wcopy

