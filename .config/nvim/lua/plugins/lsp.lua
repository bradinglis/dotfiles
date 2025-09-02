return {
  {
    "mason-org/mason-lspconfig.nvim",
    event = "VeryLazy",
    opts = {
      automatic_enable = {
        exclude = {
          -- "ltex_plus"
        }
      }
    },
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
}
