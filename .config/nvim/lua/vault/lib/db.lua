local abc = require "obsidian.abc"
local Path = require("obsidian.path")
local TagDict = require("vault.lib.tag_dict")
local NoteDict = require("vault.lib.note_dict")
local async = require("obsidian.async")


---A class that represents the tag dictionary
---
---@toc_entry obsidian.DB
---
---@class obsidian.DB : obsidian.ABC
---
---@field notes obsidian.NoteDict
---@field tags obsidian.TagDict
local Db = abc.new_class {
  __tostring = function(self)
    return ""
    -- return string.format("TagDict(%s)", vim.iter(self.data):fold("{\n", function (acc, tag, noteref)
    --   return acc .. '    "' .. tag .. '": '-- .. noteref.__tostring()
    -- end) .. "\n}")
  end,
}

--- Get new DB
---@return obsidian.DB
Db.new = function()
  local self = Db.init()
  self.notes = NoteDict.new_all()
  self.tags = TagDict.from_note_dict(self.notes.data)
  return self
end

Db.async_refresh = function(self)
  async.run(function()
    self.notes.data = NoteDict:get_new()
    self.tags = TagDict.from_note_dict(self.notes.data)
  end)
end

---comment
---@param self obsidian.DB
---@param tag string
---@return obsidian.FullNoteRef[]
Db.get_tag_notes = function(self, tag)
  return vim.tbl_map(function(v)
    return v:get_note()
  end, self.tags.data[tag])
end

---comment
---@param self obsidian.DB
---@param refs obsidian.NoteRef[]
---@return obsidian.FullNoteRef[]
Db.get_ref_notes = function(self, refs)
  return vim.tbl_map(function(v)
    return v:get_note(self.notes.data)
  end, refs)
end

---comment
---@param self obsidian.DB
---@param note obsidian.Note
---@return string
Db.get_note_author_string = function(self, note)
  if note.metadata.author then
    return table.concat(vim.iter(note.metadata.author):map(function(a_id)
      return self.notes.data[a_id].title or ""
    end):totable(), ", ")
  else
    return ""
  end
end


return Db
