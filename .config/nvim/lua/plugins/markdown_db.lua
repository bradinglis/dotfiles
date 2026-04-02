return {
  {
    dir = "~/markdown_db",
    ft = "markdown",
    opts = {
      vaults = {
        default = "work",
        zettel = {
          name = "zettel",
          dir = "~/testing/zettel"
        },
        work = {
          name = "work",
          dir = "~/work"
        },
      }
    },
    keys = {
      { '<leader>ww', function() require("markdown_db-nvim").find.all() end,     mode = 'n',        desc = 'find notes' },
      { '<leader>ff', function() require("markdown_db-nvim").find.all() end,     mode = 'n',        ft = { "markdown" }, desc = 'find notes' },
      { '<leader>fa', function() require("markdown_db-nvim").find.authors() end,     mode = 'n',        ft = { "markdown" }, desc = 'find notes' },
      { '<leader>fn', function() require("markdown_db-nvim").find.notes() end,     mode = 'n',        ft = { "markdown" }, desc = 'find notes' },
      { '<leader>fs', function() require("markdown_db-nvim").find.sources() end,     mode = 'n',        ft = { "markdown" }, desc = 'find notes' },
      { '<leader>ft', function() require("markdown_db-nvim").find.tags() end,      mode = 'n',        ft = { "markdown" }, desc = 'find tags' },
      { '<leader>fr', function() require("markdown_db-nvim").find.links() end,     mode = 'n',        ft = { "markdown" }, desc = 'find references' },
      { '<leader>oa', function() require("markdown_db-nvim").open_asset() end,     mode = 'n',        ft = { "markdown" }, desc = 'find references' },
      { '<leader>h',  function() require("markdown_db-nvim").buf.highlights() end, mode = 'n',        ft = { "markdown" }, desc = 'find references' },
      { '<CR>',       function() require("markdown_db-nvim").buf.get_cursor() end, mode = 'n',        ft = { "markdown" }, desc = 'cursor' },
      { '<leader>ns', function() require("markdown_db-nvim").create.source() end,  mode = { 'v', 'n' }, ft = { "markdown" }, desc = 'new source' },
      { '<leader>nj', function() require("markdown_db-nvim").create.journal() end,  mode = { 'v', 'n' }, ft = { "markdown" }, desc = 'new source' },
      { '<leader>na', function() require("markdown_db-nvim").create.author() end,  mode = { 'v', 'n' }, ft = { "markdown" }, desc = 'new author' },
      { '<leader>nn', function() require("markdown_db-nvim").create.note() end,    mode = { 'v', 'n' }, ft = { "markdown" }, desc = 'new note' },
      { '<leader>nb', function() require("markdown_db-nvim").fill_from_boox() end,    mode = { 'v', 'n' }, ft = { "markdown" }, desc = 'boox' },
      { '<leader>fv', function() require("markdown_db-nvim").pick.vault() end,    mode = { 'v', 'n' }, ft = { "markdown" }, desc = 'boox' },
    },
  }
}
