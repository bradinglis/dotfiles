vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.md",
  callback = function()
  end
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.md",
  callback = function()
    require('vault.data').refresh_notes()
    -- require'vault.all_search'()
  end,
})

-- vim.api.nvim_create_autocmd("User", {
--   pattern = "TelescopePreviewerLoaded",
--   callback = function(args)
--     -- if args.data.filetype == "markdown" then
--     --   vim.cmd("Markview attach")
--     --   vim.cmd("Markview disableHybrid")
--     -- end
--     vim.wo.wrap = true
--     vim.wo.linebreak = true
--   end,
-- })

vim.api.nvim_create_autocmd("FileType", {
  callback = function() vim.opt_local.formatoptions:remove("o") end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "everforest",
  callback = require("globals").set_hl,
})
