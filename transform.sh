#!/bin/bash

source "$HOME"/.profile

html_copy () {
  if [ "$1" = "md" ]; then
    input=$(cat - | pandoc -f commonmark -t html | sed "/id=\"cb[0-9]\+-[0-9]\+/ s/<\/span>$/&<br>/")
  elif [ -n "$1" ]; then
    md=$(echo "\`\`\`$1"
    cat -
    echo "\`\`\`")
    input=$(echo "$md" | pandoc -f commonmark -t html | sed "/id=\"cb[0-9]\+-[0-9]\+/ s/<\/span>$/&<br>/")
  else
    input=$(cat -)
  fi
  powershell.exe -NoProfile -Command "Set-Clipboard -Value @\"
$input
\"@ -AsHtml"
}

echo "" > /tmp/ext
echo "" > /tmp/interrupt

lib="$HOME/lib/transform_lib.sh"

NONE='\033[00m'
BLACK='\033[30m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
PURPLE='\033[35m'
BLUE='\033[34m'
CYAN='\033[36m'
WHITE='\033[37m'
BOLD='\033[1m'
ITALIC='\033[3m'
HIGHLIGHT='\033[47m'
UNDERLINE='\033[4m'

out_file="/tmp/transform_output"

in_file=$(readlink -f $1)
ext=$2

if [ -z "$ext" ]; then
  base_filename=$(basename -- "$in_file")
  file_extension="${base_filename##*.}"
  if [ "$file_extension" != "$base_filename" ]; then
    ext=$file_extension
  fi
fi


temp_ext="$ext"
if [ -z "$ext" ]; then
  temp_ext="none"
fi

if [ -n "$ext" ]; then
  bat_arg="-l$ext"
fi

sed -i -z "s/\n\?$/\n/g" $in_file

cd "$HOME"/transforms/

# clear
rows=$(tput lines)
cols=$(tput cols)
in_lines=$(wc -l < $in_file)

lines_left=$((rows - 13))
input_preview=$((lines_left/2))

if [ "$in_lines" -lt $input_preview ]; then
  input_preview=$in_lines 
fi

output_preview=$((lines_left - input_preview))


header=$(bat -P -r 0:$input_preview -n "$in_file" --color=always $bat_arg)

# clear

if [ -n "$ext" ]; then
  label_ext="[$ext] "
fi

export FZF_DEFAULT_COMMAND="find . -type f -printf '%T@ %p\n' | sort -k 1 -nr | sed 's/^[^ ]* \.\?\/\?//g'"
script="$(fzf --style minimal \
    --input-border=horizontal \
    --border=horizontal \
    --color="input-label:green,pointer:red,label:-1:bold,preview-label:-1:bold,current-fg:-1,current-hl:bright-cyan" \
    --border-label=" Input $label_ext" \
    --layout=reverse \
    --preview="source '$lib'; preview $in_file $temp_ext '{}'" \
    --bind "focus:transform-footer:source '$lib'; header $in_file $temp_ext '{}'" \
    --preview-window=down,$output_preview \
    --info=inline-right \
    --header="$header" \
    --header-first \
    --preview-label=" Output " \
    --bind="ctrl-f:execute(echo filetype > /tmp/interrupt)+abort" \
    --bind="ctrl-t:execute(echo {} > /tmp/interrupt)+abort" \
    --bind="ctrl-a:execute(echo html_copy > /tmp/interrupt)+abort" \
    --bind="ctrl-e:execute(echo edit > /tmp/interrupt)+abort" \
    --input-label=" <C-f>: filetype | <C-e>: edit input | <C-t>: edit transform | <C-a>: rich copy " --input-label-pos=bottom \
)" 

# clear

interrupt=$(cat /tmp/interrupt)

echo "" > /tmp/interrupt

if [ -n "$script" ]; then
  arr_script=(${script//\// })

  if [ "${arr_script[0]}" == "jq" ]; then
    ext="json"
    cat "$in_file" | jq -f $HOME/transforms/$script > "$out_file"
    mv "$out_file" "$in_file"
  elif [ "${arr_script[0]}" == "sh" ]; then
    cat "$in_file" | bash "$script" > "$out_file"
    mv "$out_file" "$in_file"
  elif [ "${arr_script[0]}" == "awk-sed" ]; then
    cat "$in_file" | bash "$script" > "$out_file"
    mv "$out_file" "$in_file"
  elif [ "$script" == "format.sh" ]; then
    $HOME/transforms/"$script" "$in_file" "$ext" > "$out_file"
    mv "$out_file" "$in_file"
  else
    if [ -z "$ext" ]; then
      read -r -p "Ext?: " ext
    fi
    $HOME/transforms/"$script" $in_file $ext
  fi

  new_ext=$(cat /tmp/ext)

  if [ -n "$new_ext" ]; then
    echo "" > /tmp/ext
    ext="$new_ext"
  fi

  "$0" $in_file $ext
fi

if [ -n "$interrupt" ]; then
  if [ "$interrupt" == "html_copy" ]; then
    cat "$in_file" | html_copy $ext
    echo "<no-copy>" > $in_file
  elif [ "$interrupt" == "filetype" ]; then
    read -r -p "Ext?: " ext
    bash "$0" $in_file $ext
  elif [ "$interrupt" == "edit" ]; then
    if [ -z "$ext" ]; then
      read -r -p "Ext?: " ext
    fi
    $HOME/transforms/edit.sh "$in_file" "$ext"
    bash "$0" $in_file $ext
  else 
    nvim -c "lua require('transforms.playground').init_playground(\"$in_file\",\"$interrupt\",\"$ext\")"

    bash "$0" $in_file $ext
  fi
fi

