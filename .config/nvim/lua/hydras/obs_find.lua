local Hydra = require('hydra')
local cmd = require('hydra.keymap-util').cmd

local hint = [[
              󰭎 Find
  _n_: notes            _s_: sources
  _a_: authors          _b_: backlinks  
  _t_: tags             
  _f_: files            _g_: live grep  
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
          { 'b', vim.cmd.FindBacklinks },
          { 't', vim.cmd.ObsidianTags },
          { 'n', vim.cmd.ObsidianQuickSwitch },
          { 's', "<cmd>ObsidianQuickSwitch ~<CR>" },
          { 'a', "<cmd>ObsidianQuickSwitch %<CR>" },
          { '<Enter>', cmd 'Telescope', { exit = true, desc = 'list all pickers' } },
          { '<Esc>', nil, { exit = true, nowait = true } },
       }
    })
}
