local globs = require('globals').getglobs() local colours = globs.colours

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({ "git",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)


require('lazy').setup({
    "tpope/vim-surround",
    "tpope/vim-fugitive",
    "stevearc/oil.nvim",
    "nvimtools/hydra.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    'nvim-treesitter/nvim-treesitter',
    'nvim-treesitter/nvim-treesitter-context',
    "nvim-treesitter/nvim-treesitter-textobjects",
    'neovim/nvim-lspconfig',
    {
        "neanias/everforest-nvim",
        version = false,
        lazy = false,
        priority = 1000,
        config = function ()
            require("everforest").load()
        end
    },
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    'L3MON4D3/LuaSnip',
    'nvim-telescope/telescope.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    'saadparwaiz1/cmp_luasnip',
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        "preservim/vim-pencil",
        init = function()
            vim.g["pencil#cursorwrap"] = 0
            vim.g["pencil#wrapModeDefault"] = "soft"
            vim.g["pencil#conceallevel"] = 2
        end,
    },
    {
        'romgrk/barbar.nvim',
        dependencies = {
            'lewis6991/gitsigns.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        init = function() vim.g.barbar_auto_setup = false end,
        opts = {
            sidebar_filetypes = {
                NvimTree = true,
            }
        },
        -- version = '^1.0.0',
    },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        priority = 1001,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup({
                sync_root_with_cwd = true,
                respect_buf_cwd = true,
                update_focused_file = {
                    enable = true,
                },
            })
            require("nvim-tree.view").View.winopts.signcolumn = 'no'
        end,
    },
    "lewis6991/gitsigns.nvim",
    {
        "bradinglis/obsidian.nvim",
        version = "*",
        lazy = true,
        ft = "markdown",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            workspaces = {
                {
                    name = "notes",
                    path = globs.notesdir,
                },
            },
            completion = {
                nvim_cmp = true,
                min_chars = 1,
            },
            templates = {
                folder = "templates",
            },
            types = {
                note = {
                    template = "note.md"
                },
                source = {
                    template = "source.md"
                }
            },

            note_id_func = function(title)
                local id = title:gsub(" ", "-"):gsub("[^A-Za-z0-9@!~_-]", ""):lower()
                return id
            end,

            wiki_link_func = function(opts)
              local anchor = ""
              local header = ""
              if opts.anchor then
                anchor = opts.anchor.anchor
                header = string.format(" ❯ %s", opts.anchor.header)
              elseif opts.block then
                anchor = "#" .. opts.block.id
              end

              if opts.id == nil then
                return string.format("[[%s%s]]", opts.label, anchor)
              elseif opts.label ~= opts.id then
                return string.format("[[%s%s|%s%s]]", opts.id, anchor, opts.label, header)
              else
                return string.format("[[%s%s]]", opts.id, anchor)
              end
            end,
            callbacks = {
                post_setup = function () require("alts.alter") end,
                enter_note = function(_, note)
                    require("globals").set_hl()
                    if note.has_frontmatter then
                        require("vault_actions").frontmatter_hightlighting(note)
                    end
                end,
            },
            mappings = {},
            note_frontmatter_func = function(note)
                local out = { id = note.id }
                if not vim.tbl_isempty(note.aliases) then
                    out.aliases = note.aliases
                end

                if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
                  if note.metadata.type ~= nil then
                      out.type = note.metadata.type
                  end

                  if note.metadata.type == "source" then
                      if note.metadata.author == nil then
                          note.metadata.author = {}
                      end
                      out.author = note.metadata.author

                      if note.metadata.book ~= nil then
                          out.book = note.metadata.book
                      end

                      if note.metadata.parent ~= nil then
                          out.parent = note.metadata.parent
                      end

                      if note.metadata.references == nil then
                          note.metadata.references = {}
                      end
                      out.references = note.metadata.references
                  end

                  for k, v in pairs(note.metadata) do
                    if out[k] == nil then
                        out[k] = v
                    end
                  end
                end

                out.tags = note.tags

                return out
              end,
            ui = {
                hl_groups = {
                    ObsidianTodo = { bold = true, fg = colours.yellow },
                    ObsidianDone = { bold = true, fg = colours.blue },
                    ObsidianRightArrow = { bold = true, fg = colours.orange },
                    ObsidianTilde = { bold = true, fg = colours.purple },
                    ObsidianImportant = { bold = true, fg = colours.red },
                    ObsidianBullet = { bold = true, fg = colours.blue },
                    ObsidianRefText = { underline = true, fg = colours.blue },
                    ObsidianExtLinkIcon = { fg = colours.blue },
                    ObsidianTag = { italic = true, fg = colours.aqua },
                    ObsidianBlockID = { italic = true, fg = colours.orange },
                    ObsidianHighlightText = { bg = colours.bggreen },
                },
            },
        },
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    {
        "folke/zen-mode.nvim",
        opts = {
            window = {
                backdrop = 0.95,
                width = 0.90,
                height = 1,
                options = {
                  signcolumn = "no", -- disable signcolumn
                  number = false, -- disable number column
                  relativenumber = false, -- disable relative numbers
                  cursorline = false, -- disable cursorline
                  cursorcolumn = false, -- disable cursor column
                  foldcolumn = "0", -- disable fold column
                },
            }
        }
    },

    {
      "ray-x/lsp_signature.nvim",
      event = "VeryLazy",
      opts = {},
      config = function(_, opts) require'lsp_signature'.setup(opts) end
    }
    -- {
    --   "michaelb/sniprun",
    --   branch = "master",
    --
    --   build = "sh install.sh",
    --   -- do 'sh install.sh 1' if you want to force compile locally
    --   -- (instead of fetching a binary from the github release). Requires Rust >= 1.65
    --
    --   config = function()
    --     require("sniprun").setup({
    --         display = {
    --             "VirtualTextOk",
    --             "VirtualTextErr",
    --         },
    --     })
    --   end,
    -- },

})

