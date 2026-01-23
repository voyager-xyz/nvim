return {
  "session-log",
  dir = vim.fn.stdpath("config"),
  event = "VeryLazy",
  config = function()
    local date = os.date("%Y-%m-%d")
    local log_file = io.open(vim.fn.expand("~/.config/nvim/session-" .. date .. ".log"), "a")
    
    vim.on_key(function(key, typed)
      if log_file then
        local mode = vim.fn.mode()
        local timestamp = os.date("%Y-%m-%dT%H:%M:%S")
        local buffer = vim.fn.bufname()
        log_file:write(string.format("[%s] [%s] [%s] %s\n", timestamp, mode, buffer, typed))
        log_file:flush()
      end
    end, vim.api.nvim_create_namespace("key_logger"))
  end,
}