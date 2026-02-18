-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  local result = vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
  if vim.v.shell_error ~= 0 then
    -- stylua: ignore
    vim.api.nvim_echo({ { ("Error cloning lazy.nvim:\n%s\n"):format(result), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
    vim.fn.getchar()
    vim.cmd.quit()
  end
end

vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end
vim.cmd([[
  let &t_TI = "\<Esc>[>4;2m"
  let &t_TE = "\<Esc>[>4;m"
]])

-- Enable kitty keyboard protocol for proper Ctrl+Alt+Shift support
-- This must be done before loading plugins
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Enable kitty keyboard protocol (CSI u mode)
    io.stdout:write("\x1b[>1u")
  end,
})

vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    -- Disable kitty keyboard protocol on exit
    io.stdout:write("\x1b[<1u")
  end,
})
require "lazy_setup"
require "polish"
