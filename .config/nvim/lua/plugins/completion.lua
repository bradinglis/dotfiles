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
        ['<C-n>'] = { function(cmp)
          local i = cmp.get_selected_item()
          cmp.select_and_accept({
            callback = function()
              require("config.snippets").set_default(i and i.label)
            end
          })
        end, 'show' },

        ['<C-b>'] = { 'scroll_signature_up', 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_signature_down', 'scroll_documentation_down', 'fallback' },

        ['<C-l>'] = { 'snippet_forward', 'fallback' },
        ['<C-h>'] = { 'snippet_backward', 'fallback' },
      },

      appearance = {
        nerd_font_variant = 'mono'
      },

      signature = {
        enabled = false,
        trigger = {
          -- Show the signature help automatically
          enabled = false,
          -- Show the signature help window after typing any of alphanumerics, `-` or `_`
          show_on_keyword = false,
          blocked_trigger_characters = {},
          blocked_retrigger_characters = {},
          -- Show the signature help window after typing a trigger character
          show_on_trigger_character = true,
          -- Show the signature help window when entering insert mode
          show_on_insert = true,
          -- Show the signature help window when the cursor comes after a trigger character when entering insert mode
          show_on_insert_on_trigger_character = true,
        },
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
        trigger = {
          show_on_blocked_trigger_characters = {}
        }
      },

      snippets = {
        preset = 'luasnip',
      },

      sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'jq_keys', 'jq_values' },
        -- default = { 'lazydev', 'lsp', 'path', 'snippets', 'notes', 'tags', 'refs', 'jq_keys', 'jq_values' },
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
          -- notes = {
          --   name = "Notes",
          --   module = "complete.link_source",
          --   override = {
          --     get_trigger_characters = function(self)
          --       local trigger_characters = self:get_trigger_characters()
          --       vim.list_extend(trigger_characters, { "\n", "\t", " " })
          --       return trigger_characters
          --     end,
          --   },
          --   opts = {},
          -- },
          jq_keys = {
            name = "Jq Keys",
            module = "complete.jq_key_source",
            opts = {},
          },
          jq_values = {
            name = "Jq Values",
            module = "complete.jq_value_source",
            opts = {},
          },
          -- tags = {
          --   name = "Tags",
          --   module = "complete.tag_source",
          --   opts = {},
          -- },
          -- refs = {
          --   name = "References",
          --   module = "complete.ref_source",
          --   opts = {},
          -- },
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
    config = function(_, opts)
      local ap = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")
      local cond = require('nvim-autopairs.conds')
      ap.setup(opts)
      ap.add_rules({
        Rule("*", "*", "markdown"):with_move(cond.not_after_text("*")),
        Rule("==", "==", "markdown"):with_move(cond.not_after_text("*")),
        Rule("|", "|", "rust"),
      })
    end
  },
  {
    "windwp/nvim-ts-autotag",
    event = "BufReadPre",
    opts = {},
  },
}
