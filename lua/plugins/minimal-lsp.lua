return {
	-- Basic Mason setup
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	-- Mason LSP config bridge
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"pyright", -- Python
					"lua_ls", -- Lua
					"bashls", -- Bash
					"html", -- HTML
					"cssls", -- CSS
					"clangd", --C
				},
			})
		end,
	},
	-- Basic LSP config
	{
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
		config = function()
			-- Start with just one or two servers to test
			require("lspconfig").pyright.setup({})
			require("lspconfig").lua_ls.setup({})
		end,
	},
}
