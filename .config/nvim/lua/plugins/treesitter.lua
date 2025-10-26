return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ":TSUpdate",
    branch = 'master',
    event = { "BufReadPre", "VeryLazy" },
    lazy = false,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },

    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn", -- set to `false` to disable one of the mappings
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
      indent = {
        enable = true,
      },
      textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
          },
          -- You can choose the select mode (default is charwise 'v')
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * method: eg 'v' or 'o'
          -- and should return the mode ('v', 'V', or '<c-v>') or a table
          -- mapping query_strings to modes.
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V',  -- linewise
            ['@class.outer'] = '<c-v>', -- blockwise
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]]"] = "@function.outer",
            ["]m"] = { query = "@class.outer", desc = "Next class start" },
          },
          goto_next_end = {
            ["]["] = "@function.outer",
            ["]M"] = "@class.outer",
          },
          goto_previous_start = {
            ["[["] = "@function.outer",
            ["[m"] = "@class.outer",
          },
          goto_previous_end = {
            ["[]"] = "@function.outer",
            ["[M"] = "@class.outer",
          },
        },
      }
    },
    config = function(test, opts)
      vim.treesitter.language.register('c_sharp', 'csharp')
      -- vim.treesitter.language.register('markdown', 'preview-markdown')
      require("nvim-treesitter.configs").setup(opts)
      require 'nvim-treesitter.install'.prefer_git = true
    end,
    dependencies = { 
      "nvim-treesitter/nvim-treesitter-textobjects", 
      'ThePrimeagen/git-worktree.nvim', 
      -- "bradinglis/markview.nvim" 
      }
  },
  -- {
  --   "nvim-treesitter/nvim-treesitter-textobjects",
  --   event = "VeryLazy",
  --   enabled = true,
  --   config = function()
  --     -- When in diff mode, we want to use the default
  --     -- vim text objects c & C instead of the treesitter ones.
  --     local move = require("nvim-treesitter.textobjects.move")
  --     local configs = require("nvim-treesitter.configs")
  --     for name, fn in pairs(move) do
  --       if name:find("goto") == 1 then
  --         move[name] = function(q, ...)
  --           if vim.wo.diff then
  --             local config = configs.get_module("textobjects.move")[name]
  --             for key, query in pairs(config or {}) do
  --               if q == query and key:find("[%]%[][cC]") then
  --                 vim.cmd("normal! " .. key)
  --                 return
  --               end
  --             end
  --           end
  --           return fn(q, ...)
  --         end
  --       end
  --     end
  --   end,
  -- },
}
