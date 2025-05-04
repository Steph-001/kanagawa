-- In lua/plugins/conform.lua
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				c = { "clang-format" },
				-- other formatters...
			},
			-- Add this configuration for clang-format
			formatters = {
				clang_format = {
					prepend_args = { "--style={BreakBeforeBraces: Allman}" },
				},
			},
		})

		-- Format on save
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				require("conform").format({ bufnr = args.buf })
			end,
		})
	end,
}