vim.cmd.colorscheme("everforest")
require("oil").setup({
    default_file_explorer = false,
})

require("telescope").setup({
    defaults = {
        layout_config = { width = 0.9 },
    },
    pickers = {
        diagnostics = {
            theme = "dropdown",
            layout_config = { width = 0.9 },
        }
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_cursor { }
        }
    },
})
require("telescope").load_extension("ui-select")

require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { "gopls", "markdown_oxide", "clangd" },
}
require("gitsigns").setup()
require("lualine").setup({
    extensions = {'quickfix', 'fugitive', 'nvim-tree'}
})
-- require("sniprun").setup({
--     display = {
--         "VirtualTextOk",
--         "VirtualTextErr",
--     },
-- })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = "*.md",
    callback = function()
        vim.fn["pencil#init"]()
    end
})

require'treesitter-context'.setup{
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 10, -- Maximum number of lines to show for a single context
  trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
  zindex = 20, -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}

require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "graphql", "go" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn", -- set to `false` to disable one of the mappings
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
    indent = {
        enable = true,
    },
    textobjects = {
      select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
          },
          -- You can choose the select mode (default is charwise 'v')
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * method: eg 'v' or 'o'
          -- and should return the mode ('v', 'V', or '<c-v>') or a table
          -- mapping query_strings to modes.
          selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@function.outer'] = 'V', -- linewise
              ['@class.outer'] = '<c-v>', -- blockwise
          },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]]"] = "@function.outer",
          ["]m"] = { query = "@class.outer", desc = "Next class start" },
        },
        goto_next_end = {
          ["]["] = "@function.outer",
          ["]M"] = "@class.outer",
        },
        goto_previous_start = {
          ["[["] = "@function.outer",
          ["[m"] = "@class.outer",
        },
        goto_previous_end = {
          ["[]"] = "@function.outer",
          ["[M"] = "@class.outer",
        },
      },
  }
}

require 'nvim-treesitter.install'.prefer_git = true
require("globals").set_hl()

require('configs/cmp_conf')
require('configs/lsp_conf')
