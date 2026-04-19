
vim.g.polyglot_disabled = { 'graphql' }
vim.g.c_syntax_for_h = 1
vim.opt.autoread = true
vim.opt.showmode = false
vim.opt.scrolloff = 8
vim.opt_global.formatoptions:remove("o")
vim.opt.exrc = true
vim.opt.secure = true
vim.opt_global.diffopt:append("iwhiteall")
vim.opt.undodir = vim.fn.stdpath('data') .. '/undo'
vim.opt.backupdir = vim.fn.stdpath('data') .. '/backup'
vim.g.mapleader = " "
vim.g.maplocalleader = "  "
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
vim.g.mkdp_browser = 'Edge'
vim.g.mkdp_echo_preview_url = 1


local M = {}

M.parsers = {
  'c',
  'lua',
  'vim',
  'vimdoc',
  'query',
  'yaml',
  'jq',
  'json',
  'graphql',
  'awk',
  'latex',
  'comment',
  'toml',
  'go',
  'nu',
  'bash',
  'markdown',
  'markdown_inline',
}

local dark = true

if dark then
  vim.opt.background = "dark"
  M.colours = {
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
else
  vim.opt.background = "light"
  M.colours = {
    background = "#fdf6e3",
    black      = "#5c6a72",
    blue       = "#3a94c5",
    cyan       = "#35a77c",
    foreground = "#5c6a72",
    green      = "#8da101",
    purple     = "#df69ba",
    red        = "#f85552",
    yellow     = "#dfa000",
    orange     = "#f57D26",
    white      = "#e0dcc7",
    bggreen    = "#F0F1D2",
    bgyellow   = "#FAEDCD",
    aqua       = "#35A77C",
    bgall      = "#F4F0D9",
  }
end


function M.set_hl()
  vim.api.nvim_set_hl(0, "ObsidianTodo", { bold = true, fg = M.colours.yellow })
  vim.api.nvim_set_hl(0, "ObsidianDone", { bold = true, fg = M.colours.blue })
  vim.api.nvim_set_hl(0, "ObsidianRightArrow", { bold = true, fg = M.colours.orange })
  vim.api.nvim_set_hl(0, "ObsidianTilde", { bold = true, fg = M.colours.purple })
  vim.api.nvim_set_hl(0, "ObsidianImportant", { bold = true, fg = M.colours.red })
  vim.api.nvim_set_hl(0, "ObsidianBullet", { bold = true, fg = M.colours.orange })
  vim.api.nvim_set_hl(0, "ObsidianRefText", { underline = true, fg = M.colours.blue })
  vim.api.nvim_set_hl(0, "ObsidianExtLinkIcon", { fg = M.colours.blue })
  vim.api.nvim_set_hl(0, "ObsidianTag", { italic = true, fg = M.colours.aqua })
  vim.api.nvim_set_hl(0, "ObsidianBlockID", { italic = true, fg = M.colours.orange })
  vim.api.nvim_set_hl(0, "ObsidianHighlightText", { bg = M.colours.bgyellow })
  vim.api.nvim_set_hl(0, "markdownItalic", { italic = true, fg = M.colours.green })
  vim.api.nvim_set_hl(0, "TSEmphasis", { italic = true, fg = M.colours.green })
  vim.api.nvim_set_hl(0, "@markup.italic", { italic = true, fg = M.colours.green })
  vim.api.nvim_set_hl(0, "markdownBold", { bold = true, fg = M.colours.red })
  vim.api.nvim_set_hl(0, "TSStrong", { bold = true, fg = M.colours.red })
  vim.api.nvim_set_hl(0, "markdownBoldItalic", { italic = true, bold = true, fg = M.colours.red })
  vim.api.nvim_set_hl(0, "HydraTeal", { fg = M.colours.aqua })
  vim.api.nvim_set_hl(0, "HydraBlue", { fg = M.colours.blue })
  vim.api.nvim_set_hl(0, "HydraPink", { fg = M.colours.purple })
  vim.api.nvim_set_hl(0, "HydraRed", { fg = M.colours.red })
  vim.api.nvim_set_hl(0, "HydraAmaranth", { fg = M.colours.green })
  vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { fg = M.colours.blue })
  vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { bg = M.colours.bgall })
  vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = M.colours.bgall })
  vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { bg = M.colours.bgall })
  vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { bg = M.colours.bgall })
  vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { bg = M.colours.bgall })
  vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { bg = M.colours.bgall })
  vim.api.nvim_set_hl(0, "RenderMarkdownLink", { underline = true, fg = M.colours.blue })
  vim.api.nvim_set_hl(0, "RenderMarkdownWikiLink", { underline = true, fg = M.colours.blue })
  vim.api.nvim_set_hl(0, "@markup.list.markdown", { fg = M.colours.orange, bold = true })
  vim.api.nvim_set_hl(0, "@markup.link.label", { underline = true, fg = M.colours.blue })
  vim.api.nvim_set_hl(0, "RenderMarkdownInlineHighlight", { bg = M.colours.bggreen })
  vim.api.nvim_set_hl(0, "@property.yaml", { fg = M.colours.purple })
end

return M

