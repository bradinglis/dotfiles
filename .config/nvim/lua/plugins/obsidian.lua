local globs = require('globals').getglobs()
local colours = globs.colours
local function get_icon(x, item)
  if not item or not item.levels then
    return ""
  end
  local output = "§"
  local levels = item.levels
  for l, level in ipairs(levels) do
    if level ~= 0 and l ~= 1 then
      output = output .. level .. (l ~= #levels and "." or "")
    end
  end
  return output .. " "
end

return {
  "bullets-vim/bullets.vim",
  {
    "bradinglis/obsidian.nvim",
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "bullets-vim/bullets.vim",
      'chenxin-yan/footnote.nvim',
    },

    opts = {
      legacy_commands = false,
      sort_by = "modified",
      sort_reversed = true,
      search_max_lines = 1000,
      fixed_strings = true,
      workspaces = {
        {
          name = "notes",
          path = globs.notesdir,
        },
      },
      completion = {
        nvim_cmp = false,
        blink = false,
        min_chars = 2,
        create_new = false,
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
          -- require("alts.alter")
          require('vault.data').refresh_notes()
        end,
        enter_note = function(note)
          local util = require("vault.util")
          require("globals").set_hl()
          -- vim.keymap.del("n", "<CR>", { buffer = note.bufnr })
          vim.keymap.set('n', '<CR>', function() return util.enter_command() end, { buffer = true, expr = true })
          vim.opt.conceallevel = 2
          vim.opt.concealcursor = ""
          if note.has_frontmatter then
            util.frontmatter_highlighting(note)
            util.tag_highlighting(note)
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
        enable = false,
        update_debounce = 1000,
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
      footer = {
        enabled = false,
        format = "{{words}} words  {{chars}} chars",
        hl_group = "Comment",
        separator = string.rep("-", 80),
      },
    },
  },
  {
    "bradinglis/markview.nvim",
    lazy = false,
    priority = 49,
    opts = {
      preview = {
        debounce = 1,
        max_buf_lines = 50,
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
        block_quotes = {
          wrap = false
        },
        list_items = {
          enable = false,
          wrap = true,
          indent_size = 0,
          shift_width = 4,
          marker_minus = {
            add_padding = false,
            text = "•"
          },
          marker_dot = {
            add_padding = false,
          }
        },
        -- tables = require("markview.presets").tables.single,
        horizontal_rules = {
          enable = true,

          parts = {
            {
              type = "repeating",
              repeat_amount = function()
                return vim.o.columns;
              end,

              text = "━",
              hl = "Comment"
            }
          }
        },
        headings = {
          heading_1 = {
            sign = "",
            icon = " ",
            icon_hl = "Red",
          },
          heading_2 = {
            sign = "",
            icon = get_icon,
            icon_hl = "Orange",
          },
          heading_3 = {
            sign = "",
            icon = get_icon,
            icon_hl = "Yellow",
          },
          heading_4 = {
            sign = "",
            icon = get_icon,
            icon_hl = "Green",
          },
          heading_5 = {
            sign = "",
            icon = get_icon,
            icon_hl = "Blue",
          },
          heading_6 = {
            sign = "",
            icon = get_icon,
            icon_hl = "Purple",
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
            hl = "Blue"
          }

        }
      }
    },
  },
  {
    'chenxin-yan/footnote.nvim',
    -- event = "VeryLazy",
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
