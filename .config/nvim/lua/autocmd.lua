vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    if (not vim.tbl_contains(BradGlobs.parsers, ev.match)) then
      return
    end
    vim.treesitter.start(ev.buf)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function() vim.opt_local.formatoptions:remove("o") end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "everforest",
  callback = BradGlobs.set_hl,
})
