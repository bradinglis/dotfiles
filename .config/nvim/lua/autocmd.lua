vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.md",
  callback = function()
    -- dd(require("obsidian.api").current_note())
  end
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.md",
  callback = function()
    require('vault.data').refresh_notes()
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    if (not vim.tbl_contains(require("globals").parsers, ev.match)) then
      return
    end
    vim.treesitter.start(ev.buf)
  end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "TSUpdate",
    callback = function()
      dd("huh")
        require("nvim-treesitter.parsers").comment = {
            install_info = {
                url = "https://github.com/OXY2DEV/tree-sitter-comment",
                queries = "queries/",
            },
        }
    end
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function() vim.opt_local.formatoptions:remove("o") end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "everforest",
  callback = require("globals").set_hl,
})
