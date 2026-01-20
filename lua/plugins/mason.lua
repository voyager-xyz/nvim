---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "pyright",
        "ruff",
        "stylua",
        "debugpy",
        "tree-sitter-cli",
        "gopls",
      },
    },
  },
}
