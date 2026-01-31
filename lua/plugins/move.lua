return {
  "matze/vim-move",
  event = { "User AstroFile", "InsertEnter" },
  init = function()
    vim.g.move_map_keys = 0
  end,
  config = function()
    local opts = { silent = true }
    vim.keymap.set("n", "<C-A-S-j>", "<Plug>MoveLineDown", opts)
    vim.keymap.set("n", "<C-A-S-k>", "<Plug>MoveLineUp", opts)
    vim.keymap.set("n", "<C-A-S-h>", "<Plug>MoveCharLeft", opts)
    vim.keymap.set("n", "<C-A-S-l>", "<Plug>MoveCharRight", opts)

    vim.keymap.set("v", "<C-A-S-j>", "<Plug>MoveBlockDown", opts)
    vim.keymap.set("v", "<C-A-S-k>", "<Plug>MoveBlockUp", opts)
    vim.keymap.set("v", "<C-A-S-h>", "<Plug>MoveBlockLeft", opts)
    vim.keymap.set("v", "<C-A-S-l>", "<Plug>MoveBlockRight", opts)
  end,
}