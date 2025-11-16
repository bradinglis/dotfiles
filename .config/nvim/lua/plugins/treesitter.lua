return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    opts = {},
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
      require("nvim-treesitter").install(ensure_installed):wait(300000)
    end,
    dependencies = {
      -- "nvim-treesitter/nvim-treesitter-textobjects",
      'ThePrimeagen/git-worktree.nvim',
      "OXY2DEV/markview.nvim",
    }
  },
}
