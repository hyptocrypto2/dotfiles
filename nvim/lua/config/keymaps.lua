-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Function to toggle between the current buffer and Neo-tree
function ToggleNeoTree()
  local bufnr = vim.fn.bufnr()
  local winid = vim.fn.bufwinid(bufnr)
  if winid == -1 then
    -- If the buffer is not in any window, open Neo-tree
    vim.cmd("Neotree toggle")
  else
    -- If the buffer is in a window, go to the next window (Neo-tree)
    vim.cmd("wincmd w")
  end
end

-- Keymap to toggle between the current buffer and Neo-tree
vim.api.nvim_set_keymap("n", "<leader>t", ":lua ToggleNeoTree()<CR>", { noremap = true, silent = true })

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

-- Golang
vim.api.nvim_set_keymap("c", "ifer", "GoIfErr<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("c", "bb", "DapToggleBreakpoint", { noremap = true, silent = true })

local dap = require("dap")
local dap_go = require("dap-go")

-- Helper function to run `go test` and handle notifications
local function run_go_test_command(cmd, success_title, fail_title)
  local output = vim.fn.systemlist(cmd)
  local output_str = table.concat(output, "\n")
  local timeout = 10000

  if vim.v.shell_error == 0 then
    vim.notify(output_str, vim.log.levels.INFO, { title = success_title, timeout = timeout })
  else
    vim.notify(
      "Error running `go test`:\n" .. output_str,
      vim.log.levels.ERROR,
      { title = fail_title, timeout = timeout }
    )
  end
end

-- Function to run the nearest Go test under the cursor
local function run_nearest_go_test()
  -- Get the test name under the cursor
  local test_name = vim.fn.search("^func Test", "bnW")
  if test_name == 0 then
    vim.notify("No test function found near the cursor", vim.log.levels.WARN, { title = "Go Test" })
    return
  end

  -- Extract the name of the test function
  local line = vim.fn.getline(test_name)
  local test_func = line:match("^func%s+(Test%w+)")
  if not test_func then
    vim.notify("Failed to parse test function name", vim.log.levels.ERROR, { title = "Go Test" })
    return
  end

  -- Build and run the `go test` command
  local cmd = "go test -v -run " .. test_func
  run_go_test_command(cmd, "Go Test Success", "Go Test Failed")
end

-- Function to run all Go tests in the current file
local function run_go_tests()
  local cmd = "go test -v"
  run_go_test_command(cmd, "Go Test Success", "Go Test Failed")
end

local function debug_test()
  dap_go.debug_test()
  if not dap.repl.open() then
    dap.repl.toggle()
  end
end

-- Create a command to trigger the function
vim.api.nvim_create_user_command("Gotest", run_nearest_go_test, {})
vim.api.nvim_create_user_command("Gotestd", debug_test, {})
vim.api.nvim_create_user_command("Gotestall", run_go_tests, {})
