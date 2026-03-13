return {
    "gbprod/cutlass.nvim",
    config = function()
      require("cutlass").setup({
        exclude = { "X" },
      })
      vim.keymap.set("n", "X", '"_X', { noremap = true, silent = true })
    end
  }