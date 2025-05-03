require("config.lazy")
require("oil").setup()
require("config.options")
require("lazy").setup({
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{ "nvimtools/none-ls.nvim" },
})

-- Add this to your init.lua or another config file
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Buffer local mappings
		local opts = { buffer = ev.buf }

		-- Hover documentation with K
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

		-- Go to definition with gd
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

		-- Other useful mappings
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { noremap = true, silent = true })
	end,
})

require("lspconfig").pyright.setup({
	filetypes = { "python" }, -- Only attach to Python files
})

require("lspconfig").lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" }, -- Recognize 'vim' as a global
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true), -- Make server aware of Neovim runtime files
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
})
