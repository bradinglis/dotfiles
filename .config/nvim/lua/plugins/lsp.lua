return {
  {
    "mason-org/mason-lspconfig.nvim",
    event = "VeryLazy",
    cmd = { "MasonInstallAll" },
    config = function(_, opts)
      require("mason").setup()
      require("mason-lspconfig").setup(opts)
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("LspInstall " .. table.concat(opts.ensure_installed, " "))
      end, {})
    end,
    opts = {
       automatic_enable = {
        exclude = {
            "ltex_plus"
        }
    },
      ensure_installed = {
        "bashls",
        "lua_ls",
        "clangd",
      }
    },
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {
          -- log_level = vim.log.levels.DEBUG
        }
      },
      "neovim/nvim-lspconfig",
      "barreiroleo/ltex-extra.nvim",
      "Hoffs/omnisharp-extended-lsp.nvim",
      "p00f/clangd_extensions.nvim",
    },
  },
  {
    'stevearc/conform.nvim',
    keys = {
      { '<leader>lf', function() require("conform").format() end, mode = 'n', desc = 'format' },
    },
    opts = {
      formatters_by_ft = {
        lua = { lsp_format = "prefer" },
        nu = { "nufmt" },
        rust = { lsp_format = "prefer" },
        graphql = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        go = { lsp_format = "prefer" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    'Julian/lean.nvim',
    event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },

    dependencies = {
      'nvim-lua/plenary.nvim',

      -- optional dependencies:

      -- a completion engine
      --    hrsh7th/nvim-cmp or Saghen/blink.cmp are popular choices

      -- 'nvim-telescope/telescope.nvim', -- for 2 Lean-specific pickers
      -- 'andymass/vim-matchup',          -- for enhanced % motion behavior
      -- 'andrewradev/switch.vim',        -- for switch support
      -- 'tomtom/tcomment_vim',           -- for commenting
    },

    opts = { -- see below for full configuration options
      mappings = true,
    }
  },
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = function()
      require("go").setup(opts)
      local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require('go.format').goimports()
        end,
        group = format_sync_grp,
      })
      return {
        -- lsp_keymaps = false,
        -- other options
      }
    end,
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^7', -- Recommended
    lazy = false,   -- This plugin is already lazy
    server = {
      on_attach = require("lsp.on_attach")()
    }
  },
  {
    'mrcjkb/haskell-tools.nvim',
    version = '^7', -- Recommended
    lazy = false,   -- This plugin is already lazy
    hls = {
      on_attach = require("lsp.on_attach")(),
      capabilities = require("lsp.capabilities")
    }
  },
}
