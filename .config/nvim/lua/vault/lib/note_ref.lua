local abc = require "obsidian.abc"

---@class obsidian.FullNoteRef 
---@field note obsidian.Note
---@field line_num integer

---A class that represents the tag dictionary
---
---@toc_entry obsidian.Note
---
---@class obsidian.NoteRef : obsidian.ABC
---
---@field note_id string
---@field line_num integer|?
local NoteRef = abc.new_class {
  __tostring = function(self)
    return string.format("Note('%s')", self.id)
  end,
}

--- Creates NoteRef from data
---@param note_id string
---@param line_num integer|?
NoteRef.new = function (note_id, line_num)
  local self = NoteRef.init()
  self.note_id = note_id
  self.line_num = line_num
  return self
end

--- Get note from db
---@param db table<string,obsidian.Note>
---@return obsidian.FullNoteRef
NoteRef.get_note = function (self, db)
  return { note = db[self.note_id], line_num = self.line_num or 1 }
end

return NoteRef

