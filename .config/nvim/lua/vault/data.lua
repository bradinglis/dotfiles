local Path = require("obsidian.path")
local async = require("obsidian.async")
local db = require("vault.lib.db")
local search = require("obsidian.search")

async.run(db.new, function (err, res)
  ---@type obsidian.DB
  NotesDatabase = res
end)

return NotesDatabase
