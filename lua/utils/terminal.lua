local Terminal = require("toggleterm.terminal").Terminal

local M = {}

function M.create_terminal(cmd, opts)
  opts = opts or {}
  
  local terminal_config = {
    cmd = cmd,
    direction = opts.direction or "float",
    close_on_exit = opts.close_on_exit or false,
    float_opts = {
      border = opts.border or "curved",
      width = opts.width or math.floor(vim.o.columns * 0.9),
      height = opts.height or math.floor(vim.o.lines * 0.9),
    },
  }
  
  if opts.with_q_binding then
    terminal_config.on_open = function(term)
      local close = function() 
        term:close() 
      end
      -- Normal mode bindings
      vim.keymap.set("n", "q", close, { buffer = term.bufnr, noremap = true, silent = true })
      vim.keymap.set("n", "<Esc>", close, { buffer = term.bufnr, noremap = true, silent = true })
      -- Terminal mode binding - exit to normal and close
      vim.keymap.set("t", "<Esc><Esc>", close, { buffer = term.bufnr, noremap = true, silent = true })
    end
  end
  
  return Terminal:new(terminal_config)
end

function M.run_command(cmd, with_q_binding)
  M.create_terminal(cmd, { with_q_binding = with_q_binding }):toggle()
end

return M
