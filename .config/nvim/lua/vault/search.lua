local client = require("obsidian").get_client()

local notes = nil

local get_notes = function ()
  if notes == nil then
    notes = client:find_notes("")
    for _, value in ipairs(notes) do
      value["relative_path"] = client:vault_relative_path(value.path.filename)
    end
    return notes
  else
    return notes
  end
end

local refresh_notes = function ()
  client:find_notes_async("", function (x)
    for _, value in ipairs(x) do
      value["relative_path"] = client:vault_relative_path(value.path.filename)
      value["links"] = {}
      for num, line in ipairs(value.contents) do
        local link = line:match("%[%[[%w-_.',]*[|%]]")
        if link ~= nil then
          table.insert(value.links, {link:sub(3,-2), num})
        end
        -- local tag = line:match("#[%w-]")
        -- if tag ~= nil then
        --   table.insert(value.body_tags, {tag:sub(2,-1), num})
        -- end
      end
    end
    notes = x
  end, { search = { sort = true, sort_by = "modified", sort_reversed = true, fixed_strings = true, }, notes = { load_contents = true } })
end

return {
  get_notes = get_notes,
  refresh_notes = refresh_notes
}

