local client = require("obsidian").get_client()

local notes = nil

local get_notes = function ()
  if notes == nil then
    notes = client:find_notes("")
    return notes
  else
    return notes
  end
end

local refresh_notes = function ()
  client:find_notes_async("", function (x)
    notes = x
  end)
end

return {
  get_notes = get_notes,
  refresh_notes = refresh_notes
}

