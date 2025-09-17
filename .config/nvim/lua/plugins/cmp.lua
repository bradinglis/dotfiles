return {
  {
    'saghen/blink.cmp',
    dependencies = { 'L3MON4D3/LuaSnip', version = 'v2.*' },
    event = "VeryLazy",
    version = '1.*',
    opts = {
      cmdline = {
        keymap = {
          preset = 'inherit',
          ['<C-n>'] = { 'show', 'accept' },
        },
      },
      keymap = {
        preset = 'none',
        ['<C-k>'] = { 'select_prev', 'fallback' },
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-n>'] = { 'select_and_accept', 'show' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        ['<C-l>'] = { 'snippet_forward', 'fallback' },
        ['<C-h>'] = { 'snippet_backward', 'fallback' },

      },

      appearance = {
        nerd_font_variant = 'mono'
      },

      completion = {
        keyword = { range = "prefix" },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
        documentation = { auto_show = true },
        accept = { auto_brackets = { enabled = true } },
      },

      snippets = {
        preset = 'luasnip',
      },

      sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'notes', 'tags', 'refs' },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          snippets = {
            opts = {
              show_autosnippets = false,
            }
          },
          notes = {
            name = "Notes",
            module = "complete.link_source",
            opts = {},
          },
          tags = {
            name = "Tags",
            module = "complete.tag_source",
            opts = {},
          },
          refs = {
            name = "References",
            module = "complete.ref_source",
            opts = {},
          },
          lsp = {
            should_show_items = function(ctx, items)
              return items[1].client_name ~= "ltex_plus" or ctx.trigger.initial_kind == 'manual'
            end
          }
        }
      },

      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
  },
  {
    'windwp/nvim-autopairs',
    event = "BufReadPre",
    opts = {
      map_cr = true,
    },
  },
  {
    "windwp/nvim-ts-autotag",
    event = "BufReadPre",
    opts = {},
  },
}
