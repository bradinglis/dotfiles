# env.nu
#
# Installed by:
# version = "0.109.1"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.

use std/util "path add"

path add $"($nu.home-path)/bin"
path add $"($nu.home-path)/.local/bin"
path add $"($nu.home-path)/.local/share/nvim/mason/bin"
path add $"($nu.home-path)/.metamorphosis/bin"
path add $"($nu.home-path)/.fzf/bin"
path add $"/usr/local/go/bin"
path add $"($nu.home-path)/.ghcup/bin"
path add $"($nu.home-path)/.cabal/bin"
path add $"($nu.home-path)/.elan/bin"



$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
$env.BAT_THEME = "everforest2"
$env.COLORTERM = "truecolor"

$env.TRANSFORMS_REPO = "$HOME/transforms"
$env.TRANSFORMS_LIB = "$HOME/.metamorphosis/lib"


zoxide init nushell | save -f ~/.zoxide.nu
source $"($nu.home-path)/.cargo/env.nu"
