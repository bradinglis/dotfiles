local Hydra = require('hydra')
local vault_actions = require'vault_actions'

local hint = [[
               Delete
  _e_: emph/italics '*'  _b_: bold '**'  
  _h_: highlight '=='    _c_: code '`'  
                _<Esc>_         
]]

local function delete_surround(surround)
    for c in surround:gmatch(".") do
        vim.api.nvim_feedkeys("ds" .. c, "m", false)
    end
end

return {
    hydra = Hydra({
       name = 'Delete',
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
           { 'h', function () delete_surround('==') end },
           { 'b', function () delete_surround('**') end },
           { 'e', function () delete_surround('*') end },
           { 'c', function () delete_surround('`') end },
           { '<Esc>', nil, { exit = true, nowait = true } },
       }
    })
}
