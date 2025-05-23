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
    end
    notes = x
  end)

end

return {
  get_notes = get_notes,
  refresh_notes = refresh_notes
}

