# config.nu
#
# Installed by:
# version = "0.109.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R
oh-my-posh init nu --config $'($env.HOME)/.config/omp/theme.toml'
source $"($nu.home-dir)/.cargo/env.nu"

alias v = nvim
alias sv = sudo nvim
alias g = git
alias fdfind = fd
alias lg = lazygit


def --env n [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	^yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != $env.PWD and ($cwd | path exists) {
		cd $cwd
	}
	rm -fp $tmp
}

source ~/.zoxide.nu

$env.config.menus ++= [{
    name: completion_menu
    only_buffer_difference: false # Search is done on the text written after activating the menu
    marker: "| "                  # Indicator that appears with the menu is active
    type: {
        layout: columnar          # Type of menu
        columns: 1                # Number of columns where the options are displayed
        col_width: 20             # Optional value. If missing all the screen width is used to calculate column width
        col_padding: 2            # Padding between columns
    }
    style: {
        text: green                   # Text style
        selected_text: green_reverse  # Text style for selected option
        description_text: yellow      # Text style for description
    }
}]

$env.config.keybindings ++= [
    {
        name: completion_menu
        modifier: control
        keycode: char_n
        mode: [emacs vi_normal vi_insert]
        event: {
            until: [
                { 
                  send: menu 
                  name: completion_menu 
                }
                { edit: complete }
            ]
        }
    }
    {
        name: completion_menu
        modifier: control
        keycode: char_j
        mode: [emacs vi_normal vi_insert]
        event: {
            until: [
                { send: menu name: completion_menu }
                { send: menunext }
            ]
        }
    },
    {
        name: completion_menu
        modifier: control
        keycode: char_k
        mode: [emacs vi_normal vi_insert]
        event: {
            until: [
                { send: menu name: completion_menu }
                { send: menuprevious }
            ]
        }
    },
    {
        name: completion_menu
        modifier: control_shift
        keycode: char_l
        mode: [emacs vi_normal vi_insert]
        event: {
            until: [
                { send: historyhintcomplete }
            ]
        }
    },
    {
        name: completion_menu
        modifier: control
        keycode: char_l
        mode: [emacs vi_normal vi_insert]
        event: {
            until: [
                { send: historyhintwordcomplete }
            ]
        }
    }
]

$env.config.edit_mode = 'vi'
