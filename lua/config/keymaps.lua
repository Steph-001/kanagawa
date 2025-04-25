-- Open Parent directory in Oil
vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", opts)
vim.keymap.set("n", "<leader>lyc", function()
  require("oil").open_float("/mnt/c/Users/steph/OneDrive - Région Île-de-France")
end, { desc = "go to Onedrive" })


-- Save file without auto-formatting
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', opts)

-- Ctrl s & Ctrl q
--vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', opts)
--vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts)

-- delete single character without copying it into register
vim.keymap.set('n', 'x', '"_x', opts)

-- shortcut for MarkdownPreview
vim.keymap.set('n', '<leader>md', '<cmd>MarkdownPreview <CR>', opts)

-- Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '<gv', opts)

-- keep last yanked when pasting

vim.keymap.set('v', 'p', '"_dP', opts)


-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v', opts) -- split window vertically
vim.keymap.set('n', '<leader>h', '<C-w>s', opts) -- split window horizontally
vim.keymap.set('n', '<leader>se', '<C-w>=', opts) -- make split windows equal width & height
vim.keymap.set('n', '<leader>xs', ':close<CR>', opts) -- close current split window

-- Navigate between splits
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)
vim.keymap.set("i", "fd", "<Esc>")
