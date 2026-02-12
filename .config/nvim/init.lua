-- keeping
vim.loader.enable()

-- TODO: fork obsidian and consolidate config etc there.
-- TODO: make globals handling cleaner -- probably don't need the functions and can cover stuff with environment variables.
-- TODO: handle weird keybinds as if they were plugins to allow lazy loading. Stuff like `vault` becomes part of the obsidian fork but other stuff for whipping up windows and stuff can be handled betterr.

_G.dd = function(...)
  require("snacks").debug.inspect(...)
end

_G.bt = function()
  require("snacks").debug.backtrace()
end

if vim.fn.has("nvim-0.11") == 1 then
  vim._print = function(_, ...)
    dd(...)
  end
else
  vim.print = dd
end

local g = require('globals')
require('config.lazy')
g.set_hl()

require('autocmd')
require('keybindings')
require('config.snippets')

vim.lsp.enable({"nushell", "ltex_plus"})


