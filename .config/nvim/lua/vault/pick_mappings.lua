local actions = require "telescope.actions"
local actions_state = require "telescope.actions.state"

return function(prompt_bufnr, map)
  map({ "i", "n" }, "<c-i>", function()
    actions.close(prompt_bufnr)
    local entry = actions_state.get_selected_entry()
    vim.api.nvim_put({ entry.id }, "", false, true)
  end)

  map({ "i", "n" }, "<c-l>", function()
    actions.close(prompt_bufnr)
    local entry = actions_state.get_selected_entry()
    vim.api.nvim_put({ entry.link }, "", false, true)
  end)

  return true
end
