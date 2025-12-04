return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      { '<leader>ff',       function() require("snacks").picker.smart() end,        mode = 'n', desc = "files" },
      { '<leader>fx',       function() require("snacks").picker.files() end,        mode = 'n', desc = "files" },
      { '<leader>fg',       function() require("snacks").picker.grep() end,         mode = 'n', desc = "grep" },
      { '<leader>fb',       function() require("snacks").picker.buffers() end,      mode = 'n', desc = "buffers" },
      { '<leader>f<Enter>', function() require("snacks").explorer() end,            mode = 'n', desc = 'explorer' },
      { 'z=',               function() require("snacks").picker.spelling() end,     mode = 'n', desc = "spelling" },
      { '<leader>gb',       function() require("snacks").picker.git_branches() end, mode = 'n', desc = 'git branches' },
      { '<leader>gl',       function() require("snacks").picker.git_log() end,      mode = 'n', desc = 'git log' },
      { '<leader>gs',       function() require("snacks").picker.git_status() end,   mode = 'n', desc = 'git status' },
      { '<leader>gu',       function() require("snacks").lazygit() end,             mode = 'n', desc = 'lazygit' },

      { '<leader>z',        function() require("snacks").zen() end,                 mode = 'n', desc = 'lazygit' },
    },
    opts = {
      bigfile = { enabled = false },
      dashboard = {
        enabled = true,
        preset = {
          pick = nil,
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ':GotoConf' },
            { icon = " ", key = "w", desc = "Notes", action = ':GotoNotes' },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "keys", gap = 1, padding = 1 },
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          {
            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = "startup" },
        },
      },
      explorer = { enabled = true },
      indent = { enabled = false },
      input = { enabled = true },
      picker = {
        enabled = true,
        layouts = {
          default = {
            layout = {
              box = "horizontal",
              width = 0.95,
              min_width = 120,
              height = 0.95,
              {
                box = "vertical",
                border = "rounded",
                title = "{title} {live} {flags}",
                { win = "input", height = 1,     border = "bottom" },
                { win = "list",  border = "none" },
              },
              { win = "preview", title = "{preview}", border = "rounded", width = 0.7 },
            },
          }
        },
      },
      notifier = {
        enabled = true,
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = {
        enabled = false,
        left = { "mark", "sign", "fold", "git" },
        right = {},
      },
      words = { enabled = false },
      git = { enabled = true },
      dim = { animate = { enabled = false } },
      zen = {
        enabled = true,
        win = {
          backdrop = {
            transparent = false,
            blend = 99,
          }
        }
      },
      lazygit = {
        theme = {},
        win = {
          wo = {
            winhighlight = "NormalFloat:Normal",
          }
        },
      },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 0,
      filter = function(mapping)
        return mapping.desc and mapping.desc ~= ""
      end,
      defer = function(ctx)
        return ctx.mode == "v" or ctx.mode == "V" or ctx.mode == "<C-V>"
      end,
      replace = {
        key = {
          function(key)
            return require("which-key.view").format(key)
          end,
        },
        desc = {
          { "<Plug>%(?(.*)%)?", "%1" },
          { "^%+",              "" },
          { "<[cC]md>",         "" },
          { "<[cC][rR]>",       "" },
          { "<[sS]ilent>",      "" },
          { "^lua%s+",          "" },
          { "^call%s+",         "" },
          { "^:%s*",            "" },
          { "[A-Z]",            function(arg) return arg:lower() end },
        },

      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "gsa",            -- Add surrounding in Normal and Visual modes
        delete = "gsd",         -- Delete surrounding
        find = "gsf",           -- Find surrounding (to the right)
        find_left = "gsF",      -- Find surrounding (to the left)
        highlight = "gsh",      -- Highlight surrounding
        replace = "gsr",        -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
  },
  {
    'bradinglis/transforms.nvim',
    keys = {
      { "<leader>t", require("transforms").transform_buffer_file, mode = "n", desc = "transform file" },
      { "<leader>t", require("transforms").transform_selection,   mode = "x", desc = "transform selection" },
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
}
