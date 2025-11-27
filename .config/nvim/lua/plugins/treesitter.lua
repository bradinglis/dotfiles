return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    opts = {},
    build = function()
      require("nvim-treesitter").install(require("globals").parsers):wait(300000)
    end,
    dependencies = {
      -- "nvim-treesitter/nvim-treesitter-textobjects",
      'ThePrimeagen/git-worktree.nvim',
      "OXY2DEV/markview.nvim",
    }
  },
}
