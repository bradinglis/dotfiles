return {
  {
    'nvim-lualine/lualine.nvim',
    event = "VeryLazy",
    opts = {
      options = {
        theme = 'everforest',
        section_separators = { left = '', right = '' },
        component_separators = { left = '|', right = '|' },
        refresh = {
          statusline = 500
        }
      },
      extensions = { 'quickfix', 'nvim-tree' },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return require("noice").api.status.mode.has() end,
          },
        },
        lualine_c = {
          {
            'harpoon2',
            indicators = {
              function(harpoon_entry) return "1 " .. vim.fn.fnamemodify(harpoon_entry.value, ':t') .. " " end,
              function(harpoon_entry) return "2 " .. vim.fn.fnamemodify(harpoon_entry.value, ':t') .. " " end,
              function(harpoon_entry) return "3 " .. vim.fn.fnamemodify(harpoon_entry.value, ':t') .. " " end,
              function(harpoon_entry) return "4 " .. vim.fn.fnamemodify(harpoon_entry.value, ':t') .. " " end,
              function(harpoon_entry) return "5 " .. vim.fn.fnamemodify(harpoon_entry.value, ':t') .. " " end,
              function(harpoon_entry) return "6 " .. vim.fn.fnamemodify(harpoon_entry.value, ':t') .. " " end,
              function(harpoon_entry) return "7 " .. vim.fn.fnamemodify(harpoon_entry.value, ':t') .. " " end,
              function(harpoon_entry) return "8 " .. vim.fn.fnamemodify(harpoon_entry.value, ':t') .. " " end,
            },
            active_indicators = {
              function(harpoon_entry) return "[1] " .. vim.fn.fnamemodify(harpoon_entry.value, ':t') .. " " end,
              function(harpoon_entry) return "[2] " .. vim.fn.fnamemodify(harpoon_entry.value, ':t') .. " " end,
              function(harpoon_entry) return "[3] " .. vim.fn.fnamemodify(harpoon_entry.value, ':t') .. " " end,
              function(harpoon_entry) return "[4] " .. vim.fn.fnamemodify(harpoon_entry.value, ':t') .. " " end,
              function(harpoon_entry) return "[5] " .. vim.fn.fnamemodify(harpoon_entry.value, ':t') .. " " end,
              function(harpoon_entry) return "[6] " .. vim.fn.fnamemodify(harpoon_entry.value, ':t') .. " " end,
              function(harpoon_entry) return "[7] " .. vim.fn.fnamemodify(harpoon_entry.value, ':t') .. " " end,
              function(harpoon_entry) return "[8] " .. vim.fn.fnamemodify(harpoon_entry.value, ':t') .. " " end,
            },
            color_active = { bg = "#475258" },
          },
        },
        lualine_x = {
          {
            'filename',
            path = 1,
          },
        },
        lualine_y = { 'diagnostics', 'diff', 'branch' },
      }
    },
    dependencies = {
      "folke/noice.nvim",
      'nvim-tree/nvim-web-devicons',
      "letieu/harpoon-lualine" }
  },
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("everforest").load()
    end
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = true
  },
  {
    "sindrets/diffview.nvim",
    keys = {
      {
        '<leader>gdb',
        function()
          require("snacks").picker.git_branches({
            confirm = function(picker, item, _)
              picker:close()
              if item then
                require("diffview").open(item.branch)
              end
            end,
          })
        end,
        mode = 'n',
        desc = 'diffview open branches'
      },
      {
        '<leader>gdc',
        function()
          require("snacks").picker.git_log({
            confirm = function(picker, item, _)
              picker:close()
              if item then
                require("diffview").open(item.commit)
              end
            end,
          })
        end,
        mode = 'n',
        desc = 'diffview open commits'
      },
      { '<leader>gc', function() require("diffview").close() end, mode = 'n', desc = 'diffview close' },
    },
    dependencies = {
      "snacks.nvim",
    }
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      cmdline = {
        view = "cmdline"
      },
      notify = {
        enabled = true,
        view = "notify"
      },
      messages = {
        -- NOTE: If you enable messages, then the cmdline is enabled automatically.
        -- This is a current Neovim limitation.
        enabled = true,              -- enables the Noice messages UI
        view = "notify",     -- default view for messages
        view_error = "notify",       -- view for errors
        view_warn = "notify",        -- view for warnings
        view_history = "messages",   -- view for :messages
        view_search = "mini", -- view for search count messages. Set to `false` to disable
      },
      views = {
        messages = {
          format = "details",
          view = "split",
          enter = true,
        }
      },
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
    }
  },
  {
    "hat0uma/csvview.nvim",
    opts = {
      parser = { comments = { "#", "//" } },
      view = {
        display_mode = "border",
      },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { "<C-l>", mode = { "n", "v" } },
        jump_prev_field_end = { "<C-h>", mode = { "n", "v" } },
        jump_next_row = { "<C-j>", mode = { "n", "v" } },
        jump_prev_row = { "<C-k>", mode = { "n", "v" } },
      },
    },
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  },
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "letieu/harpoon-lualine",
    event = "VeryLazy",
    dependencies = {
      {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
      }
    },
  },
}
