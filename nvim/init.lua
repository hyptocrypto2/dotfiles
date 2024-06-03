-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Make tabs work to move through intellisence menus
-- Ensure cmp is installed and required
local cmp = require("cmp")
cmp.setup({
  mapping = {
    ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item.
    ["<C-e>"] = cmp.mapping.close(), -- Close the completion menu.
  },
  sources = {
    { name = "nvim_lsp" }, -- LSP source
    { name = "buffer" }, -- Buffer source
    { name = "path" }, -- File path source
    { name = "luasnip" }, -- Snippets source
  },
  -- Other cmp configurations...
})

-- Ensure you have set completeopt to have a better completion experience
vim.o.completeopt = "menu,menuone,noselect"

-- Auto-command setup for Python files
vim.api.nvim_exec(
  [[
    augroup FormatAutogroup
        autocmd!
        autocmd BufWritePost *.py execute '!isort ' . expand('%:p') | execute '!ruff check --fix ' . expand('%:p') | execute '!autoflake --remove-all-unused-imports ' . expand('%:p') | execute '!black ' . expand('%:p')
    augroup END
]],
  true
)

-- Dont show leading whitespace dashes
vim.opt.list = false

-- Use system clipboard
vim.o.clipboard = "unnamedplus"

-- Set line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Turn off backup
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Use spaces instead of tabs
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
