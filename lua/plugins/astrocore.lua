-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    --
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      n = {
        -- second key is the lefthand side of the map

        ["<C-d>"] = { "<C-d>zz", desc = "Half-page down and center" },
        ["<C-u>"] = { "<C-u>zz", desc = "Half-page up and center" },
        ["<C-A-S-o>"] = {
          function()
            local ok, snacks = pcall(require, "snacks")
            if ok and snacks.picker and snacks.picker.lsp_symbols then
              snacks.picker.lsp_symbols()
              return
            end
            local keys = vim.api.nvim_replace_termcodes("<Leader>ls", true, false, true)
            vim.api.nvim_feedkeys(keys, "n", false)
          end,
          desc = "Symbols (meh+l)",
        },
        ["<C-A-S-z>"] = { "<Cmd>ZenMode<CR>", desc = "Toggle Zen Mode (meh+z)" },
        ["<C-A-S-a>"] = { "ggVG", desc = "Select all (meh+a)" },
        ["<C-A-S-p>"] = { "vip", desc = "Select paragraph (meh+p)" },
        ["<C-A-S-d>"] = {
          function()
            local word = vim.fn.expand("<cword>")
            if word == nil or word == "" then
              vim.notify("Cursor must be under the cursor", vim.log.levels.ERROR)
              return
            end
            if vim.bo.filetype == "go" then
              local bufnr = vim.api.nvim_get_current_buf()
              local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
              local has_os = false
              local import_block_start = nil
              local import_block_end = nil

              for i, line in ipairs(lines) do
                if line:match('^%s*import%s+"os"') or line:match('^%s*"os"%s*$') then
                  has_os = true
                  break
                end
              end

              if not has_os then
                for i, line in ipairs(lines) do
                  if line:match("^%s*import%s*%(") then
                    import_block_start = i
                    for j = i + 1, #lines do
                      if lines[j]:match("^%s*%)%s*$") then
                        import_block_end = j
                        break
                      end
                    end
                    break
                  end
                end

                if import_block_start and import_block_end then
                  vim.api.nvim_buf_set_lines(bufnr, import_block_start, import_block_start, false, { "\t\"os\"" })
                else
                  for i, line in ipairs(lines) do
                    if line:match("^%s*package%s+%S+") then
                      vim.api.nvim_buf_set_lines(bufnr, i, i, false, { "", "import (", "\t\"os\"", ")" })
                      break
                    end
                  end
                end
              end
            end
            vim.cmd "normal! viw"
            local keys = vim.api.nvim_replace_termcodes("g?v", true, false, true)
            vim.api.nvim_feedkeys(keys, "x", false)
          end,
          desc = "Debugprint variable below (meh+D)",
        },

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        ["<C-A-S-j>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer (meh+j)" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
        ["<D-e>"] = {
          function()
            local ok, snacks = pcall(require, "snacks")
            if ok and snacks.picker and snacks.picker.buffers then
              snacks.picker.buffers()
              return
            end
            local keys = vim.api.nvim_replace_termcodes("<Leader>bb", true, false, true)
            vim.api.nvim_feedkeys(keys, "n", false)
          end,
          desc = "Find buffers",
        },
        ["<Leader>uT"] = {
          function()
            local ok_lazy, lazy = pcall(require, "lazy")
            if ok_lazy then
              local ok_themes, themes = pcall(require, "plugins.themes")
              if ok_themes and type(themes) == "table" then
                local plugins = {}
                for _, spec in ipairs(themes) do
                  if type(spec) == "string" then
                    table.insert(plugins, spec)
                  elseif type(spec) == "table" then
                    table.insert(plugins, spec.name or spec[1])
                  end
                end
                if #plugins > 0 then lazy.load({ plugins = plugins }) end
              end
            end
            local ok, snacks = pcall(require, "snacks")
            if ok and snacks.picker and snacks.picker.colorschemes then
              snacks.picker.colorschemes()
              return
            end
            vim.cmd "colorscheme"
          end,
          desc = "Pick colorscheme",
        },
      },
      v = {
        ["<C-A-S-x>"] = { "x", desc = "Cut selection (meh+x)" },
      },
    },
  },
}
