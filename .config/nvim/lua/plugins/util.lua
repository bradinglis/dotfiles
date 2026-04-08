return {
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
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    version = false,
    opts = {}
  },
  {
    "nvim-mini/mini.surround",
    version = false,
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
}
