#!/bin/sh

alias pbcopy='xargs -0 -I % powershell.exe -c "Set-Clipboard -Value @\"
%
\"@ -AsHtml"'
alias pbpaste='powershell.exe Get-Clipboard'

pbpaste | 
  pandoc -f commonmark-smart -t html |
  pbcopy


