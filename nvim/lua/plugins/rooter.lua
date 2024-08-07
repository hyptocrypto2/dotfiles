return {
  "airblade/vim-rooter",
  config = function()
    vim.g.rooter_patterns = { ".git" } -- Add other patterns as needed
    vim.g.rooter_manual_only = 1 -- Disable automatic rooter for every buffer change
    vim.cmd("autocmd BufEnter * Rooter") -- Trigger Rooter on BufEnter
  end,
}
