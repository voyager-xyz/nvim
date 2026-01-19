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
