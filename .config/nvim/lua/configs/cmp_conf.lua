require("configs.snippets")
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append "c"

local cmp = require'cmp'

cmp.setup({
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end,
    },
    mapping = {
        ['<C-b>'] = { i = cmp.mapping.scroll_docs(-4) },
        ['<C-f>'] = { i = cmp.mapping.scroll_docs(4) },
        ['<C-e>'] = { i = cmp.mapping.abort() },
        ["<C-j>"] = { i = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert }},
        ["<C-k>"] = { i = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert }},
        ["<C-CR>"] = { i = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true } },
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' }
    }
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})
