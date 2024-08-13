vim.g.c_syntax_for_h = 1
vim.opt.signcolumn = "no"
vim.opt.autoread = true

vim.opt.exrc = true
vim.opt.secure = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.vsnip_snippet_dir = vim.fn.stdpath('config') .. "/snippets"
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.errorbells = false
vim.opt.hlsearch = false
vim.opt.hidden = true
vim.opt.tabstop = 8
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.background = "dark"
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.backup = false
vim.opt.incsearch = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.conceallevel = 2
vim.opt.inccommand = "split"

vim.g["pencil#wrapModeDefault"] = "soft"
vim.g["pencil#conceallevel"] = 2
local colours = {
    blue="#7fbbb3",
    green="#a7c080",
    bggreen="#425047",
    yellow="#dbbc7f",
    bgyellow="#4d4c43",
    red="#e67e80",
    orange="#e69875",
    purple="#d699b7",
    aqua="#83c092",
}

local function set_hl()
    vim.api.nvim_set_hl(0, "ObsidianTodo",  { bold = true, fg = colours.yellow })
    vim.api.nvim_set_hl(0, "ObsidianDone",  { bold = true, fg = colours.blue })
    vim.api.nvim_set_hl(0, "ObsidianRightArrow",  { bold = true, fg = colours.orange })
    vim.api.nvim_set_hl(0, "ObsidianTilde",  { bold = true, fg = colours.purple })
    vim.api.nvim_set_hl(0, "ObsidianImportant",  { bold = true, fg = colours.red })
    vim.api.nvim_set_hl(0, "ObsidianBullet",  { bold = true, fg = colours.blue })
    vim.api.nvim_set_hl(0, "ObsidianRefText",  { underline = true, fg = colours.blue })
    vim.api.nvim_set_hl(0, "ObsidianExtLinkIcon",  { fg = colours.blue })
    vim.api.nvim_set_hl(0, "ObsidianTag",  { italic = true, fg = colours.aqua })
    vim.api.nvim_set_hl(0, "ObsidianBlockID",  { italic = true, fg = colours.orange })
    vim.api.nvim_set_hl(0, "ObsidianHighlightText",  { bg = colours.bggreen })
    vim.api.nvim_set_hl(0, "markdownItalic",  { italic = true, fg = colours.yellow })
    vim.api.nvim_set_hl(0, "markdownBold",  { bold = true, fg = colours.green })
end

return {
    set_hl = set_hl,
    getglobs = function()
        local hostname = vim.fn.hostname()
        local notesdir = ''

        if hostname == 'AL6WZQHR3' then
            notesdir = '~/notes'
            vim.opt.shell = "powershell"
            vim.opt.shellcmdflag = "-nologo -noprofile -ExecutionPolicy RemoteSigned -command"
            vim.opt.shellxquote = ''
        elseif hostname == 'DESKTOP-6K7U30E' then
            notesdir = '~/OneDrive/Apps/remotely-save/Notes'
            vim.opt.shell = "pwsh"
            vim.opt.shellcmdflag = "-nologo -noprofile -ExecutionPolicy RemoteSigned -command"
            vim.opt.shellxquote = ''
        elseif hostname == 'DESKTOP-6K7U30E' then
        elseif hostname == 'Brads-MacBook-Pro.local' then
            notesdir = '~/OneDrive/Apps/remotely-save/Notes'
        elseif hostname == 'bradpc' then
            notesdir = '~/OneDrive/Apps/remotely-save/Notes'
        else
            notesdir = '~/notes'
        end

        return {
            notesdir = notesdir,
            colours = colours,
        }
    end
}
