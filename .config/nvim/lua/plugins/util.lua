return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 0,
      filter = function(mapping)
        -- example to exclude mappings without a description
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
          -- { "<Space>", "SPC" },
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
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = false },
      dashboard = {
        enabled = true,
        preset = {
          -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
          ---@type fun(cmd:string, opts:table)|nil
          pick = nil,
          -- Used by the `keys` section to show keymaps.
          -- Set your custom keymaps here.

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
        }
      },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
      git = { enabled = true },
    },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    }
  },

  "tpope/vim-fugitive",
  "tpope/vim-repeat",
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "gsa",          -- Add surrounding in Normal and Visual modes
        delete = "gsd",       -- Delete surrounding
        find = "gsf",         -- Find surrounding (to the right)
        find_left = "gsF",    -- Find surrounding (to the left)
        highlight = "gsh",    -- Highlight surrounding
        replace = "gsr",      -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
  }

}
