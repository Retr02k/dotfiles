return {
  "nvim-tree/nvim-tree.lua",

  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    require("nvim-tree").setup({
      view = {
        width = 35,
      },

      renderer = {
        group_empty = true,
      },

      filters = {
        dotfiles = false,
      },

      update_focused_file = {
        enable = true,
      },

      git = {
        enable = true,
      },
    })
  end,
}
