return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    branch = 'main',
    lazy = false,
    build = function()
      local ensure_installed = {
        'c',
        'lua',
        'vim',
        'vimdoc',
        'query',
        'yaml',
        'jq',
        'json',
        'go',
        'bash',
        'markdown',
        'markdown_inline',
      }
      require("nvim-treesitter").install(ensure_installed):wait("300000")
    end,
    -- config = function(test, opts)
    --   vim.treesitter.language.register('c_sharp', 'csharp')
    --   require("nvim-treesitter.configs").setup(opts)
    -- end,
    dependencies = {
      -- "nvim-treesitter/nvim-treesitter-textobjects",
      'ThePrimeagen/git-worktree.nvim',
      "OXY2DEV/markview.nvim",
      }
  },
}
