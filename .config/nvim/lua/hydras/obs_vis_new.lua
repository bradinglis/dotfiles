local Hydra = require('hydra')
local vault_actions = require'vault_actions'

local hint = [[
              󱓧 New
  _n_: note              _p_: append note 
  _s_: source            _a_: author  
              _<Esc>_         
]]

return {
    hydra = Hydra({
       name = 'New Note',
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
       mode = 'v',
       heads = {
           { 's', vault_actions.new_source },
           { 'n', vault_actions.new_note },
           { 'a', vault_actions.new_author },
           { 'p', vault_actions.append_to_note },
           { '<Esc>', nil, { exit = true, nowait = true } },
       }
    })
}
