return {
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
          "<leader>hba",
          function()
            require("harpoon"):list():clear()
            for _, value in ipairs(vim.api.nvim_list_bufs()) do
              local pos = {1, 0}
              if value ~= -1 then
                pos = vim.api.nvim_win_get_cursor(0)
              end
              require("harpoon"):list():add({ value = vim.api.nvim_buf_get_name(value), context = { row = pos[1], col = pos[2] } })
            end
          end,
          desc = "Harpoon Add All Buffers",
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
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    keys = {
      { '<leader>v', function() require("oil").toggle_float() end, mode = 'n', desc = 'file browser' },
    },
    config = true
  }
}
