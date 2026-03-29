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

path add $"($nu.home-dir)/bin"
path add $"($nu.home-dir)/.local/bin"
path add $"($nu.home-dir)/.local/share/nvim/mason/bin"
path add $"($nu.home-dir)/.metamorphosis/bin"
path add $"($nu.home-dir)/.fzf/bin"
path add $"/usr/local/go/bin"
path add $"($nu.home-dir)/.ghcup/bin"
path add $"($nu.home-dir)/.cabal/bin"
path add $"($nu.home-dir)/.elan/bin"



$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
$env.BAT_THEME = "everforest2"
$env.COLORTERM = "truecolor"

$env.TRANSFORMS_REPO = "$HOME/transforms"
$env.TRANSFORMS_LIB = "$HOME/.metamorphosis/lib"


zoxide init nushell | save -f ~/.zoxide.nu
source $"($nu.home-dir)/.cargo/env.nu"
