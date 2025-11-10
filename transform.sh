#!/bin/sh

rows=$(tput lines)

clear
bat -r 0:$(((rows / 2))) -n $CFILE 

script="$(fdfind . $HOME/transforms/ -t executable -x basename | 
  fzf --height=50% --style full --preview 'bat -n --color=always $HOME/transforms/{}' 
)" 

clear
transformed=""
if [ -n "$script" ]; then
  $HOME/transforms/"$script" $CFILE
  $HOME/transform.sh $CFILE
fi
