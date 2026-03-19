return {
  {
    dir = "~/markdown_db",
    lazy = false,
    opts = {
      vaults = {
        default = "work",
        work = {
          name = "work",
          dir = "/home/inglisb/zettel"
        },
        zettel = {
          name = "zettel",
          dir = "/home/inglisb/testing/zettel"
        }
      }
    },
    keys = {
      { '<leader>ff', function() require("markdown_db-nvim").find_notes() end, mode = 'n', desc = 'find notes' },
    },
  }
}
