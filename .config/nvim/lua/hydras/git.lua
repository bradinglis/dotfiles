local Hydra = require('hydra')
local cmd = require('hydra.keymap-util').cmd

local hint = [[
              󰊢 Git
  _b_: branches         _s_: status
  _c_: commits
  _<Enter>_: Telescope  _<Esc>_         
]]

return {
    hydra = Hydra({
       name = 'Telescope',
       hint = hint,
       config = {
          color = 'teal',
          invoke_on_body = true,
          hint = {
              offset = 1,
              position = 'bottom',
              float_opts = {
                  border = "solid",
              }
          },
       },
       mode = 'n',
       heads = {
          { 'b', cmd 'Telescope git_branches' },
          { 'c', cmd 'Telescope git_commits' },
          { 's', cmd 'Telescope git_status' },
          { '<Enter>', cmd 'Telescope', { exit = true, desc = 'list all pickers' } },
          { '<Esc>', nil, { exit = true, nowait = true } },
       }
    })
}
