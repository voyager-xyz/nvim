return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      win = {
        input = {
          keys = {
            -- Trigger flash in both Normal and Insert modes
            ["<a-s>"] = { "flash", mode = { "n", "i" } },
            -- Trigger flash in Normal mode (alternative)
            ["s"] = { "flash" },
          },
        },
      },
      actions = {
        flash = function(picker)
          require("flash").jump({
            pattern = "^",
            label = { after = { 0, 0 } },
            search = {
              mode = "search",
              exclude = {
                function(win)
                  -- Exclude the input window, only target the list
                  return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
                end,
              },
            },
            action = function(match)
              -- Convert the matched line number to the item index
              local idx = picker.list:row2idx(match.pos[1])
              -- Move the selection to the item
              picker.list:_move(idx, true, true)
            end,
          })
        end,
      },
    },
  },
}
