return {
  "session-log",
  dir = vim.fn.stdpath("config"),
  event = "VeryLazy",
  config = function()
    local sessions_dir = vim.fn.expand("~/.config/nvim/sessions")

    if vim.fn.isdirectory(sessions_dir) == 0 then
      vim.fn.mkdir(sessions_dir, "p")
    end

    local date = os.date("%Y-%m-%d")
    local log_path = sessions_dir .. "/" .. date .. ".log"
    local log_file = io.open(log_path, "a")

    if not log_file then
      vim.notify("Failed to open session log file: " .. log_path, vim.log.levels.ERROR)
      return
    end

    -- Ensure file is closed on exit
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        if log_file then
          log_file:close()
          log_file = nil
        end
      end,
    })

    local function log_command(command, mode, buffer_name, timestamp)
      if log_file and command ~= "" then
        log_file:write(string.format("%s,%s,%s,%s\n", timestamp, mode, buffer_name, command))
        log_file:flush()
      end
    end

    vim.on_key(function(_, typed)
      if not log_file then return end

      local mode = vim.fn.mode()
      local buffer_name = vim.fn.bufname()
      if buffer_name == "" then
        buffer_name = "[No Name]"
      end

      local timestamp = os.date("%Y-%m-%dT%H:%M:%S")
      log_command(typed, mode, buffer_name, timestamp)
    end, vim.api.nvim_create_namespace("key_logger"))
  end,
}
