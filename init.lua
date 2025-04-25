require("config.lazy")
require("oil").setup()
require("config.options")
require("lazy").setup({
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    { "nvimtools/none-ls.nvim" },
})


