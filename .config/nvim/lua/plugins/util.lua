return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      { '<leader><enter>',  function() require("snacks").picker.smart() end,              mode = 'n', desc = "smart picker" },
      { "<leader>/",        function() require("snacks").picker.grep() end,               mode = 'n', desc = "grep" },
      { '<leader>ff',       function() require("snacks").picker.files() end,              mode = 'n', desc = "files" },
      { '<leader>fg',       function() require("snacks").picker.grep() end,               mode = 'n', desc = "grep" },
      { '<leader>fb',       function() require("snacks").picker.buffers() end,            mode = 'n', desc = "buffers" },
      { '<leader>f<Enter>', function() require("snacks").explorer() end,                  mode = 'n', desc = 'explorer' },
      { 'z=',               function() require("snacks").picker.spelling() end,           mode = 'n', desc = "spelling" },
      { '<leader>gb',       function() require("snacks").picker.git_branches() end,       mode = 'n', desc = 'git branches' },
      { "<leader>gL",       function() require("snacks").picker.git_log_line() end,       mode = 'n', desc = "git log line" },
      { "<leader>gf",       function() require("snacks").picker.git_log_file() end,       mode = 'n', desc = "git log file" },

      { '<leader>gl',       function() require("snacks").picker.git_log() end,            mode = 'n', desc = 'git log' },
      { '<leader>gs',       function() require("snacks").picker.git_status() end,         mode = 'n', desc = 'git status' },
      { '<leader>gu',       function() require("snacks").lazygit() end,                   mode = 'n', desc = 'lazygit' },

      { "<leader>n",        function() require("snacks").picker.notifications() end,      mode = 'n', desc = "Notification History" },
      { '<leader>s"',       function() require("snacks").picker.registers() end,          mode = 'n', desc = "registers" },
      { '<leader>s/',       function() require("snacks").picker.search_history() end,     mode = 'n', desc = "search history" },
      { "<leader>sa",       function() require("snacks").picker.autocmds() end,           mode = 'n', desc = "autocmds" },
      { "<leader>sb",       function() require("snacks").picker.lines() end,              mode = 'n', desc = "buffer lines" },
      { "<leader>sc",       function() require("snacks").picker.command_history() end,    mode = 'n', desc = "command history" },
      { "<leader>sC",       function() require("snacks").picker.commands() end,           mode = 'n', desc = "commands" },
      { "<leader>sd",       function() require("snacks").picker.diagnostics() end,        mode = 'n', desc = "diagnostics" },
      { "<leader>sD",       function() require("snacks").picker.diagnostics_buffer() end, mode = 'n', desc = "buffer diagnostics" },
      { "<leader>sh",       function() require("snacks").picker.help() end,               mode = 'n', desc = "help pages" },
      { "<leader>sH",       function() require("snacks").picker.highlights() end,         mode = 'n', desc = "highlights" },
      { "<leader>si",       function() require("snacks").picker.icons() end,              mode = 'n', desc = "icons" },
      { "<leader>sj",       function() require("snacks").picker.jumps() end,              mode = 'n', desc = "jumps" },
      { "<leader>sk",       function() require("snacks").picker.keymaps() end,            mode = 'n', desc = "keymaps" },
      { "<leader>sl",       function() require("snacks").picker.loclist() end,            mode = 'n', desc = "location list" },
      { "<leader>sm",       function() require("snacks").picker.marks() end,              mode = 'n', desc = "marks" },
      { "<leader>sM",       function() require("snacks").picker.man() end,                mode = 'n', desc = "man pages" },
      { "<leader>sp",       function() require("snacks").picker.lazy() end,               mode = 'n', desc = "search for plugin spec" },
      { "<leader>sq",       function() require("snacks").picker.qflist() end,             mode = 'n', desc = "quickfix list" },
      { "<leader>sR",       function() require("snacks").picker.resume() end,             mode = 'n', desc = "resume" },
      { "<leader>su",       function() require("snacks").picker.undo() end,               mode = 'n', desc = "undo history" },
      { "<leader>uC",       function() require("snacks").picker.colorschemes() end,       mode = 'n', desc = "colorschemes" },
      { '<leader>z',        function() require("snacks").zen() end,                       mode = 'n', desc = 'lazygit' },
      { "<leader>t",        require("transforms").transform_buffer_file,                  mode = "n", desc = "transform file" },
      { "<leader>t",        require("transforms").transform_selection,                    mode = "x", desc = "transform selection" },

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
      {
        '<leader>p',
        function()
          require("snacks").picker.files({
            cwd = os.getenv("TRANSFORMS_REPO"),
            confirm = function(picker, item, _)
              picker:close()
              if item then
                local parts = vim.split(item.file, '/')
                opts = {}
                if parts[1] == "jq" then
                  opts.command = { "jq" }
                elseif parts[1] == "jq-r" then
                  opts.command = { "jq", "-r" }
                elseif parts[1] == "sh" then
                  opts.command = { "bash", "-c" }
                elseif parts[1] == "awk" then
                  opts.command = { "awk" }
                elseif parts[1] == "awk-csv" then
                  opts.command = { "awk", "--csv" }
                elseif parts[1] == "sed" then
                  opts.command = { "sed", "-r" }
                elseif parts[1] == "sed-z" then
                  opts.command = { "sed", "-rz" }
                end
                if parts[3] ~= nil then
                  opts.output_lang = parts[2]
                end

                require('transforms.playground').init_playground(vim.api.nvim_buf_get_name(0), item._path, opts)
              end
            end,
          })
        end,
        mode = "n",
        desc = "open transformation playground"
      },
    },
  },
  {
    "philippdrebes/jsonpath.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "<leader>js", function() require("jsonpath").show_json_path() end, mode = "n", desc = "Show JSON Path" },
      { "<leader>jy", function() require("jsonpath").yank_json_path() end, mode = "n", desc = "Yank JSON Path" },
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
  {
    "chrisgrieser/nvim-spider",
    keys = {
      { "w",  "<cmd>lua require('spider').motion('w')<CR>",  mode = { "n", "o", "x" } },
      { "e",  "<cmd>lua require('spider').motion('e')<CR>",  mode = { "n", "o", "x" } },
      { "b",  "<cmd>lua require('spider').motion('b')<CR>",  mode = { "n", "o", "x" } },
      { "cw", "c<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" } },
    },
  },
}
