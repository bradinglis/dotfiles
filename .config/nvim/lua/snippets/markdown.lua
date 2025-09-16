require("luasnip.session.snippet_collection").clear_snippets "markdown"

local ls = require "luasnip"

local s = ls.snippet
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

-- local function auto_snippet(keys, format)
--     vim.keymap.set('i', keys, function ()
--         vim.snippet.expand(keys)
--         ls.expand()
--     end, {silent = true})
--     return s(keys, format)
-- end


ls.add_snippets("markdown", {
  s({ trig = ",e", wordTrig = false },    fmt("*{}*{}", { i(1), i(0) })),
  s({ trig = ",b", wordTrig = false },    fmt("**{}**{}", { i(1), i(0) })),
  s({ trig = ",ln", wordTrig = false },   fmt("----------\n{}", {i(0)})),
  s({ trig = ",h", wordTrig = false },    fmt("=={}=={}", { i(1), i(0) })),
  s({ trig = ",c", wordTrig = false },    fmt("`{}`{}", { i(1), i(0) })),
  s({ trig = ",k" },                      fmt("```{}\n{}\n```\n{}", { i(1, "language"), i(2), i(0) })),
  s({ trig = ",x", wordTrig = false },    fmt("***{}***{}", { i(1), i(0) })),
}, { type = "autosnippets" })


ls.add_snippets("markdown", {
  s({ trig = ",code" },                      fmt("```{}\n{}\n```\n{}", { i(1, "language"), i(2), i(0) })),
}, { type = "snippets" })
