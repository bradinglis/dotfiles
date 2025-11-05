#!/bin/sh

export EDITOR=nvim
export VISUAL=nvim
PATH="$HOME/.local/bin:$PATH"

alias pbcopy='xargs -0 -I % powershell.exe -NoProfile -Command "Set-Clipboard -Value @\"
%\"@"'

script="/home/inglisb/clipboard-scripts/$(fdfind . '/home/inglisb/clipboard-scripts/' -t executable -x basename | fzf )"

wpaste |
  "$script" |
  pbcopy
  

