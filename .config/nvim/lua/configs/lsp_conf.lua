local telescope = require('telescope.builtin')

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

capabilities.workspace = {
    didChangeWatchedFiles = {
        dynamicRegistration = true,
    },
}

local on_attach_code = function(_, bufnr)
    vim.opt.signcolumn = "yes"
    require('keybindings').lsp()
end

local lspconfig = require("lspconfig")

lspconfig.elixirls.setup({
    capabilities = capabilities,
    on_attach = on_attach_code
})

lspconfig.gopls.setup({
    capabilities = capabilities, -- again, ensure that capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
    on_attach = on_attach_code   -- configure your on attach config
})

lspconfig.lua_ls.setup {
    capabilities = capabilities,
    on_attach = on_attach_code,
    on_init = function(client)
        local path = client.workspace_folders[1].name
        if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            return
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                version = 'LuaJIT'
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                }
            }
        })
    end,
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' },
            },
            format = {
                enable = true,
                defaultConfig = {
                    indent_style = "space",
                    indent_size = "4",
                }
            },
        },
    }
}

lspconfig.clangd.setup({
    single_file_support = false,
    root_dir = lspconfig.util.root_pattern('.clangd', 'compile_flags.txt'),
    capabilities = capabilities, -- again, ensure that capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
    on_attach = on_attach_code   -- configure your on attach config
})

lspconfig.csharp_ls.setup({
    root_dir = lspconfig.util.root_pattern('*.csproj'),
    capabilities = capabilities, -- again, ensure that capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
    on_attach = on_attach_code   -- configure your on attach config
})
