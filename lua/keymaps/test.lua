local terminal = require("utils.terminal")
local test_utils = require("utils.test_command")
local command_runner = require("utils.command_runner")
local state_manager = require("utils.state")

local M = {}
local state = {}

local function run_test(args)
  local test_cmd = test_utils.get_test_command()
  local cmd = args and args ~= "" and test_cmd .. " " .. args or test_cmd
  terminal.run_command(cmd, false)
end

local function run_test_with_args()
  vim.ui.input({
    prompt = "Test args: ",
    default = state.last_test_args or "",
    completion = "shellcmd",
  }, function(args)
    if args == nil then return end
    state.last_test_args = args
    state_manager.save(state)
    run_test(args)
  end)
end

local function run_custom_command()
  command_runner.input_with_history("Run command: ", function(cmd)
    state.last_custom_command = cmd
    state_manager.save(state)
    terminal.run_command(cmd, true)
  end)
end

local function run_last_custom_command()
  local cmd = state.last_custom_command or 'echo "No last command"'
  terminal.run_command(cmd, true)
end

function M.setup()
  state = state_manager.load({
    last_test_args = "",
    last_custom_command = nil,
  })

  local keymaps = {
    { "n", "<leader>tr", function() run_test() end, "Run tests" },
    { "n", "<leader>tR", run_test_with_args, "Run tests with args" },
    { "n", "<C-A-S-t>", function() run_test() end, "Run tests (meh+t)" },
    { "n", "<leader>tc", run_custom_command, "Run custom command" },
    { "n", "<leader>tC", run_last_custom_command, "Run last custom command" },
    { "n", "<C-A-S-c>", run_last_custom_command, "Run last custom command (meh+c)" },
  }

  for _, map in ipairs(keymaps) do
    vim.keymap.set(map[1], map[2], map[3], {
      noremap = true,
      silent = true,
      desc = map[4],
    })
  end

  -- Register with which-key
  local ok, wk = pcall(require, "which-key")
  if ok then
    wk.add(vim.tbl_map(function(m) return { m[2], desc = m[4] } end, keymaps))
  end
end

return M
