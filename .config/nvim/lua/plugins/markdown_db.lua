return {
  {
    dir = "~/markdown_db",
    ft = "markdown",
    opts = {
      vaults = {
        default = "zettel_2",
        zettel = {
          name = "zettel",
          dir = "/home/brad/zettel"
        },
        zettel_2 = {
          name = "zettel_2",
          dir = "/home/inglisb/testing/zettel"
        },
        work = {
          name = "work",
          dir = "/home/inglisb/zettel"
        },
      }
    },
    keys = {
      { '<leader>ww', function() require("markdown_db-nvim").find.notes() end,     mode = 'n',        desc = 'find notes' },
      { '<leader>ff', function() require("markdown_db-nvim").find.notes() end,     mode = 'n',        ft = { "markdown" }, desc = 'find notes' },
      { '<leader>ft', function() require("markdown_db-nvim").find.tags() end,      mode = 'n',        ft = { "markdown" }, desc = 'find tags' },
      { '<leader>fr', function() require("markdown_db-nvim").find.links() end,     mode = 'n',        ft = { "markdown" }, desc = 'find references' },
      { '<leader>h',  function() require("markdown_db-nvim").buf.highlights() end, mode = 'n',        ft = { "markdown" }, desc = 'find references' },
      { '<CR>',       function() require("markdown_db-nvim").buf.get_cursor() end, mode = 'n',        ft = { "markdown" }, desc = 'cursor' },
      { '<leader>ns', function() require("markdown_db-nvim").create.source() end,  mode = { 'v', 'n' }, ft = { "markdown" }, desc = 'new source' },
      { '<leader>na', function() require("markdown_db-nvim").create.author() end,  mode = { 'v', 'n' }, ft = { "markdown" }, desc = 'new source' },
      { '<leader>nn', function() require("markdown_db-nvim").create.note() end,    mode = { 'v', 'n' }, ft = { "markdown" }, desc = 'new source' },
    },
  }
}
