local source = {}

local function flatten(current_node, query_node, source_text, i)
  if i > 10 then
    vim.print("looped!!")
    return "blah"
  end
  if current_node:parent() == nil or current_node:type() == "programbody" or current_node:type() == "program" then
    return source_text
  end

  local current_parent = current_node:parent()
  if current_parent:type() == "ERROR" then
    current_parent = current_parent:parent()
  end

  local query_parent = query_node:parent()
  if query_parent:type() == "ERROR" then
    query_parent = query_parent:parent()
  end

  if current_node:type() == "query" then
    if not query_node:parent():equal(current_node) and not query_node:equal(current_node) then
      local current_start_row, current_start_col, current_start, _, _, current_end = current_node:range(true)
      local query_start_row, query_start_col, query_start, _, _, query_end = query_node:range(true)
      source_text = string.sub(source_text, 0, current_start) ..
          string.sub(source_text, query_start + 1, query_end) .. string.sub(source_text, current_end + 1)
      local tree = vim.treesitter.get_string_parser(source_text, "jq"):parse(true)[1]
      local new_node = tree:root():named_descendant_for_range(current_start_row, current_start_col, current_start_row,
        current_start_col)
      return flatten(new_node, new_node, source_text, i + 1)
    else
      query_node = current_node
    end
  elseif current_node:type() == "objectval" and query_node:equal(current_node) then
    query_node = current_node
  end

  if current_parent ~= nil and current_node:type() ~= "programbody" and current_node:type() ~= "program" then
    return flatten(current_parent, query_node, source_text, i + 1)
  end

  return source_text
end

local function clean_tree(current_node, source_text, i)
  if i > 10 then
    vim.print("looped!!")
    return false, nil
  end
  dd(current_node:type())
  dd(current_node:range())

  if current_node:type() == "query" or current_node:type() == "objectval" then
    return true, flatten(current_node, current_node, source_text, 0)
  end

  local start_row, start_col, start, end_row, end_col, _end = current_node:range(true)

  if current_node:type() == "identifier" then
    if i < 1 then
      if not vim.tbl_isempty(current_node:parent():parent():field("term_with_object_access")) then
        current_node = current_node:parent()
      end
      start_row, start_col, start, end_row, end_col, _end = current_node:range(true)
      source_text = string.sub(source_text, 0, start) .. string.sub(source_text, _end + 1)
      local tree = vim.treesitter.get_string_parser(source_text, "jq"):parse(true)[1]
      current_node = tree:root():descendant_for_range(start_row, start_col-1, start_row, start_col-1)
      dd(source_text)
      return clean_tree(current_node, source_text, i+1)
    else
      return clean_tree(current_node:parent():parent(), source_text, i+1)
    end
  end

  if current_node:type() == "." then
    if current_node:parent():type() == "ERROR" then
      source_text = string.sub(source_text, 0, start) .. string.sub(source_text, _end + 1)
    elseif current_node:parent():type() ~= "query" and current_node:parent():type() ~= "objectval" then
      source_text = string.sub(source_text, 0, start) .. string.sub(source_text, _end + 1)
    else
      return clean_tree(current_node:parent(), source_text, i+1)
    end
    local tree = vim.treesitter.get_string_parser(source_text, "jq"):parse(true)[1]
    current_node = tree:root():named_descendant_for_range(start_row, start_col-1, start_row, start_col-1)
    return clean_tree(current_node:parent():parent(), source_text, i+1)
  end

  return clean_tree(current_node:parent(), source_text, i+1)
end

function source.new(opts)
  local self = setmetatable({}, { __index = source })
  self.opts = opts
  return self
end

function source:get_trigger_characters() return { '.', ' ' } end

function source:enabled() return vim.bo.filetype == 'jq' end

function source:get_completions(ctx, callback)
  --- @type lsp.CompletionItem[]

  local cur = vim.api.nvim_win_get_cursor(0)
  vim.treesitter.get_parser():parse()

  local child_node = vim.treesitter.get_node():descendant_for_range(cur[1] - 1, cur[2] - 1, cur[1] - 1, cur[2] - 1)

  local keys, text = clean_tree(child_node, table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n"), 0)

  local items = {}
  local on_exit = function(result)
    local out = result.stdout
    local lines = vim.split(out, "\n", { plain = true })
    local new_lines = {}
    for _, value in pairs(lines) do
      if value ~= "" and not vim.list_contains(new_lines, value) then
        table.insert(new_lines, value)
      end
    end

    items = {}
    if not vim.tbl_isempty(new_lines) then
      table.insert(new_lines, "[]")
      for _, value in pairs(new_lines) do
        if tonumber(value) then
          value = "[" .. tonumber(value) .. "]"
        end
        table.insert(items, {
          label = value,
          filterText = value,
          kind = require('blink.cmp.types').CompletionItemKind.Keyword,
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

  if keys then
    local cli_args = { "jq", "-r", text .. " | keys.[]" }
    local ok, _ = pcall(vim.system, cli_args, { stdin = vim.api.nvim_buf_get_lines(1, 0, -1, false) }, on_exit)
  else
    callback({
      items = items,
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
