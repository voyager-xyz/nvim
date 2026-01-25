return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      -- This prevents Neo-tree from opening when you open a directory
      hijack_netrw_behavior = "disabled", 
    },
    -- Ensures the window doesn't open on its own during setup
    open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "outline", "edgy" },
  },
}