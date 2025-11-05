#!/bin/sh

alias pbcopy='clip.exe'
alias pbpaste='powershell.exe Get-Clipboard'

pbpaste | 
  sed 's/\(.*\)\r/TC\1 Pass/g' | 
  pbcopy
