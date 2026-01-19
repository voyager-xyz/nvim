-- Detect project type and return appropriate test command
local M = {}

function M.get_test_command()
  local cwd = vim.fn.getcwd()
  
  -- Check for Ruby project (Gemfile)
  if vim.fn.filereadable(cwd .. "/Gemfile") == 1 then
    return "bundle exec rspec"
  end

  -- Check for Python project (pyproject.toml)
  if vim.fn.filereadable(cwd .. "/pyproject.toml") == 1 then
    return "poetry run pytest"
  end
  
  -- Check for Go project (go.mod)
  if vim.fn.filereadable(cwd .. "/go.mod") == 1 then
    return "go test ./..."
  end
  
  -- Default to pytest if no project file found
  return "pytest"
end

return M
