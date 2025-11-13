
preview () {
  local in_file=$1
  shift
  local ext=$1
  shift
  local selection="$@"

  folder=$(echo "$selection" | cut -d'/' -f1)

  if [ "$ext" != "none" ]; then
    bat_arg="-l $ext"
  fi

  if [ "$selection" = "Edit" ]; then
    echo "Edit selection in Neovim"
  elif [ "$selection" = "Code Format" ]; then
    $HOME/transforms/"$selection" "$in_file" "$ext" | bat -n --color=always $bat_arg
  elif [ "$folder" = "jq" ]; then
    cat "$in_file" | jq -C -f $HOME/transforms/$selection
  elif [ "$folder" = "sh" ]; then
    cat "$in_file" | bash "$selection" | bat -n --color=always $bat_arg
  elif [ "$folder" = "awk-sed" ]; then
    cat "$in_file" | bash "$selection" | bat -n --color=always $bat_arg
  fi
}

header () {
  local in_file=$1
  shift
  local ext=$1
  shift
  local selection="$@"

  folder=$(echo "$selection" | cut -d'/' -f1)

  if [ "$ext" != "none" ]; then
    bat_arg="-l $ext"
  fi

  if [ "$selection" = "Edit" ]; then
    echo "Edit"
  elif [ "$selection" = "Code Format" ]; then
    echo -e "Format for filetype \033[36m${ext}\033[00m"
  elif [ "$folder" = "jq" ]; then
    bat -l jq --color=always --wrap=never -p $HOME/transforms/"$selection" | sed -z 's/ \?\n/ /g' | sed 's/  \+//g'
  elif [ "$folder" = "sh" ]; then
    bat -l sh --color=always --wrap=never -p $HOME/transforms/"$selection" | sed -z 's/ \?\n/ /g' | sed 's/  \+//g'
  elif [ "$folder" = "awk-sed" ]; then
    cat "$in_file" | bash "$selection" | bat -n --color=always $bat_arg
  else
    echo ""
  fi
}


