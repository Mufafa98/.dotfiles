vim.opt.clipboard = "unnamedplus"
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.shiftwidth = 0
vim.o.tabstop = 4
vim.o.swapfile = false
vim.o.writebackup = false
vim.o.undofile = true

vim.opt.termguicolors = true

-- Folding
vim.opt.foldcolumn = "1"    -- display fold icons on 1 column
vim.opt.foldlevel = 99      -- close folds with a higher level
vim.opt.foldlevelstart = 99 -- set foldlevel to 99 on new buffers
vim.opt.foldenable = true
vim.opt.fillchars = {
  eob = " ",
  -- folding fillchars
  fold = " ",
  foldopen = "",
  foldclose = "",
  foldsep = " ",
}
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.api.nvim_create_autocmd("BufWinLeave", {
    pattern = "*.*",
    command = "mkview",
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*.*",
    command = "silent! loadview",
})

vim.opt.wrap = true
vim.opt.breakindent = true
