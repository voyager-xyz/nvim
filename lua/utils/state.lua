local M = {}

local state_file = vim.fn.stdpath("data") .. "/test_keymaps_state.json"

function M.load(defaults)
  defaults = defaults or {}
  
  if vim.fn.filereadable(state_file) == 1 then
    local content = vim.fn.readfile(state_file)
    local ok, state = pcall(vim.json.decode, table.concat(content, "\n"))
    if ok and state then
      for key, value in pairs(state) do
        if value == vim.NIL then
          defaults[key] = nil
        else
          defaults[key] = value
        end
      end
    end
  end
  
  return defaults
end

function M.save(state)
  local encoded_state = {}
  for key, value in pairs(state) do
    encoded_state[key] = value == nil and vim.NIL or value
  end
  
  local ok, json = pcall(vim.json.encode, encoded_state)
  if ok then
    vim.fn.writefile({ json }, state_file)
  end
end

return M
