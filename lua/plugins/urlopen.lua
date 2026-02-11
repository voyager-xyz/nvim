return {
  "sontungexpt/url-open",
  event = "VeryLazy",
  cmd = "URLOpenUnderCursor",
  config = function()
    require("url-open").setup({
      -- Add your custom configurations here
      open_app = "default", -- or "browser", "chrome", etc.
      highlight_url = {
        all = true, -- highlight all URLs in the buffer
        cursor = true, -- highlight URL under cursor
      },
    })
  end,
  keys = {
    { "<leader>gu", "<cmd>URLOpenUnderCursor<cr>", desc = "Open URL under cursor" },
  },
}
