vim.g.c_syntax_for_h = 1
vim.opt.autoread = true
vim.opt.autoread = true

local parsers = {
  'c',
  'lua',
  'vim',
  'vimdoc',
  'query',
  'yaml',
  'jq',
  'json',
  'awk',
  'latex',
  'comment',
  'toml',
  'go',
  'bash',
  'markdown',
  'markdown_inline',
}

vim.opt.showmode = false
vim.opt.scrolloff = 8
vim.opt_global.formatoptions:remove("o")
vim.opt.exrc = true
vim.opt.secure = true

vim.opt_global.diffopt:append("iwhiteall")
vim.opt.undodir = vim.fn.stdpath('data') .. '/undo'
vim.opt.backupdir = vim.fn.stdpath('data') .. '/backup'
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.errorbells = false
vim.opt.hlsearch = false
vim.opt.hidden = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.background = "dark"
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.backup = true
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.splitbelow = true
vim.opt.splitright = true
-- vim.opt.conceallevel = 2
-- vim.opt.concealcursor = ""
vim.opt.inccommand = "split"
vim.opt.showtabline = 0
vim.o.foldlevel = 99

vim.g["pencil#cursorwrap"] = 0
vim.g["pencil#wrapModeDefault"] = "soft"
vim.g["pencil#conceallevel"] = 2
vim.g.bullets_outline_levels = { 'ROM', 'ABC', 'num', 'std-' }
vim.g.mkdp_browser = 'Chrome'
vim.g.mkdp_echo_preview_url = 1
-- vim.g.notes_refreshing = false

local colours = {
  blue = "#7fbbb3",
  green = "#a7c080",
  bggreen = "#425047",
  yellow = "#dbbc7f",
  bgyellow = "#4d4c43",
  red = "#e67e80",
  orange = "#e69875",
  purple = "#d699b7",
  aqua = "#83c092",
  bgall = "#343F44",
}

local function set_hl()
  vim.api.nvim_set_hl(0, "ObsidianTodo", { bold = true, fg = colours.yellow })
  vim.api.nvim_set_hl(0, "ObsidianDone", { bold = true, fg = colours.blue })
  vim.api.nvim_set_hl(0, "ObsidianRightArrow", { bold = true, fg = colours.orange })
  vim.api.nvim_set_hl(0, "ObsidianTilde", { bold = true, fg = colours.purple })
  vim.api.nvim_set_hl(0, "ObsidianImportant", { bold = true, fg = colours.red })
  vim.api.nvim_set_hl(0, "ObsidianBullet", { bold = true, fg = colours.orange })
  vim.api.nvim_set_hl(0, "ObsidianRefText", { underline = true, fg = colours.blue })
  vim.api.nvim_set_hl(0, "ObsidianExtLinkIcon", { fg = colours.blue })
  vim.api.nvim_set_hl(0, "ObsidianTag", { italic = true, fg = colours.aqua })
  vim.api.nvim_set_hl(0, "ObsidianBlockID", { italic = true, fg = colours.orange })
  vim.api.nvim_set_hl(0, "ObsidianHighlightText", { bg = colours.bgyellow })
  vim.api.nvim_set_hl(0, "markdownItalic", { italic = true, fg = colours.green })
  vim.api.nvim_set_hl(0, "TSEmphasis", { italic = true, fg = colours.green })
  vim.api.nvim_set_hl(0, "@markup.italic", { italic = true, fg = colours.green })
  vim.api.nvim_set_hl(0, "markdownBold", { bold = true, fg = colours.red })
  vim.api.nvim_set_hl(0, "TSStrong", { bold = true, fg = colours.red })
  vim.api.nvim_set_hl(0, "markdownBoldItalic", { italic = true, bold = true, fg = colours.red })
  vim.api.nvim_set_hl(0, "HydraTeal", { fg = colours.aqua })
  vim.api.nvim_set_hl(0, "HydraBlue", { fg = colours.blue })
  vim.api.nvim_set_hl(0, "HydraPink", { fg = colours.purple })
  vim.api.nvim_set_hl(0, "HydraRed", { fg = colours.red })
  vim.api.nvim_set_hl(0, "HydraAmaranth", { fg = colours.green })
  vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { fg = colours.blue })
  vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { bg = colours.bgall })
  vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = colours.bgall })
  vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { bg = colours.bgall })
  vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { bg = colours.bgall })
  vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { bg = colours.bgall })
  vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { bg = colours.bgall })
  vim.api.nvim_set_hl(0, "RenderMarkdownLink", { underline = true, fg = colours.blue })
  vim.api.nvim_set_hl(0, "RenderMarkdownWikiLink", { underline = true, fg = colours.blue })
  vim.api.nvim_set_hl(0, "@markup.list.markdown", { fg = colours.orange, bold = true })
  vim.api.nvim_set_hl(0, "@markup.link.label", { underline = true, fg = colours.blue })
  vim.api.nvim_set_hl(0, "RenderMarkdownInlineHighlight", { bg = colours.bggreen })
  vim.api.nvim_set_hl(0, "@property.yaml", { fg = colours.purple })
end

return {
  set_hl = set_hl,
  parsers = parsers,
  getglobs = function()
    local hostname = vim.fn.hostname()
    local notesdir = ''

    if hostname == 'AL6WZQHR3' then
      notesdir = '~/zettel'
    elseif hostname == 'DESKTOP-6K7U30E' then
      notesdir = '~/zettel'
    elseif hostname == 'Brads-MBP' then
      notesdir = '~/zettel'
    elseif hostname == 'Brads-MacBook-Pro' then
      notesdir = '~/zettel'
    elseif hostname == 'Brads-MacBook-Pro.local' then
      notesdir = '~/zettel'
    elseif hostname == 'bradpc' then
      notesdir = '~/zettel'
    else
      notesdir = '~/zettel'
      vim.g.clipboard = {
        name = 'win32yank-wsl',
        copy = {
          ["+"] = 'win32yank.exe -i --crlf',
          ["*"] = 'win32yank.exe -i --crlf',
        },
        paste = {
          ["+"] = 'win32yank.exe -o --lf',
          ["*"] = 'win32yank.exe -o --lf',
        },
        cache_enabled = true,
      }
    end

    return {
      notesdir = notesdir,
      colours = colours,
    }
  end
}
