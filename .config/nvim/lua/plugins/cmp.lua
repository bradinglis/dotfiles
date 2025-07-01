
return {
  {
    'hrsh7th/nvim-cmp',
    event = "VeryLazy",
    config = function()
      require("config.snippets")
      vim.opt.completeopt = { "menu", "menuone", "noselect" }
      vim.opt.shortmess:append "c"

      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")

      cmp.setup({
        -- completion = {
        --   keyword_length = 4
        -- },
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        mapping = {
          ['<C-b>'] = { i = cmp.mapping.scroll_docs(-4) },
          ['<C-f>'] = { i = cmp.mapping.scroll_docs(4) },
          ['<C-e>'] = { i = cmp.mapping.abort() },
          ["<C-j>"] = { i = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert } },
          ["<C-k>"] = { i = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert } },
          ["<C-n>"] = { i = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true } },
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' }
        },
        experimental = { ghost_text = true },
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.recently_used,
            require("clangd_extensions.cmp_scores"),
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
      })


      cmp.setup.cmdline({ '/', '?' }, {
        mapping = {
          ['<C-b>'] = { c = cmp.mapping.scroll_docs(-4) },
          ['<C-f>'] = { c = cmp.mapping.scroll_docs(4) },
          ['<C-e>'] = { c = cmp.mapping.abort() },
          ["<C-j>"] = { c = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert } },
          ["<C-k>"] = { c = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert } },
          ["<C-n>"] = { c = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true } },
        },
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = {
          ['<C-b>'] = { c = cmp.mapping.scroll_docs(-4) },
          ['<C-f>'] = { c = cmp.mapping.scroll_docs(4) },
          ['<C-e>'] = { c = cmp.mapping.abort() },
          ["<C-j>"] = { c = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert } },
          ["<C-k>"] = { c = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert } },
          ["<C-n>"] = { c = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true } },
        },
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
      })

      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    }
  },
  {
    'windwp/nvim-autopairs',
    event = "BufReadPre",
    config = true
  },
  {
    "windwp/nvim-ts-autotag",
    event = "BufReadPre",
    opts = {},
  },
}
