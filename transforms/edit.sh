#!/bin/bash

in_file=$1
ext=$2

if [ -z "$ext" ]; then
  read -r -p "Ext?: " ext
fi

if [ -n "$ext" ]; then
  echo "$ext" > /tmp/ext
  new_clip=$(cat "$in_file" | vipe --suffix="$ext")
  echo -E "$new_clip" > "$in_file"
else
  new_clip=$(cat "$in_file" | vipe)
  echo -E "$new_clip" > "$in_file"
fi

