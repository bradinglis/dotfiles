local function transform_buffer_file()
  local current_path = vim.api.nvim_buf_get_name(0)
  local buffer = vim.api.nvim_get_current_buf()
  local sections = vim.split(current_path, ".", { plain = true })
  local ext = sections[#sections]

  local temp_file = '/tmp/transform-nvim' .. os.time() .. '.' .. ext
  local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  vim.fn.writefile(content, temp_file)

  require("snacks").terminal("source ~/.profile; transform " .. temp_file, {
    interactive = true,
    win = {
      wo = {
        cursorline = false,
        winhighlight = "NormalFloat:Normal,FloatBorder:Grey",
      },
      border = "rounded",
      backdrop = false,
      on_close = function()
        local new_content = vim.fn.readfile(temp_file)

        local no_change = vim.deep_equal(content, new_content)
        if not no_change then
          vim.api.nvim_buf_set_lines(buffer, 0, -1, false, new_content)
        end
        vim.fn.delete(temp_file)
      end
    }
  })
end

local function transform_selection()
  local current_path = vim.api.nvim_buf_get_name(0)
  local buffer = vim.api.nvim_get_current_buf()
  local sections = vim.split(current_path, ".", { plain = true })
  local ext = sections[#sections]

  local mode = vim.api.nvim_get_mode().mode

  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getpos(".")
  local start_row = start_pos[2] - 1
  local end_row = end_pos[2] - 1
  local start_col = start_pos[3] - 1
  local end_col = end_pos[3]

  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end
  local lines = vim.api.nvim_buf_get_lines(buffer, start_row, end_row + 1, false)

  if #lines == 0 then
    return
  end

  local text = {}
  local prefix = ""
  local suffix = ""
  if mode == 'V' then
    text = lines
  else
    if #lines == 1 then
      text = { string.sub(lines[1], start_col + 1, end_col) }
      prefix = string.sub(lines[1], 0, start_col)
      suffix = string.sub(lines[1], end_col + 1)
    else
      local result = {}
      prefix = string.sub(lines[1], 0, start_col)
      table.insert(result, string.sub(lines[1], start_col + 1))
      for i = 2, #lines - 1 do
        table.insert(result, lines[i])
      end
      table.insert(result, string.sub(lines[#lines], 1, end_col))
      suffix = string.sub(lines[#lines], end_col + 1)
      text = result
    end
  end

  local temp_file = '/tmp/transform-nvim' .. os.time() .. '.' .. ext
  vim.fn.writefile(text, temp_file)

  require("snacks").terminal("source ~/.profile; transform " .. temp_file, {
    interactive = true,
    win = {
      wo = {
        cursorline = false,
        winhighlight = "NormalFloat:Normal,FloatBorder:Grey",
      },
      on_close = function()
        local new_content = vim.fn.readfile(temp_file)
        local no_change = vim.deep_equal(text, new_content)
        if not no_change then
          new_content[1] = prefix .. new_content[1]
          new_content[#new_content] = new_content[#new_content] .. suffix
          vim.api.nvim_buf_set_lines(buffer, start_row, end_row + 1, false, new_content)
        end

        vim.fn.delete(temp_file)
      end
    }
  })
end

return {
  transform_buffer_file = transform_buffer_file,
  transform_selection = transform_selection,
}
