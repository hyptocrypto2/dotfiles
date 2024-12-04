-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- Lazyvim LSP Configuration
local lspconfig = require("lspconfig")

lspconfig.eslint.setup({
  settings = {
    workingDirectory = { mode = "auto" },
  },
  on_attach = function(client, bufnr)
    -- Add your custom on_attach functions here
  end,
})
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

require("dap-go").setup()

lspconfig.ruff.setup({})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.py",
  callback = function()
    vim.lsp.buf.code_action({
      context = {
        only = {
          "source.fixAll.ruff",
        },
      },
      apply = true,
    })
    vim.lsp.buf.format({ async = false })
  end,
})

vim.o.completeopt = "menu,menuone,noselect"

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

lspconfig.gopls.setup({
  settings = {
    gopls = {
      gofumpt = true,
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = false,
        compositeLiteralFields = false,
        compositeLiteralTypes = false,
        constantValues = false,
        functionTypeParameters = false,
        parameterNames = false,
        rangeVariableTypes = false,
      },
      analyses = {
        fieldalignment = true,
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
      semanticTokens = true,
    },
  },
  -- other options
})
