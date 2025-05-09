-- Open Parent directory in Oil
vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", opts)

vim.keymap.set("n", "<leader>format", function()
	require("conform").format()
end, { desc = "fmt" })

vim.keymap.set("n", "<leader>lyc", function()
	require("oil").open_float("/mnt/c/Users/steph/OneDrive - Région Île-de-France")
end, { desc = "go to Onedrive" })

vim.keymap.set("n", "<leader>pr", function()
	require("oil").open_float("/home/steph/Sync/premieres")
end, { desc = "go to premieres website" })

vim.keymap.set("n", "<leader>sec", function()
	require("oil").open_float("/home/steph/Sync/secondes")
end, { desc = "go to secondes website" })

vim.keymap.set("n", "<leader>ter", function()
	require("oil").open_float("/home/steph/Sync/terminales")
end, { desc = "go to terminales website" })

vim.keymap.set("n", "<leader>cfg", function()
	require("oil").open_float("/home/steph/.config/nvim/")
end, { desc = "go to ~/.config/nvim/ " })
-- Keymap to toggle transparency in Kanagawa theme
vim.keymap.set("n", "<leader>tt", function()
	-- Call the global toggle_transparency function defined in kanagawa.lua
	vim.cmd("lua toggle_transparency()")
end, { desc = "Toggle transparency" })

-- Save file without auto-formatting
vim.keymap.set("n", "<leader>sn", "<cmd>noautocmd w <CR>", opts)

-- Ctrl s & Ctrl q
--vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', opts)
--vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts)

-- delete single character without copying it into register
vim.keymap.set("n", "x", '"_x', opts)

-- shortcut for MarkdownPreview
vim.keymap.set("n", "<leader>md", "<cmd>MarkdownPreview <CR>", opts)

-- Toggle line wrapping
vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", "<gv", opts)

-- keep last yanked when pasting

vim.keymap.set("v", "p", '"_dP', opts)

-- Window management
vim.keymap.set("n", "<leader>v", "<C-w>v", opts) -- split window vertically
vim.keymap.set("n", "<leader>h", "<C-w>s", opts) -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", opts) -- make split windows equal width & height
vim.keymap.set("n", "<leader>xs", ":close<CR>", opts) -- close current split window

-- Navigate between splits
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)
vim.keymap.set("i", "fd", "<Esc>")

--LSP
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { noremap = true, silent = true })
