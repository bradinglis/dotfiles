local Hydra = require('hydra')
local cmd = require('hydra.keymap-util').cmd

local hint = [[
              󰊢 Git
  _b_: branches         _s_: status
  _w_: list worktrees   _c_: commits          
  _n_: new worktree
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
          { 'w', require('telescope').extensions.git_worktree.git_worktrees },
          { 'n', require('telescope').extensions.git_worktree.create_git_worktree },
          { '<Enter>', cmd 'Telescope', { exit = true, desc = 'list all pickers' } },
          { '<Esc>', nil, { exit = true, nowait = true } },
       }
    })
}
