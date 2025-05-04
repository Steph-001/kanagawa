return {
	{
		"windwp/nvim-autopairs",
		lazy = false, -- Load the plugin immediately at startup
		priority = 50, -- Higher priority to load earlier
		config = function()
			require("nvim-autopairs").setup({
				disable_filetype = { "TelescopePrompt" },
				check_ts = true,
			})
		end,
	},
}
