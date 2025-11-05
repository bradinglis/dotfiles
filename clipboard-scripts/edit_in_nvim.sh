#!/bin/sh

alias pbcopy='xargs -0 -I % powershell.exe -c "Set-Clipboard -Value @\"
%
\"@"'
alias pbpaste='powershell.exe Get-Clipboard'

pbpaste | 
  vipe | 
  pbcopy
