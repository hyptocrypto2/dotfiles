-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--- Run python linters

local format_group = vim.api.nvim_create_augroup("FormatAutogroup", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.py",
  group = format_group,
  callback = function()
    local filename = vim.fn.expand("%:p")
    vim.fn.system("isort " .. filename)
    vim.fn.system("ruff check --fix " .. filename)
    vim.fn.system("autoflake --remove-all-unused-imports " .. filename)
    vim.fn.system("black " .. filename)
  end,
})
