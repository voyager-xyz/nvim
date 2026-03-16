---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local null_ls = require "null-ls"
    local function ktlint_args(params)
      local editorconfig = vim.fs.find(".editorconfig", { upward = true, path = params.bufname })[1]
      if editorconfig then
        return { "--editorconfig=" .. editorconfig }
      end
      return {}
    end
    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      null_ls.builtins.formatting.ktlint.with({ extra_args = ktlint_args }),
      null_ls.builtins.diagnostics.ktlint.with({ extra_args = ktlint_args }),
    })
  end,
}
