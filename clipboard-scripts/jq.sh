#!/bin/sh

alias pbcopy='clip.exe'
alias pbpaste='powershell.exe Get-Clipboard'

pbpaste | 
  jq | 
  pbcopy
