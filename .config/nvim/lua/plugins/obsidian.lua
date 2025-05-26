local globs = require('globals').getglobs()
local colours = globs.colours
return {
  {
    "bradinglis/obsidian.nvim",
    version = "*",
    lazy = true,
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
      'MeanderingProgrammer/render-markdown.nvim',
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
        post_setup = function() require("alts.alter") end,
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
        enable = false,
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
    'MeanderingProgrammer/render-markdown.nvim',
    event = "VeryLazy",
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    opts = {
      preset = 'obsidian',
      bullet = {
        icons = "•",
      },
      checkbox = {
        unchecked = {
          icon = '󰄱 ',
        },
        checked = {
          icon = ' ',
        },
        custom = {
            next = { raw = '[>]', rendered = ' ', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
            blocked = { raw = '[!]', rendered = ' ', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
            tilde = { raw = '[~]', rendered = '󰰱 ', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
        },
      }
    },
  }
}
