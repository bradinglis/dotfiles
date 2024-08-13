vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.md",
    callback = function()
    end
})

vim.api.nvim_create_autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  callback = function(args)
      vim.wo.wrap = true
      vim.wo.linebreak = true
  end,
})


vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "everforest",
  callback = require("globals").set_hl,
})
