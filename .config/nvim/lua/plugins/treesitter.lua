return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    opts = {},
    build = function()
      require("nvim-treesitter").install(BradGlobs.parsers):wait(300000)
    end,
    dependencies = {
      'ThePrimeagen/git-worktree.nvim',
      -- "OXY2DEV/markview.nvim",
    }
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    lazy = false,
    init = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      vim.g.no_plugin_maps = true

      -- Or, disable per filetype (add as you like)
      -- vim.g.no_python_maps = true
      -- vim.g.no_ruby_maps = true
      -- vim.g.no_rust_maps = true
      -- vim.g.no_go_maps = true
    end,
    config = function()
      require("nvim-treesitter-textobjects").setup {
      select = {
        lookahead = true,
      },
    }
    end,
    -- keys = {
    --   { "a|", function() require "nvim-treesitter-textobjects.select".select_textobject("@pipe", "textobjects") end,     mode = { "x", "o" },        desc = 'find notes' },
    --   { "i|", function() require "nvim-treesitter-textobjects.select".select_textobject("@parameter.inner", "textobjects") end,     mode = { "x", "o" },        desc = 'find notes' },
    --   { "i*", function() require "nvim-treesitter-textobjects.select".select_textobject("@emphasis.inner") end,     mode = { "x", "o" },        desc = 'in emphasis' },
    --   { "a*", function() require "nvim-treesitter-textobjects.select".select_textobject("@emphasis.outer") end,     mode = { "x", "o" },        desc = 'in emphasis' },
    -- }
  }
}
