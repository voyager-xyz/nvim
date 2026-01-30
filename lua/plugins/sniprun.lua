return {
  "michaelb/sniprun",
  opts = {},
  build = "bash ./install.sh 1",
  cmd = "SnipRun",
  keys = {
    { "<leader>rr", "<cmd>SnipRun<CR>", mode = "n", desc = "SnipRun line" },
    { "<leader>rr", ":'<,'>SnipRun<CR>", mode = "v", desc = "SnipRun selection" },
    {
      "<C-M-S-r>",
      function()
        local keys = vim.api.nvim_replace_termcodes("vip:SnipRun<CR>", true, false, true)
        vim.api.nvim_feedkeys(keys, "n", false)
      end,
      mode = "n",
      desc = "SnipRun paragraph",
    },
  },
}