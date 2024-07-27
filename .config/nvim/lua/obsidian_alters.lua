local cmp = require"cmp"

cmp.unregister_source("obsidian_new")
cmp.register_source("obsidian_new", require("my_cmp_obsidian_new").new())
