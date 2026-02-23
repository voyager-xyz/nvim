---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "pyright",
        "ruff",
        "standardrb",
        "kotlin-language-server",
        "typescript-language-server",
        "stylua",
        "debugpy",
        "tree-sitter-cli",
        "gopls",
      },
    },
  },
}
