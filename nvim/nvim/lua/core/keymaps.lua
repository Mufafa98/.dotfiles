-- Set leader key (usually at the top)
local function keymap(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

vim.g.mapleader = " "
-- Add these to lua/core/keymaps.lua
keymap('n', '<C-h>', '<C-w>h')
keymap('n', '<C-j>', '<C-w>j')
keymap('n', '<C-k>', '<C-w>k')
keymap('n', '<C-l>', '<C-w>l')

keymap('n', '<Esc>', '<cmd>nohlsearch<CR><Esc>')

keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

keymap('n', '<C-/>', 'gcc', { remap = true })
keymap('v', '<C-/>', 'gc', { remap = true })

keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")




























