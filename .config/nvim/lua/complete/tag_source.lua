local source = {}

function source.new(opts)
  local self = setmetatable({}, { __index = source })
  self.opts = opts
  return self
end

function source:get_trigger_characters() return { '#' } end

function source:enabled() return vim.bo.filetype == 'markdown' end

function source:get_completions(ctx, callback)
  --- @type lsp.CompletionItem[]
  local items = {}

  local text = string.sub(ctx.line, ctx.bounds.start_col-1, -1)

  if ctx.line:sub(1, 5) == "tags:" then
    local tags = require("vault.data").get_tags()
    for _, tag in ipairs(vim.tbl_keys(tags)) do
      local item = {
        label = tag,
        filterText = tag,
        kind = require('blink.cmp.types').CompletionItemKind.Field,
        textEdit = {
          newText = tag,
          range = {
            start = { line = ctx.bounds.line_number - 1, character = ctx.bounds.start_col - 1 },
            ['end'] = { line = ctx.bounds.line_number - 1, character = ctx.bounds.start_col + ctx.bounds.length + 1 },
          },
        },
        insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
      }
      table.insert(items, item)

    end
  elseif string.sub(text, 1, 1) == "#" then
    local tags = require("vault.data").get_tags()
    for _, tag in ipairs(vim.tbl_keys(tags)) do
      local item = {
        label = tag,
        filterText = "#" .. tag,
        kind = require('blink.cmp.types').CompletionItemKind.Field,
        textEdit = {
          newText = "#" .. tag,
          range = {
            start = { line = ctx.bounds.line_number - 1, character = ctx.bounds.start_col - 2 },
            ['end'] = { line = ctx.bounds.line_number - 1, character = ctx.bounds.start_col + ctx.bounds.length + 1 },
          },
        },
        insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
      }
      table.insert(items, item)
    end
  end

  callback({
    items = items,
    is_incomplete_backward = true,
    is_incomplete_forward = true,
  })

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
