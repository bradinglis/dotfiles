local Hydra = require('hydra')
local cmd = require('hydra.keymap-util').cmd

local hint = [[
              󰭎 Find
  _f_: files            _g_: live grep  
  _b_: buffers
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
          { 'f', cmd 'Telescope find_files' },
          { 'g', cmd 'Telescope live_grep' },
          { 'b', cmd 'Telescope buffers' },
          { '<Enter>', cmd 'Telescope', { exit = true, desc = 'list all pickers' } },
          { '<Esc>', nil, { exit = true, nowait = true } },
       }
    })
}
