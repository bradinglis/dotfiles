local globs = require('globals').getglobs()
local colours = globs.colours
return {
  "bullets-vim/bullets.vim",
  "nvim-lua/plenary.nvim",
  {
    "preservim/vim-pencil",
    init = function()
      vim.g["pencil#cursorwrap"] = 0
      vim.g["pencil#wrapModeDefault"] = "soft"
      vim.g["pencil#conceallevel"] = 2
    end,
  },
  {
    "bradinglis/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "preservim/vim-pencil",
        init = function()
          vim.g["pencil#cursorwrap"] = 0
          vim.g["pencil#wrapModeDefault"] = "soft"
          vim.g["pencil#conceallevel"] = 2
        end,
      },
      "bullets-vim/bullets.vim",
      -- 'MeanderingProgrammer/render-markdown.nvim',

    },

    opts = {
      picker = {
        sort_by = "modified",
        sort_reversed = true,
        search_max_lines = 1000,
        fixed_strings = true,

      },
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
        post_setup = function()
          require("alts.alter")
          require('vault.data').refresh_notes()
        end,
        enter_note = function(_, note)
          require("globals").set_hl()
          vim.opt.conceallevel = 2
          vim.opt.concealcursor = ""
          if note.has_frontmatter then
            require("vault.util").frontmatter_highlighting(note)
            require("vault.util").tag_highlighting(note)
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
          ObsidianBullet = { bold = true, fg = colours.orange },
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
    "OXY2DEV/markview.nvim",
    lazy = false,
    config = {
      preview = {
        callbacks = {
          on_attach = function(_, wins)
            local attach_state = spec.get({ "preview", "enable" }, { fallback = true, ignore_enable = true });

            if attach_state == false then
              return;
            end

            for _, win in ipairs(wins) do
              vim.wo[win].conceallevel = 2;
            end
          end,

          on_detach = function(_, wins)
            for _, win in ipairs(wins) do
              vim.wo[win].conceallevel = 2;
            end
          end,

          on_enable = function(_, wins)
            local attach_state = spec.get({ "preview", "enable" }, { fallback = true, ignore_enable = true });

            if attach_state == false then
              ---@type string[]
              local preview_modes = spec.get({ "preview", "modes" }, { fallback = {}, ignore_enable = true });
              ---@type string[]
              local hybrid_modes = spec.get({ "preview", "hybrid_modes" }, { fallback = {}, ignore_enable = true });

              local concealcursor = "";

              for _, mode in ipairs(preview_modes) do
                if vim.list_contains(hybrid_modes, mode) == false and vim.list_contains({ "n", "v", "i", "c" }, mode) then
                  concealcursor = concealcursor .. mode;
                end
              end

              for _, win in ipairs(wins) do
                vim.wo[win].conceallevel = 2;
                vim.wo[win].concealcursor = concealcursor;
              end
            else
              for _, win in ipairs(wins) do
                vim.wo[win].conceallevel = 2;
              end
            end
          end,

          on_disable = function(_, wins)
            for _, win in ipairs(wins) do
              vim.wo[win].conceallevel = 2;
            end
          end,

          on_hybrid_enable = function(_, wins)
            ---@type string[]
            local preview_modes = spec.get({ "preview", "modes" }, { fallback = {}, ignore_enable = true });
            ---@type string[]
            local hybrid_modes = spec.get({ "preview", "hybrid_modes" }, { fallback = {}, ignore_enable = true });

            local concealcursor = "";

            for _, mode in ipairs(preview_modes) do
              if vim.list_contains(hybrid_modes, mode) == false and vim.list_contains({ "n", "v", "i", "c" }, mode) then
                concealcursor = concealcursor .. mode;
              end
            end

            for _, win in ipairs(wins) do
              vim.wo[win].concealcursor = concealcursor;
            end
          end,

          on_hybrid_disable = function(_, wins)
            ---@type string[]
            local preview_modes = spec.get({ "preview", "modes" }, { fallback = {}, ignore_enable = true });
            local concealcursor = "";

            for _, mode in ipairs(preview_modes) do
              if vim.list_contains({ "n", "v", "i", "c" }, mode) then
                concealcursor = concealcursor .. mode;
              end
            end

            for _, win in ipairs(wins) do
              vim.wo[win].concealcursor = concealcursor;
            end
          end,

          on_mode_change = function(_, wins, current_mode)
            ---@type string[]
            local preview_modes = spec.get({ "preview", "modes" }, { fallback = {}, ignore_enable = true });
            ---@type string[]
            local hybrid_modes = spec.get({ "preview", "hybrid_modes" }, { fallback = {}, ignore_enable = true });

            local concealcursor = "";

            for _, mode in ipairs(preview_modes) do
              if vim.list_contains(hybrid_modes, mode) == false and vim.list_contains({ "n", "v", "i", "c" }, mode) then
                concealcursor = concealcursor .. mode;
              end
            end

            for _, win in ipairs(wins) do
              if vim.list_contains(preview_modes, current_mode) then
                vim.wo[win].conceallevel = 3;
                vim.wo[win].concealcursor = concealcursor;
              else
                vim.wo[win].conceallevel = 0;
                vim.wo[win].concealcursor = "";
              end
            end
          end,

          on_splitview_open = function(_, _, win)
            vim.wo[win].conceallevel = 3;
            vim.wo[win].concealcursor = "n";
          end
        },
        debounce = 10,
        max_buf_lines = 50,
        draw_range = { vim.o.lines, vim.o.lines },
        modes = { "n", "no", "i", "v", "c" },
        hybrid_modes = { "n", "i", "v" },
        linewise_hybrid_mode = true,
      },
      yaml = {
        properties = {
          default = {
            text = "󰗊  ",
            hl = "MarkviewIcon4",
            use_types = false,

          },

          ["^id$"] = {
            match_string = "^id$",
            use_types = false,

            text = "󰌕  ",
            hl = "MarkviewIcon6"
          },
          ["^type$"] = {
            match_string = "^type$",
            use_types = false,

            text = "  ",
            hl = "MarkviewIcon1"
          },
          ["^references$"] = {
            match_string = "^references$",
            use_types = false,

            text = "  ",
            hl = "MarkviewIcon3"
          },
          ["^source.parents$"] = {
            match_string = "^source.parents$",
            use_types = false,

            text = "  ",
            hl = "MarkviewIcon4"
          },
          ["^author$"] = {
            match_string = "^author$",
            use_types = false,

            text = "  ",
            hl = "MarkviewIcon5"
          },
          ["^tags$"] = {
            match_string = "^tags$",
            use_types = false,

            text = "󰓹  ",
            hl = "MarkviewIcon0"
          },
          ["^aliases$"] = {
            match_string = "^aliases$",
            use_types = false,

            text = "󱞫  ",
            hl = "MarkviewIcon2"
          },
        }
      },
      markdown = {
        list_items = {
          enable = false,
        },
        headings = {
          heading_1 = {
            sign = "",
            icon = "§ ",
            icon_hl = "MarkviewHeading1",
          },
          heading_2 = {
            sign = "",
            icon = "§ ",
            icon_hl = "MarkviewHeading2",
          },
          heading_3 = {
            sign = "",
            icon = "§ ",
            icon_hl = "MarkviewHeading3",
          },
          heading_4 = {
            sign = "",
            icon = "§ ",
            icon_hl = "MarkviewHeading4",
          },
          heading_5 = {
            sign = "",
            icon = "§ ",
            icon_hl = "MarkviewHeading5",
          },
          heading_6 = {
            sign = "",
            icon = "§ ",
            icon_hl = "MarkviewHeading6",
          },
        }
      },

      markdown_inline = {
        hyperlinks = {
          enable = false,
        },
        internal_links = {
          enable = false,
          default = {
            icon = "",
            hl = "MarkviewHyperlink",
          }
        }
      }
    },

    -- For blink.cmp's completion
    -- source
    -- dependencies = {
    --     "saghen/blink.cmp"
    -- },
  },
  -- {
  --   'MeanderingProgrammer/render-markdown.nvim',
  --   ft = "markdown",
  --   event = "BufEnter",
  --   dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  --   log_level = 'trace',
  --   opts = {
  --     preset = 'obsidian',
  --     bullet = {
  --       icons = "•",
  --     },
  --     checkbox = {
  --       unchecked = {
  --         icon = '󰄱 ',
  --       },
  --       checked = {
  --         icon = ' ',
  --       },
  --       custom = {
  --         next = { raw = '[>]', rendered = ' ', highlight = 'ObsidianRightArrow', scope_highlight = nil },
  --         blocked = { raw = '[!]', rendered = ' ', highlight = 'ObsidianImportant', scope_highlight = nil },
  --         tilde = { raw = '[~]', rendered = '󰰱 ', highlight = 'ObsidianTilde', scope_highlight = nil },
  --       },
  --     }
  --   },
  -- },
}
