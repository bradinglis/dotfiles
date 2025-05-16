local Hydra = require('hydra')
local cmd = require('hydra.keymap-util').cmd

local hint = [[
              󰭎 Find
  _n_: notes            _s_: sources
  _a_: authors          _l_: backlinks  
  _t_: tags             _x_: all        
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
          { 'g', vim.cmd.ObsidianSearch },
          { 'l', vim.cmd.FindBacklinks },
          { 'b', cmd 'Telescope buffers' },
          { 't', vim.cmd.ObsidianTags },
          { 'n', require'vault.note_search' },
          { 's', require'vault.source_search' },
          { 'a', require'vault.author_search' },
          { 'x', require'vault.all_search' },
          { '<Enter>', cmd 'Telescope', { exit = true, desc = 'list all pickers' } },
          { '<Esc>', nil, { exit = true, nowait = true } },
       }
    })
}
