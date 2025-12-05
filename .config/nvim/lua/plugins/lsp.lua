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
      { '<leader>lf', function () require("conform").format() end, mode = 'n', desc = 'format' },
    },
    opts = {
      formatters_by_ft = {
        lua = { lsp_format="prefer" },
        graphql = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
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
  }
}

