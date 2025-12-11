local source = {}

function source.new(opts)
  local self = setmetatable({}, { __index = source })
  self.opts = opts
  return self
end

function source:get_trigger_characters() return { '"' } end

function source:enabled() return vim.bo.filetype == 'jq' end

function source:get_completions(ctx, callback)
  --- @type lsp.CompletionItem[]

  local text = string.sub(ctx.line, 0, ctx.bounds.start_col - 1)

  local i, _, match = string.find(text, "|[^|]*select%(([^=]*) ==[^%)]*$")
  local items = {}
  if match ~= nil then
    text = string.sub(text, 0, i) .. " " .. match
    local cli_args = { "jq", "-r", text }
    local on_exit = function(result)
      local out = result.stdout
      local lines = vim.split(out, "\n", { plain = true })
      local new_lines = {}
      for _, value in pairs(lines) do
        if not vim.list_contains(new_lines, value) then
          table.insert(new_lines, value)
        end
      end

      items = {}
      for _, value in pairs(new_lines) do
        if value ~= "" then
          if tonumber(value) then
            value = "[" .. tonumber(value) .. "]"
          end

          table.insert(items, {
            label = value,
            filterText = value,
            kind = require('blink.cmp.types').CompletionItemKind.Value,
            textEdit = {
              newText = value,
              range = {
                start = { line = ctx.bounds.line_number - 1, character = ctx.bounds.start_col - 1 },
                ['end'] = { line = ctx.bounds.line_number - 1, character = ctx.bounds.start_col + ctx.bounds.length - 1 },
              },
            },
            insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
          })
        end
      end

      callback({
        items = items,
        is_incomplete_backward = true,
        is_incomplete_forward = true,
      })
    end

    local ok, _ = pcall(vim.system, cli_args, { stdin = vim.api.nvim_buf_get_lines(1, 0, -1, false) }, on_exit)
  else
    callback({
      items = {},
      is_incomplete_backward = true,
      is_incomplete_forward = true,
    })
  end

  return function() end
end


-- (Optional) Before accepting the item or showing documentation, blink.cmp will call this function
-- so you may avoid calculating expensive fields (i.e. documentation) for only when they're actually needed
-- Note only some fields may be resolved lazily. You may check the LSP capabilities for a complete list:
-- `textDocument.completion.completionItem.resolveSupport`
-- At the time of writing: 'documentation', 'detail', 'additionalTextEdits', 'command', 'data'
-- function source:resolve(item, callback)
--   item = vim.deepcopy(item)
--
--   -- Shown in the documentation window (<C-space> when menu open by default)
--   item.documentation = {
--     kind = 'markdown',
--     value = '# Foo\n\nBar',
--   }
--
--   -- Additional edits to make to the document, such as for auto-imports
--   item.additionalTextEdits = {
--     {
--       newText = 'foo',
--       range = {
--         start = { line = 0, character = 0 },
--         ['end'] = { line = 0, character = 0 },
--       },
--     },
--   }
--
--   callback(item)
-- end

function source:execute(ctx, item, callback, default_implementation)
  default_implementation()
  callback()
end

return source
