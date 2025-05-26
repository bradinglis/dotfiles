return {
  {
    'nvim-lualine/lualine.nvim',
    event = "VeryLazy",
    opts = {
      options = {
        theme = 'everforest',
        section_separators = { left = '', right = '' },
        component_separators = { left = '|', right = '|' }
      },
      extensions = { 'quickfix', 'nvim-tree' },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {},
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
        lualine_x = { {
          'filename',
          path = 1,
        } },
        lualine_y = { 'diagnostics', 'diff', 'branch' },
      }
    },
    dependencies = { 'nvim-tree/nvim-web-devicons', "letieu/harpoon-lualine" }
  },
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("everforest").load()
      vim.cmd.colorscheme("everforest")
    end
  },
  { "lewis6991/gitsigns.nvim", config = true },
  "sindrets/diffview.nvim",
  {
    "folke/zen-mode.nvim",
    opts = {
      plugins = {
        tmux = { enabled = true },
      },
      window = {
        backdrop = 1,
        width = 0.7,
        height = 1,
        options = {
          signcolumn = "no",      -- disable signcolumn
          number = false,         -- disable number column
          relativenumber = false, -- disable relative numbers
          cursorline = false,     -- disable cursorline
          cursorcolumn = false,   -- disable cursor column
          foldcolumn = "0",       -- disable fold column
        },
      }
    }
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      cmdline = {
        view = "cmdline"
      },
      messages = {
        -- NOTE: If you enable messages, then the cmdline is enabled automatically.
        -- This is a current Neovim limitation.
        enabled = true,          -- enables the Noice messages UI
        view = "mini",         -- default view for messages
        view_error = "mini",   -- view for errors
        view_warn = "mini",    -- view for warnings
        view_history = "messages", -- view for :messages
        view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
      },
      views = {
        mini = {
          position = {
            row = 0
          }
        }
      }
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },
}

-- require('lualine').hide({
--   place = { 'tabline', 'winbar' }, -- The segment this change applies to.
--   unhide = false,                  -- whether to re-enable lualine again/
-- })
