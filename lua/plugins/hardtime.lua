return {
  "m4xshen/hardtime.nvim",
  lazy = false,
  opts = {
    max_count = 3,
    disabled_keys = {
      ["<Insert>"] = { "", "i" },
      ["<Home>"] = { "", "i" },
      ["<End>"] = { "", "i" },
      ["<PageUp>"] = { "", "i" },
      ["<PageDown>"] = { "", "i" },
    },
  },
  dependencies = { "MunifTanjim/nui.nvim" },
}