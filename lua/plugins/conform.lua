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
            formatters = {
                clang_format = {
                    -- Use the .clang-format file in the project directory
                    args = { "-style=file", "--fallback-style=Allman", "-" },
                },
            },
            -- Debug logging to see what's happening
            log_level = vim.log.levels.DEBUG,
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
