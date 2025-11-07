return {
  {
    "mason-org/mason-lspconfig.nvim",
    event = "VeryLazy",
    cmd = { "MasonInstallAll" },
    opts = function(_, opts)
      local ensure_installed = {
        "clangd",
        "lua_ls",
        "bashls",
      }

      opts.ensure_installed = ensure_installed

      -- Create user command to synchronously install all Mason tools in `opts.ensure_installed`.
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        for _, tool in ipairs(opts.ensure_installed) do
          vim.cmd("MasonInstall " .. tool)
        end
      end, {})

      return opts
    end,
    dependencies = {
      { "mason-org/mason.nvim", opts = {
        -- log_level = vim.log.levels.DEBUG
      } },
      "neovim/nvim-lspconfig",
      "barreiroleo/ltex-extra.nvim",
      "Hoffs/omnisharp-extended-lsp.nvim",
      "p00f/clangd_extensions.nvim",
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
  -- { "folke/neodev.nvim", enabled = false }, -- make sure to uninstall or disable neodev.nvim
  }
}
