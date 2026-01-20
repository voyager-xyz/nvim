local M = {}

local history_file = vim.fn.stdpath("data") .. "/command_history.txt"
local MAX_HISTORY = 100

function M.load_history()
  local history = {}
  if vim.fn.filereadable(history_file) == 1 then
    for line in io.lines(history_file) do
      if line ~= "" then table.insert(history, line) end
    end
  end
  return history
end

function M.save_to_history(cmd)
  if cmd == "" then return end
  
  local history = M.load_history()
  
  -- Remove duplicate
  for i = #history, 1, -1 do
    if history[i] == cmd then table.remove(history, i) end
  end
  
  table.insert(history, cmd)
  
  -- Keep only last MAX_HISTORY commands
  while #history > MAX_HISTORY do
    table.remove(history, 1)
  end
  
  -- Write to file
  local file = io.open(history_file, "w")
  if file then
    for _, h in ipairs(history) do file:write(h .. "\n") end
    file:close()
  end
end

function M.input_with_history(prompt, callback)
  local history = M.load_history()
  local history_index = #history + 1
  local current_input = ""
  
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.6)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = 1,
    row = math.floor((vim.o.lines - 1) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = prompt,
    title_pos = "center",
  })
  
  vim.api.nvim_buf_set_option(buf, "buftype", "prompt")
  vim.fn.prompt_setprompt(buf, "")
  vim.cmd("startinsert")
  
  local function close_and_execute(execute)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local cmd = table.concat(lines, ""):gsub("^%s*(.-)%s*$", "%1")
    
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_buf_delete(buf, { force = true })
    
    if execute and cmd ~= "" then
      M.save_to_history(cmd)
      callback(cmd)
    end
  end
  
  local function navigate_history(direction)
    local new_index = history_index + (direction == "up" and -1 or 1)
    
    if new_index >= 1 and new_index <= #history + 1 then
      history_index = new_index
      local text = history_index <= #history and history[history_index] or current_input
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, { text })
      vim.cmd("startinsert!")
    end
  end
  
  local keymaps = {
    { "i", "<CR>", function() close_and_execute(true) end },
    { "i", "<C-c>", function() close_and_execute(false) end },
    { "i", "<Esc>", function() close_and_execute(false) end },
    { "i", "<Up>", function() navigate_history("up") end },
    { "i", "<Down>", function() navigate_history("down") end },
    { "i", "<C-p>", function() navigate_history("up") end },
    { "i", "<C-n>", function() navigate_history("down") end },
  }
  
  for _, map in ipairs(keymaps) do
    vim.keymap.set(map[1], map[2], map[3], { buffer = buf, noremap = true })
  end
  
  -- Store current input when typing
  local function update_current_input()
    if history_index == #history + 1 then
      current_input = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "")
    end
  end
  
  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    buffer = buf,
    callback = update_current_input,
  })
end

return M
