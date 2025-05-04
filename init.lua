-- >>>>>>>>>>>>>>>>>>>> CONFIGURATION START <<<<<<<<<<<<<<<<<<<<<<<

-- Load base lazy.nvim setup (likely installs lazy if not present)
require("config.lazy")

-- Setup for the oil.nvim plugin
require("oil").setup()

-- Load your custom options (vim.o, vim.g settings)
require("config.options")

-- Setup lazy.nvim to manage your plugins
require("lazy").setup({ -- Start of the single table argument for lazy.setup

    -- == Plugin List ==
    -- Each item here is a plugin specification
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvimtools/none-ls.nvim" },
    "nvim-tree/nvim-web-devicons", -- Added devicons, comma separates from next item

    -- == Lazy Options ==
    -- This 'opts' key is *inside* the main setup table, after the plugin list
    opts = {
        rocks = {
            enabled = false, -- Disable lazy's LuaRocks management
        }
        -- You could add other lazy.nvim options here if needed
        -- performance = { ... },
        -- ui = { ... },
    }

}) -- End of the single table argument for lazy.setup


-- == LSP Configuration ==

-- Autocommand group for LSP settings upon attaching to a buffer
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        -- Buffer local mappings (only active in the LSP-attached buffer)
        local opts = { buffer = ev.buf }

        -- Keybindings for LSP features
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)           -- Show hover documentation
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)     -- Go to definition
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts) -- Go to implementation
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- Rename symbol
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Show code actions
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { noremap = true, silent = true }) -- Show diagnostics float
    end,
})

-- Setup Python LSP (pyright)
require("lspconfig").pyright.setup({
    filetypes = { "python" }, -- Only attach to Python files
    -- Add other pyright settings here if needed
    -- settings = { ... }
})

-- Setup Lua LSP (lua_ls)
require("lspconfig").lua_ls.setup({
    settings = {
        Lua = {
            diagnostics = {
                -- Make lua_ls aware of Neovim globals like 'vim'
                globals = { "vim" },
            },
            workspace = {
                -- Make lua_ls aware of Neovim runtime files for better completion
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false, -- Improves performance in large projects
            },
            telemetry = {
                enable = false, -- Disable telemetry
            },
        },
    },
})

-- >>>>>>>>>>>>>>>>>>>> CONFIGURATION END <<<<<<<<<<<<<<<<<<<<<<<<<
