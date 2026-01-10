-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Setup test terminal keybindings (dynamic for Ruby/Python)
local Terminal = require("toggleterm.terminal").Terminal
local last_test_args = ""

-- Detect project type and return appropriate test command
local function get_test_command()
  local cwd = vim.fn.getcwd()
  
  -- Check for Ruby project (Gemfile)
  if vim.fn.filereadable(cwd .. "/Gemfile") == 1 then
    return "bundle exec rspec"
  end
  
  -- Check for Python project (pyproject.toml)
  if vim.fn.filereadable(cwd .. "/pyproject.toml") == 1 then
    return "poetry run pytest"
  end
  
  -- Default to pytest if no project file found
  return "pytest"
end

-- Run tests with no args
vim.keymap.set("n", "<leader>tr", function()
  local test_cmd = get_test_command()
  local test_terminal = Terminal:new({
    cmd = test_cmd,
    direction = "float",
    close_on_exit = false,
    float_opts = {
      border = "curved",
      width = math.floor(vim.o.columns * 0.9),
      height = math.floor(vim.o.lines * 0.9),
    },
  })
  test_terminal:toggle()
end, {
  noremap = true,
  silent = true,
  desc = "Run tests",
})

-- Run tests with args (remembers last args)
vim.keymap.set("n", "<leader>tR", function()
  local test_cmd = get_test_command()
  local args = vim.fn.input("Test args: ", last_test_args)
  last_test_args = args
  
  local cmd = args ~= "" and test_cmd .. " " .. args or test_cmd
  local test_terminal = Terminal:new({
    cmd = cmd,
    direction = "float",
    close_on_exit = false,
    float_opts = {
      border = "curved",
      width = math.floor(vim.o.columns * 0.9),
      height = math.floor(vim.o.lines * 0.9),
    },
  })
  test_terminal:toggle()
end, {
  noremap = true,
  silent = true,
  desc = "Run tests with args",
})

-- Register with which-key
local wk_status, wk = pcall(require, "which-key")
if wk_status then
  wk.add({
    { "<leader>tr", desc = "Run tests" },
    { "<leader>tR", desc = "Run tests with args" },
  })
end
