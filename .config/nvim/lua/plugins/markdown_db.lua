return {
  {
    dir = "~/markdown_db",
    ft = "markdown",
    opts = {
      vaults = {
        default = "zettel",
        zettel = {
          name = "zettel",
          dir = "/home/brad/zettel"
        }
      }
    },
    keys = {
      { '<leader>ff', function() require("markdown_db-nvim").find_notes() end, mode = 'n', ft = { "markdown" }, desc = 'find notes' },
      { '<leader>ft', function() require("markdown_db-nvim").find_tags() end, mode = 'n', ft = { "markdown" }, desc = 'find tags' },
      { '<leader>fr', function() require("markdown_db-nvim").find_links() end, mode = 'n', ft = { "markdown" }, desc = 'find references' },
    },
  }
}
