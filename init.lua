-- >>>>>>>>>>>>>>>>>>>> CONFIGURATION START <<<<<<<<<<<<<<<<<<<<<<<

-- First, load your custom options (vim.o, vim.g settings)
-- It's usually better to load options before plugins
require("config.options")

-- Now let's load the bootstrap part of lazy.nvim
-- This file should ONLY bootstrap lazy.nvim (install if not present)
-- It should NOT call lazy.setup() itself
require("config.lazy")

-- Now set up lazy.nvim with all your plugins
require("lazy").setup({
    -- == Plugin List ==
    -- Each item here is a plugin specification
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvimtools/none-ls.nvim" },
    "nvim-tree/nvim-web-devicons",
    
    -- Add oil.nvim with its setup configuration
    {
        "stevearc/oil.nvim",
        config = function()
            require("oil").setup()
        end,
    },
    
    -- == Lazy Options ==
    opts = {
        rocks = {
            enabled = false, -- Disable lazy's LuaRocks management
        }
        -- You could add other lazy.nvim options here if needed
        -- performance = { ... },
        -- ui = { ... },
    }
}) 

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

-- Markdown file template
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.md",
  callback = function()
    local title = vim.fn.expand("%:t:r")  -- filename without extension
    local date = os.date("%Y-%m-%d")
    local lines = {
      "---",
      'title: "' .. title:gsub("-", " ") .. '"',
      "date: " .. date,
      "tags: []",
      "---",
      "",
      "# " .. title:gsub("-", " "),
      ""
    }
    vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
  end,
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


-- Notes search with fzf-lua
vim.keymap.set('n', '<leader>fn', function()
  require('fzf-lua').live_grep({ 
    cwd = '/mnt/c/Users/steph/OneDrive - Région Île-de-France/notes'
  })
end, { desc = 'Search in notes' })
