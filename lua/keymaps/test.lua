-- Test keybindings for running tests with toggleterm
local Terminal = require("toggleterm.terminal").Terminal
local test_utils = require("utils.test_command")
local last_test_args = ""

local M = {}

function M.setup()
  -- Run tests with no args
  vim.keymap.set("n", "<leader>tr", function()
    local test_cmd = test_utils.get_test_command()
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
    local test_cmd = test_utils.get_test_command()
    
    -- Use vim.ui.input with completion from command history
    vim.ui.input({
      prompt = "Test args: ",
      default = last_test_args,
      completion = "shellcmd",
    }, function(args)
      if args == nil then return end  -- User cancelled
      
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
    end)
  end, {
    noremap = true,
    silent = true,
    desc = "Run tests with args",
  })

  -- Add Meh+t keybinding for running tests
  vim.keymap.set("n", "<C-A-S-t>", function()
    local test_cmd = test_utils.get_test_command()
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
    desc = "Run tests (meh+t)",
  })

  -- Register with which-key
  local wk_status, wk = pcall(require, "which-key")
  if wk_status then
    wk.add({
      { "<leader>tr", desc = "Run tests" },
      { "<leader>tR", desc = "Run tests with args" },
    })
  end
end

return M
