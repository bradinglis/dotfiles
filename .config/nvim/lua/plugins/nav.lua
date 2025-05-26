return {
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
  {
    'nvim-telescope/telescope.nvim',
    opts = {
      defaults = {
        layout_config = {
          width = 0.9,
          horizontal = {
            preview_width = 0.5,
          }
        },
      },
      pickers = {
        buffers = {
          mappings = {
            n = {
              ["<C-d>"] = "delete_buffer"
            }
          },
        },
        spell_suggest = {
          theme = "cursor",
        },
        diagnostics = {
          theme = "dropdown",
          layout_config = { width = 0.9 },
        }
      },
    },
    config = function(_, opts)
      opts.extensions = {}
      opts.extensions["ui-select"] = require("telescope.themes").get_cursor {}
      require("telescope").setup(opts)
      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("git_worktree")
      require("telescope").load_extension("fzf")
    end,
    dependencies = { 'nvim-telescope/telescope-ui-select.nvim', 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-fzf-native.nvim' }
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      settings = {
        save_on_toggle = true,
      }
    },
    keys = function()
      local keys = {
        {
          "<leader>a",
          function()
            require("harpoon"):list():add()
          end,
          desc = "Harpoon File",
        },
        {
          "<C-e>",
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Harpoon Quick Menu",
        },
      }

      for i = 1, 9 do
        table.insert(keys, {
          "<A-" .. i .. ">",
          function()
            require("harpoon"):list():select(i)
          end,
          desc = "Harpoon to File " .. i,
        })
      end
      return keys
    end,
  },
  { "stevearc/oil.nvim", config = true },
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "letieu/harpoon-lualine",
    dependencies = {
      {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
      }
    },
  },
}
