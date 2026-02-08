return {
  {
    "AstroNvim/astrocore",
    opts = {
      commands = {
        RDS = {
          function(opts)
            local function replace_in_quoted(line)
              local out = {}
              local in_single = false
              local in_double = false
              local escaped = false
              local i = 1

              while i <= #line do
                local ch = line:sub(i, i)
                if escaped then
                  table.insert(out, ch)
                  escaped = false
                  i = i + 1
                elseif ch == "\\" then
                  table.insert(out, ch)
                  escaped = true
                  i = i + 1
                elseif ch == "'" and not in_double then
                  in_single = not in_single
                  table.insert(out, ch)
                  i = i + 1
                elseif ch == '"' and not in_single then
                  in_double = not in_double
                  table.insert(out, ch)
                  i = i + 1
                elseif (in_single or in_double) and ch == " " then
                  table.insert(out, " ")
                  i = i + 1
                  while i <= #line and line:sub(i, i) == " " do
                    i = i + 1
                  end
                else
                  table.insert(out, ch)
                  i = i + 1
                end
              end

              return table.concat(out)
            end

            local range = opts and opts.range or 0
            local bufnr = vim.api.nvim_get_current_buf()
            local start_line
            local end_line

            if range == 0 then
              start_line = vim.fn.nextnonblank(1)
              if start_line == 0 then
                return
              end
              end_line = vim.api.nvim_buf_line_count(bufnr)
            else
              start_line = opts.line1
              end_line = opts.line2
            end

            local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)
            for idx, line in ipairs(lines) do
              lines[idx] = replace_in_quoted(line)
            end
            vim.api.nvim_buf_set_lines(bufnr, start_line - 1, end_line, false, lines)
          end,
          desc = "Replace double spaces inside quotes",
          range = true,
        },
      },
    },
  },
}
