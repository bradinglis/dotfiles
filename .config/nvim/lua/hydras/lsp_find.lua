local Hydra = require('hydra')
local cmd = require('hydra.keymap-util').cmd

local hint = [[
                󰭎 Find
  _i_: incoming calls     _r_: references   
  _o_: outgoing calls     _d_: diagnostics  
  _w_: wrkspace symbols   _s_: doc symbols  

  _f_: files              _g_: live grep  
  _b_: buffers
  _<Enter>_: Telescope    _<Esc>_         
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
          { 'b', cmd 'Telescope buffers' },
          { 'g', cmd 'Telescope live_grep' },
          { 'i', cmd 'Telescope lsp_incoming_calls' },
          { 'o', cmd 'Telescope lsp_outgoing_calls' },
          { 'd', require("telescope.builtin").diagnostics },
          { 'w', cmd 'Telescope lsp_workspace_symbols' },
          { 's', cmd 'Telescope lsp_document_symbols' },
          { 'r', cmd 'Telescope lsp_references' },
          { '<Enter>', cmd 'Telescope', { exit = true, desc = 'list all pickers' } },
          { '<Esc>', nil, { exit = true, nowait = true } },
       }
    })
}
