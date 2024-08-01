local globs = require('globals').getglobs()
local colours = globs.colours

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
    "williamboman/mason.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    {
        'nvimdev/lspsaga.nvim',
        config = function()
            require('lspsaga').setup({})
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter', -- optional
            'nvim-tree/nvim-web-devicons',     -- optional
        }
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'nvimdev/lspsaga.nvim',
        }
    },
    {
        "neanias/everforest-nvim",
        version = false,
        lazy = false,
        priority = 1000,
    },
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-vsnip',
    'hrsh7th/vim-vsnip',
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
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
        version = '^1.0.0',
    },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
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
    {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup {
                patterns = { ".git", ".clangd" },
            }
            require('telescope').load_extension('projects')
        end
    },
    "lewis6991/gitsigns.nvim",
    "junegunn/goyo.vim",
    {
        'simrat39/symbols-outline.nvim',
        opts = {
            auto_preview = true,
        },
    },
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
            log_level = vim.log.levels.INFO,
            completion = {
                -- Set to false to disable completion.
                nvim_cmp = true, -- re-jigged manually after
                -- Trigger completion at 2 chars.
                min_chars = 0,
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
            mappings = {
                -- Smart action depending on context, either follow link or toggle checkbox.
                ["<cr>"] = {
                  action = function()
                    return require("vault_actions").enter_command()
                  end,
                  opts = { buffer = true, expr = true },
                },
                ["<leader>fb"] = {
                  action = function()
                      return "<cmd>FindBacklinks<CR>"
                      -- return require("backlinks").backlink_search()
                  end,
                  opts = { buffer = true, expr = true },
                },
                ["<leader>ft"] = {
                  action = function()
                      return "<cmd>ObsidianTags<CR>"
                  end,
                  opts = { buffer = true, expr = true },
                },
                ["<leader>fn"] = {
                  action = function()
                      return "<cmd>ObsidianQuickSwitch<CR>"
                  end,
                  opts = { buffer = true, expr = true },
                },
                ["<leader>fa"] = {
                  action = function()
                      return "<cmd>ObsidianQuickSwitch %<CR>"
                  end,
                  opts = { buffer = true, expr = true, remap = true },
                },
                ["<leader>fs"] = {
                  action = function()
                      return "<cmd>ObsidianQuickSwitch ~<CR>"
                  end,
                  opts = { buffer = true, expr = true, remap = true },
                },
                -- ["<leader>ns"] = {
                --   action = function()
                --       return "<cmd>NewSource<CR>"
                --   end,
                --   opts = { buffer = true, expr = true },
                -- },
                -- ["<leader>nn"] = {
                --   action = function()
                --       return "<cmd>NewNote<CR>"
                --   end,
                --   opts = { buffer = true, expr = true },
                -- },
                -- ["<leader>na"] = {
                --   action = function()
                --       return "<cmd>NewAuthor<CR>"
                --   end,
                --   opts = { buffer = true, expr = true },
                -- },
            },
            callbacks = {
                enter_note = function(_, note)
                    if note.has_frontmatter then
                        require("vault_actions").frontmatter_hightlighting(note)
                    end
                end,
            },
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
                    ObsidianTag = { italic = true, fg = colours.green },
                    ObsidianBlockID = { italic = true, fg = colours.orange },
                    ObsidianHighlightText = { bg = colours.bggreen },
                },
            },
        },
    }
})

require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { "gopls", "markdown_oxide", "clangd" },
}
require("everforest").load()
require("gitsigns").setup()

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = "*.md",
    callback = function()
        vim.fn["pencil#init"]()
    end
})

require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "graphql", "go" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
}

require('configs/cmp_conf')
require('configs/lsp_conf')
