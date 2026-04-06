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
      diagnostics = { virtual_text = false, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    --
    diagnostics = {
      virtual_text = false,
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
        wrap = true, -- sets vim.opt.wrap
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
            if not ok or not snacks.picker then return end
            local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
            if not git_root or git_root == "" then git_root = vim.fn.getcwd() end
            snacks.picker.pick({
              title = "Directories",
              finder = function(_, ctx)
                local items = {}
                local output = vim.fn.systemlist("fd --type d --hidden --exclude .git . " .. vim.fn.shellescape(git_root))
                if vim.v.shell_error ~= 0 then
                  output = vim.fn.systemlist("find " .. vim.fn.shellescape(git_root) .. " -type d -not -path '*/.git/*'")
                end
                for _, path in ipairs(output) do
                  local rel = path:sub(#git_root + 2)
                  table.insert(items, {
                    text = rel,
                    file = path,
                    _path = path,
                  })
                end
                return items
              end,
              format = function(item) return { { item.text } } end,
              confirm = function(picker, item)
                picker:close()
                if item then require("oil").open(item._path) end
              end,
            })
          end,
          desc = "Open directory in Oil (meh+o)",
        },
        ["<C-A-S-a>"] = { "ggVG", desc = "Select all (meh+a)" },

        -- navigate buffer tabs
        ["<C-A-S-m>"] = { "<cmd>Grapple toggle_tags<CR>", desc = "Grapple menu (meh+m)" },
        ["<C-A-S-d>"] = {
          function()
            local ok, snacks = pcall(require, "snacks")
            if ok and snacks.picker and snacks.picker.marks then
              snacks.picker.marks({
                transform = function(item)
                  if item.label and item.label:match("^%a$") then
                    return item
                  end
                  return false
                end,
                on_show = function(picker)
                  for c = string.byte("a"), string.byte("z") do
                    local letter = string.char(c)
                    for _, l in ipairs({ letter, letter:upper() }) do
                      vim.keymap.set("n", l, function()
                        for _, item in ipairs(picker:items()) do
                          if item.label == l then
                            picker:action("confirm", item)
                            vim.cmd("normal! zz")
                            return
                          end
                        end
                      end, { buffer = picker.list.win.buf, nowait = true })
                    end
                  end
                end,
              })
              return
            end
            local keys = vim.api.nvim_replace_termcodes("<Leader>sm", true, false, true)
            vim.api.nvim_feedkeys(keys, "n", false)
          end,
          desc = "Find letter marks (meh+d)",
        },
        ["<C-A-S-w>"] = {
          function()
            local ok, snacks = pcall(require, "snacks")
            if ok and snacks.picker and snacks.picker.grep then
              snacks.picker.grep()
              return
            end
            local keys = vim.api.nvim_replace_termcodes("<Leader>fw", true, false, true)
            vim.api.nvim_feedkeys(keys, "n", false)
          end,
          desc = "Find words (meh+w)",
        },
        ["<C-A-S-;>"] = {
          function()
            local pattern = vim.fn.input("Glob pattern: ")
            if pattern == "" then return end
            local ok, snacks = pcall(require, "snacks")
            if ok and snacks.picker and snacks.picker.grep then
              snacks.picker.grep({ glob = pattern })
            end
          end,
          desc = "Find words by glob (meh+;)",
        },
        ["<C-A-S-s>"] = {
          function()
            local ok, snacks = pcall(require, "snacks")
            if ok and snacks.picker and snacks.picker.smart then
              snacks.picker.smart()
              return
            end
            local keys = vim.api.nvim_replace_termcodes("<Leader>ff", true, false, true)
            vim.api.nvim_feedkeys(keys, "n", false)
          end,
          desc = "Smart find (meh+s)",
        },
        ["<C-A-S-f>"] = {
          function()
            local ok, snacks = pcall(require, "snacks")
            if ok and snacks.picker and snacks.picker.files then
              snacks.picker.files()
              return
            end
            local keys = vim.api.nvim_replace_termcodes("<Leader>ff", true, false, true)
            vim.api.nvim_feedkeys(keys, "n", false)
          end,
          desc = "Find files (meh+f)",
        },
        ["<C-A-S-l>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer (meh+b)" },
        ["<C-A-S-h>"] = { function() require("astrocore.buffer").nav(-(vim.v.count1)) end, desc = "Previous buffer (meh+h)" },
        ["<C-A-S-b>"] = {
          function()
            local ok, snacks = pcall(require, "snacks")
            if ok and snacks.picker and snacks.picker.buffers then
              snacks.picker.buffers({
                focus = "list",
                win = {
                  input = {
                    keys = {
                      ["<C-A-S-b>"] = { "list_down", mode = { "i", "n" } },
                    },
                  },
                  list = {
                    keys = {
                      ["<C-A-S-b>"] = { "list_down", mode = { "i", "n" } },
                    },
                  },
                },
              })
              return
            end
            local keys = vim.api.nvim_replace_termcodes("<Leader>bb", true, false, true)
            vim.api.nvim_feedkeys(keys, "n", false)
          end,
          desc = "Find buffers (meh+b)",
        },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        ["<Leader>bo"] = {
          function() require("astrocore.buffer").close_all(true) end,
          desc = "Close all buffers except current",
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
