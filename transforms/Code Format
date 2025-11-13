#!/bin/sh

in_file=$1
ext=$2

if [ -z "$ext" ]; then
  read -p "Ext?: " ext
fi

if [ -z "$ext" ]; then
  exit 1
fi

echo "$ext" > /tmp/ext

if [ "$ext" = "json" ]; then
  cat "$in_file" | prettierd "something.$ext"
fi


