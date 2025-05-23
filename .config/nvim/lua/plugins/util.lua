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
      defer = function (ctx)
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
      { "^%+", "" },
      { "<[cC]md>", "" },
      { "<[cC][rR]>", "" },
      { "<[sS]ilent>", "" },
      { "^lua%s+", "" },
      { "^call%s+", "" },
      { "^:%s*", "" },
      { "[A-Z]", function(arg) return arg:lower() end },
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

  "tpope/vim-fugitive",
  "tpope/vim-repeat",
  "tpope/vim-surround",
}
