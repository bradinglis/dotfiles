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
      "preservim/vim-pencil",
      "bullets-vim/bullets.vim",

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
          path = "~/test/zettel/",
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
        enable = false,
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
    "bradinglis/markview.nvim",
    lazy = false,
    priority = 49,
    config = {
      preview = {
        debounce = 1,
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
          setext_1 = {
            border = "",
            border_hl = "",
            hl = "",
            icon = "",
            icon_hl = "",
            sign = "",
            sign_hl = "",
            style = "",
          },
          setext_2 = {
            border = "",
            border_hl = "",
            hl = "",
            icon = "",
            icon_hl = "",
            sign = "",
            sign_hl = "",
            style = "",
          },
        }
      },

      markdown_inline = {
        hyperlinks = {
          enable = true,
          default = {
            icon = "",
            hl = "MarkviewHyperlink",
          }
        },
        internal_links = {
          enable = true,
          default = {
            icon = "",
            hl = "MarkviewHyperlink",
          }
        },
        footnotes = {
          enable = true,
          default = {
            icon = "",
          },
          ["^%d+$"] = {

            icon = "",
            hl = "MarkviewPalette4Fg"
          }

        }
      }
    },
  },
  {
    'chenxin-yan/footnote.nvim',
    event = "VeryLazy",
    opts = {
      keys = {
        new_footnote = '<C-f>',
        organize_footnotes = '<leader>of',
        next_footnote = ']f',
        prev_footnote = '[f',
      },
      organize_on_new = true,
    }
  }
}
