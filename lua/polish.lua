-- Ensure nvm node is on PATH for LSP servers (e.g. yaml-language-server)
local node_bin = vim.fn.expand("~/.nvm/versions/node/v22.14.0/bin")
if not vim.env.PATH:find(node_bin, 1, true) then
  vim.env.PATH = node_bin .. ":" .. vim.env.PATH
end

-- Setup other keybindings
local Terminal = require("toggleterm.terminal").Terminal


-- Register with which-key
local wk_status, wk = pcall(require, "which-key")
if wk_status then
  wk.add({
    { "<leader>ft", desc = "Show file tree" },
  })
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


vim.keymap.set({"n", "x", "o"}, "<c-space>", function()
  require("flash").treesitter({
    actions = {
      ["<c-space>"] = "next",
      ["<BS>"] = "prev"
    }
  })
end, { desc = "Treesitter incremental selection" })
