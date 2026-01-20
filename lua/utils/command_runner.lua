-- Command runner with history support
local M = {}

-- Store command history in a persistent location
local history_file = vim.fn.stdpath("data") .. "/command_history.txt"
local command_history = {}
local history_index = 0

-- Load command history from file
function M.load_history()
  command_history = {}
  if vim.fn.filereadable(history_file) == 1 then
    for line in io.lines(history_file) do
      if line ~= "" then
        table.insert(command_history, line)
      end
    end
  end
end

-- Save command to history
function M.save_to_history(cmd)
  if cmd == "" then return end
  
  -- Load current history
  M.load_history()
  
  -- Remove duplicate if exists
  for i, existing_cmd in ipairs(command_history) do
    if existing_cmd == cmd then
      table.remove(command_history, i)
      break
    end
  end
  
  -- Add to the end
  table.insert(command_history, cmd)
  
  -- Keep only last 100 commands
  if #command_history > 100 then
    table.remove(command_history, 1)
  end
  
  -- Write to file
  local file = io.open(history_file, "w")
  if file then
    for _, history_cmd in ipairs(command_history) do
      file:write(history_cmd .. "\n")
    end
    file:close()
  end
end

-- Get command history for completion
function M.get_history()
  M.load_history()
  return command_history
end

-- Custom input with history navigation
function M.input_with_history(prompt, callback)
  M.load_history()
  history_index = #command_history + 1
  local current_input = ""
  
  -- Create a buffer for input
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.6)
  local height = 1
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = prompt,
    title_pos = "center",
  })
  
  -- Set buffer options
  vim.api.nvim_buf_set_option(buf, "buftype", "prompt")
  vim.fn.prompt_setprompt(buf, "")
  
  -- Start insert mode
  vim.cmd("startinsert")
  
  -- Handle submit
  local function submit()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local cmd = table.concat(lines, ""):gsub("^%s*(.-)%s*$", "%1")
    
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_buf_delete(buf, { force = true })
    
    if cmd ~= "" then
      M.save_to_history(cmd)
      callback(cmd)
    end
  end
  
  -- Handle cancel
  local function cancel()
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_buf_delete(buf, { force = true })
  end
  
  -- Navigate history
  local function navigate_history(direction)
    if direction == "up" and history_index > 1 then
      history_index = history_index - 1
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, { command_history[history_index] })
      vim.cmd("startinsert!")
    elseif direction == "down" then
      if history_index < #command_history then
        history_index = history_index + 1
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { command_history[history_index] })
        vim.cmd("startinsert!")
      elseif history_index == #command_history then
        history_index = #command_history + 1
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { current_input })
        vim.cmd("startinsert!")
      end
    end
  end
  
  -- Key mappings
  vim.keymap.set("i", "<CR>", submit, { buffer = buf, noremap = true })
  vim.keymap.set("i", "<C-c>", cancel, { buffer = buf, noremap = true })
  vim.keymap.set("i", "<Esc>", cancel, { buffer = buf, noremap = true })
  vim.keymap.set("i", "<Up>", function() navigate_history("up") end, { buffer = buf, noremap = true })
  vim.keymap.set("i", "<Down>", function() navigate_history("down") end, { buffer = buf, noremap = true })
  vim.keymap.set("i", "<C-p>", function() navigate_history("up") end, { buffer = buf, noremap = true })
  vim.keymap.set("i", "<C-n>", function() navigate_history("down") end, { buffer = buf, noremap = true })
  
  -- Store current input when typing
  vim.api.nvim_create_autocmd("TextChanged", {
    buffer = buf,
    callback = function()
      if history_index == #command_history + 1 then
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        current_input = table.concat(lines, "")
      end
    end,
  })
  vim.api.nvim_create_autocmd("TextChangedI", {
    buffer = buf,
    callback = function()
      if history_index == #command_history + 1 then
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        current_input = table.concat(lines, "")
      end
    end,
  })
end

return M
