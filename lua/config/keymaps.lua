---@diagnostic disable: undefined-global
-- Tell the LSP that 'vim' is a valid global
-- stylua: ignore
---@diagnostic disable-next-line: lowercase-global
vim = vim

-- Define opts with sensible defaults if not already defined
local opts = opts or { noremap = true, silent = true }

-- Open Parent directory in Oil
vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", opts)

-- Format code
vim.keymap.set("n", "<leader>format", function()
	require("conform").format()
end, { desc = "Format code" })

-- Directory navigation shortcuts
vim.keymap.set("n", "<leader>lyc", function()
	require("oil").open_float("/mnt/c/Users/steph/OneDrive - Région Île-de-France")
end, { desc = "Go to Onedrive" })

vim.keymap.set("n", "<leader>nts", function()
	require("oil").open_float("/mnt/c/Users/steph/OneDrive - Région Île-de-France/notes")
end, { desc = "Go to Onedrive" })

vim.keymap.set("n", "<leader>pr", function()
	require("oil").open_float("/home/steph/Sync/premieres")
end, { desc = "Go to premieres website" })

vim.keymap.set("n", "<leader>sec", function()
	require("oil").open_float("/home/steph/Sync/secondes")
end, { desc = "Go to secondes website" })

vim.keymap.set("n", "<leader>ter", function()
	require("oil").open_float("/home/steph/Sync/terminales")
end, { desc = "Go to terminales website" })

vim.keymap.set("n", "<leader>cfg", function()
	require("oil").open_float("/home/steph/.config/nvim/")
end, { desc = "Go to ~/.config/nvim/" })

-- Keymap to toggle transparency in Kanagawa theme
vim.keymap.set("n", "<leader>tt", function()
	-- Check if the toggle_transparency function exists before calling it
	if _G.toggle_transparency then
		_G.toggle_transparency()
	else
		vim.cmd("lua toggle_transparency()")
	end
end, { desc = "Toggle transparency" })

-- Save file without auto-formatting
vim.keymap.set("n", "<leader>sn", "<cmd>noautocmd w<CR>", opts)

-- Ctrl s & Ctrl q (commented out)
-- vim.keymap.set('n', '<C-s>', '<cmd>w<CR>', opts)
-- vim.keymap.set('n', '<C-q>', '<cmd>q<CR>', opts)

-- Delete single character without copying it into register
vim.keymap.set("n", "x", '"_x', opts)

-- Shortcut for MarkdownPreview
vim.keymap.set("n", "<leader>md", "<cmd>MarkdownPreview<CR>", opts)

-- Toggle line wrapping
vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts) -- Fixed this line (was "<gv")

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', opts)

-- Window management
vim.keymap.set("n", "<leader>v", "<C-w>v", opts) -- Split window vertically
vim.keymap.set("n", "<leader>h", "<C-w>s", opts) -- Split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", opts) -- Make split windows equal width & height
vim.keymap.set("n", "<leader>xs", ":close<CR>", opts) -- Close current split window

-- Navigate between splits
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)

-- Escape in insert mode
vim.keymap.set("i", "fd", "<Esc>")

-- LSP diagnostics
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { noremap = true, silent = true })

-- search by tags
vim.keymap.set('n', '<leader>ft', function()
  search_by_tags()
end, { desc = 'Find notes by YAML tags (fzf)' })

