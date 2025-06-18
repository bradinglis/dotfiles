return {
  {
    "mason-org/mason-lspconfig.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
      "barreiroleo/ltex-extra.nvim",
      "Hoffs/omnisharp-extended-lsp.nvim",
      "p00f/clangd_extensions.nvim",
    },
  },
}
