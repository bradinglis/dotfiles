local cmp = require"cmp"

-- cmp.unregister_source("obsidian_new", require("alts.my_cmp_obsidian_new").new())
cmp.register_source("my_obsidian_new", require("alts.my_cmp_obsidian_new").new())
cmp.register_source("my_authors", require("alts.my_cmp_authors").new())
cmp.register_source("my_sources", require("alts.my_cmp_sources").new())

local log = require "obsidian.log"

local obsidian = require "obsidian"

local group = vim.api.nvim_create_augroup("obsidian_setup", { clear = false })

local client = assert(obsidian.get_client())
local opts = client.opts

-- This does autocmd BufEnter overwrite? Idk

vim.api.nvim_clear_autocmds({ event = "BufEnter", group = group })

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = group,
    pattern = "*.md",
    callback = function(ev)
      -- Set the current directory of the buffer.
      local buf_dir = vim.fs.dirname(ev.match)
      if buf_dir then
        client.buf_dir = obsidian.Path.new(buf_dir)
      end

      -- Check if we're in *any* workspace.
      local workspace = obsidian.Workspace.get_workspace_for_dir(buf_dir, client.opts.workspaces)
      if not workspace then
        return
      end

      -- Switch to the workspace and complete the workspace setup.
      if not client.current_workspace.locked and workspace ~= client.current_workspace then
        log.debug("Switching to workspace '%s' @ '%s'", workspace.name, workspace.path)
        client:set_workspace(workspace)
        client:update_ui(ev.buf)
      end

      -- Register mappings.
      for mapping_keys, mapping_config in pairs(opts.mappings) do
        vim.keymap.set("n", mapping_keys, mapping_config.action, mapping_config.opts)
      end

      -- Inject Obsidian as a cmp source.
      if opts.completion.nvim_cmp then
        local sources = {
          { name = "obsidian" },
          { name = "my_obsidian_new" },
          { name = "my_authors" },
          { name = "my_sources" },
          { name = "obsidian_tags" },
        }
        for _, source in pairs(cmp.get_config().sources) do
          if source.name ~= "obsidian"
              and source.name ~= "my_obsidian_new"
              and source.name ~= "my_authors"
              and source.name ~= "my_sources"
              and source.name ~= "obsidian_tags" then
            table.insert(sources, source)
          end
        end
        ---@diagnostic disable-next-line: missing-fields
        cmp.setup.buffer { sources = sources }
      end

      -- Run enter-note callback.
      client.callback_manager:enter_note(function()
        return obsidian.Note.from_buffer(ev.bufnr)
      end)
    end,
  })
