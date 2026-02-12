return {
  "Wansmer/treesj",
  keys = {
    { "<leader>jt", "<CMD>TSJToggle<CR>", desc = "Toggle Split/Join" },
  },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    use_default_keymaps = false, -- Recommended to use your own keymaps
  },
}
