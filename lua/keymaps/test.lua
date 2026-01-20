-- Test keybindings for running tests with toggleterm
local Terminal = require("toggleterm.terminal").Terminal
local test_utils = require("utils.test_command")
local command_runner = require("utils.command_runner")
local last_test_args = ""
local last_custom_command = nil

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

  -- Run any command with history
  vim.keymap.set("n", "<leader>tc", function()
    command_runner.input_with_history("Run command: ", function(cmd)
      last_custom_command = cmd
      local cmd_terminal = Terminal:new({
        cmd = cmd,
        direction = "float",
        close_on_exit = false,
        float_opts = {
          border = "curved",
          width = math.floor(vim.o.columns * 0.9),
          height = math.floor(vim.o.lines * 0.9),
        },
        on_open = function(term)
          vim.keymap.set("n", "q", function()
            term:close()
          end, { buffer = term.bufnr, noremap = true, silent = true })
        end,
      })
      cmd_terminal:toggle()
    end)
  end, {
    noremap = true,
    silent = true,
    desc = "Run custom command",
  })

  -- Run last custom command
  vim.keymap.set("n", "<leader>tC", function()
    local cmd = last_custom_command or 'echo "No last command"'
    local cmd_terminal = Terminal:new({
      cmd = cmd,
      direction = "float",
      close_on_exit = false,
      float_opts = {
        border = "curved",
        width = math.floor(vim.o.columns * 0.9),
        height = math.floor(vim.o.lines * 0.9),
      },
      on_open = function(term)
        vim.keymap.set("n", "q", function()
          term:close()
        end, { buffer = term.bufnr, noremap = true, silent = true })
      end,
    })
    cmd_terminal:toggle()
  end, {
    noremap = true,
    silent = true,
    desc = "Run last custom command",
  })

  -- Add Meh+c keybinding for running custom commands
  vim.keymap.set("n", "<C-A-S-c>", function()
    command_runner.input_with_history("Run command: ", function(cmd)
      local cmd_terminal = Terminal:new({
        cmd = cmd,
        direction = "float",
        close_on_exit = false,
        float_opts = {
          border = "curved",
          width = math.floor(vim.o.columns * 0.9),
          height = math.floor(vim.o.lines * 0.9),
        },
        on_open = function(term)
          vim.keymap.set("n", "q", function()
            term:close()
          end, { buffer = term.bufnr, noremap = true, silent = true })
        end,
      })
      cmd_terminal:toggle()
    end)
  end, {
    noremap = true,
    silent = true,
    desc = "Run custom command (meh+c)",
  })

  -- Register with which-key
  local wk_status, wk = pcall(require, "which-key")
  if wk_status then
    wk.add({
      { "<leader>tr", desc = "Run tests" },
      { "<leader>tc", desc = "Run custom command" },
      { "<leader>tR", desc = "Run tests with args" },
      { "<leader>tC", desc = "Run last custom command" },

    })
  end
end

return M
