return {
  "folke/flash.nvim",
  event = "VeryLazy",
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          x = {
            ["s"] = {
              function() require("flash").jump() end,
              desc = "Flash",
            },
            ["<leader>s"] = {
              function()
                require("flash").jump({
                  search = { mode = "search", max_length = 0 },
                  label = { after = { 0, 0 } },
                  pattern = "^",
                })
              end,
              desc = "Flash Line Start",
            },
            ["R"] = {
              function() require("flash").treesitter_search() end,
              desc = "Treesitter Search",
            },
            ["S"] = {
              function() require("flash").treesitter() end,
              desc = "Flash Treesitter",
            },
          },
          o = {
            ["r"] = {
              function() require("flash").remote() end,
              desc = "Remote Flash",
            },
            ["R"] = {
              function() require("flash").treesitter_search() end,
              desc = "Treesitter Search",
            },
            ["<leader>s"] = {
              function()
                require("flash").jump({
                  search = { mode = "search", max_length = 0 },
                  label = { after = { 0, 0 } },
                  pattern = "^",
                })
              end,
              desc = "Flash Line Start",
            },
            ["s"] = {
              function() require("flash").jump() end,
              desc = "Flash",
            },
            ["S"] = {
              function() require("flash").treesitter() end,
              desc = "Flash Treesitter",
            },
          },
          n = {
            ["s"] = {
              function() require("flash").jump() end,
              desc = "Flash",
            },
            ["<C-A-S-s>"] = {
              function()
                local start_pos = vim.api.nvim_win_get_cursor(0)
                require("flash").jump({
                  search = { mode = "search", max_length = 2 },
                  action = function(match)
                    local length = match.len or (match.text and #match.text) or 1
                    local end_pos = match.end_pos or { match.pos[1], match.pos[2] + length - 1 }
                    vim.api.nvim_win_set_cursor(0, start_pos)
                    vim.cmd("normal! v")
                    vim.api.nvim_win_set_cursor(0, end_pos)
                  end,
                })
              end,
              desc = "Flash select to match (meh+s)",
            },
            ["<leader>s"] = {
              function()
                require("flash").jump({
                  search = { mode = "search", max_length = 0 },
                  label = { after = { 0, 0 } },
                  pattern = "^",
                })
              end,
              desc = "Flash Line Start",
            },
            ["S"] = {
              function() require("flash").treesitter() end,
              desc = "Flash Treesitter",
            },
          },
        },
      },
    },
  },
  opts = {},
}
