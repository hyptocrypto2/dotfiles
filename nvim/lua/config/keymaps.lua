-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Simplify changing variable names
vim.api.nvim_set_keymap(
  "n",
  "<leader>cn",
  ":let @/='\\<'.expand('<cword>').'\\>'<CR>cgn",
  { noremap = true, silent = true }
)

-- Make backspace behave and wrap on newlines
vim.opt.backspace = { "eol", "start", "indent" }
vim.opt.whichwrap:append("<,>,h,l")

-- Map Tab to indent in normal, visual, and select modes
vim.api.nvim_set_keymap("n", "<Tab>", ">>", { noremap = true })
vim.api.nvim_set_keymap("v", "<Tab>", ">gv", { noremap = true })
vim.api.nvim_set_keymap("s", "<Tab>", ">", { noremap = true })

-- Map Shift+Tab to unindent in normal, visual, and select modes
vim.api.nvim_set_keymap("n", "<S-Tab>", "<<", { noremap = true })
vim.api.nvim_set_keymap("v", "<S-Tab>", "<gv", { noremap = true })
vim.api.nvim_set_keymap("s", "<S-Tab>", "<", { noremap = true })

-- Personal
vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "r", "<C-r>", { noremap = true, silent = true })
