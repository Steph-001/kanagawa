return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            -- Current formatters
            lua = { "stylua" },
            python = { "isort", "black" },
            javascript = { "prettierd", "prettier", stop_after_first = true },
            sh = { "shfmt" },
            bash = { "shfmt" },
            
            -- Additional formatters
            go = { "gofmt" },
            html = { "prettier" },
            markdown = { "prettier" },
            css = { "prettier" },
            scss = { "prettier" },
            yaml = { "prettier" },
            json = { "prettier" },
            toml = { "taplo" },
            -- For TypeScript if you use it
            typescript = { "prettierd", "prettier", stop_after_first = true },
        },
        format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
        },
    },
}
