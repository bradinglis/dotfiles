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
    require "lsp_signature".on_attach({
        bind = true,
        handler_opts = {
            border = "none"
        }
    }, bufnr)
end

local on_attach_clangd = function(_, bufnr)
    vim.opt.signcolumn = "yes"
    require('keybindings').lsp()
    require "lsp_signature".on_attach({
        bind = true,
        handler_opts = {
            border = "none"
        }
    }, bufnr)

    require("clangd_extensions.inlay_hints").setup_autocmd()
    require("clangd_extensions.inlay_hints").set_inlay_hints()

end


local on_attach_elixir = function(_, bufnr)
    vim.opt.signcolumn = "yes"
    require('keybindings').lsp()
    require "lsp_signature".on_attach({
        bind = true,
        handler_opts = {
            border = "none"
        }
    }, bufnr)
    vim.keymap.set('n', '<leader>lp',
        function()
            local params = vim.lsp.util.make_position_params()
            vim.lsp.buf.execute_command({
              command = "manipulatePipes:serverid",
              arguments = { "toPipe", params.textDocument.uri, params.position.line, params.position.character },
            })
        end, {})
    vim.keymap.set('n', '<leader>lP',
        function()
            local params = vim.lsp.util.make_position_params()
            vim.lsp.buf.execute_command({
              command = "manipulatePipes:serverid",
              arguments = { "fromPipe", params.textDocument.uri, params.position.line, params.position.character },
            })
        end, {})
end

local lspconfig = require("lspconfig")

lspconfig.elixirls.setup({
    capabilities = capabilities,
    on_attach = on_attach_elixir
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
                    indent_size = "2",
                }
            },
        },
    }
}

lspconfig.clangd.setup({
    single_file_support = false,
    root_dir = lspconfig.util.root_pattern('.clangd', 'compile_flags.txt'),
    capabilities = capabilities, -- again, ensure that capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
    on_attach = on_attach_clangd,   -- configure your on attach config
})

lspconfig.gleam.setup{
    capabilities = capabilities,
    on_attach = on_attach_code,
}

lspconfig.omnisharp.setup({
    -- root_dir = lspconfig.util.root_pattern('*.csproj'),
    handlers = {
      ["textDocument/definition"] = require('omnisharp_extended').definition_handler,
      ["textDocument/typeDefinition"] = require('omnisharp_extended').type_definition_handler,
      ["textDocument/references"] = require('omnisharp_extended').references_handler,
      ["textDocument/implementation"] = require('omnisharp_extended').implementation_handler,
    },
    capabilities = capabilities, -- again, ensure that capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
    on_attach = on_attach_code   -- configure your on attach config
})
