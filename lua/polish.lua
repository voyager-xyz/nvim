-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Setup test keybindings
require("keymaps.test").setup()

-- Setup other keybindings
local Terminal = require("toggleterm.terminal").Terminal

-- Show file tree in floating terminal
vim.keymap.set("n", "<leader>ft", function()
  local tree_terminal = Terminal:new({
    cmd = "eza --tree --level=3 --icons --group-directories-first --color=always 2>/dev/null || tree -C -L 3 --dirsfirst -I 'node_modules|.git' 2>/dev/null || find . -maxdepth 3 -not -path '*/.*' | sort",
    direction = "float",
    close_on_exit = false,
    float_opts = {
      border = "double",
      width = math.floor(vim.o.columns * 0.85),
      height = math.floor(vim.o.lines * 0.85),
    },
  })
  tree_terminal:toggle()
end, {
  noremap = true,
  silent = true,
  desc = "Show file tree",
})

-- Register with which-key
local wk_status, wk = pcall(require, "which-key")
if wk_status then
  wk.add({
    { "<leader>ft", desc = "Show file tree" },
  })
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local argv = vim.fn.argv()
    if #argv == 0 then
      Snacks.picker.smart()
    elseif #argv == 1 and vim.fn.isdirectory(argv[1]) == 1 then
      vim.cmd("bd") -- Close the default directory listing buffer (netrw/neo-tree)
      Snacks.picker.smart()
    end
  end,
  once = true,
})
-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     local argv = vim.fn.argv()
--     if #argv == 0 then
--       require("yazi").yazi()
--     elseif #argv == 1 and vim.fn.isdirectory(argv[1]) == 1 then
--       vim.cmd("bd") -- close directory buffer
--       require("yazi").yazi(nil, argv[1])
--     end
--   end,
--   once = true,
-- })

vim.keymap.set({"n", "x", "o"}, "<c-space>", function()
  require("flash").treesitter({
    actions = {
      ["<c-space>"] = "next",
      ["<BS>"] = "prev"
    }
  })
end, { desc = "Treesitter incremental selection" })
