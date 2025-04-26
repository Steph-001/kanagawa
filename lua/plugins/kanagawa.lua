return {
    "rebelot/kanagawa.nvim",
    branch="master",
    config=function()
        -- Create a variable to track transparency state
        local transparency_enabled = true
        
        -- Function to toggle transparency
        _G.toggle_transparency = function()
            transparency_enabled = not transparency_enabled
            require('kanagawa').setup({
                transparent = transparency_enabled,
                overrides=function(colors)
                    return {
                        ["@markup.link.url.markdown_inline"] = { link = "Special" }, -- (url)
                        ["@markup.link.label.markdown_inline"] = { link = "WarningMsg" }, -- [label]
                        ["@markup.italic.markdown_inline"] = { link = "Exception" }, -- *italic*
                        ["@markup.raw.markdown_inline"] = { link = "String" }, -- `code`
                        ["@markup.list.markdown"] = { link = "Function" }, -- + list
                        ["@markup.quote.markdown"] = { link = "Error" }, -- > blockcode
                        ["@markup.list.checked.markdown"] = { link = "WarningMsg" } -- - [X] checked list item
                    }
                end
            })
            vim.cmd("colorscheme kanagawa")
            print("Transparency " .. (transparency_enabled and "enabled" or "disabled"))
        end
        
        -- Initial setup
        require('kanagawa').setup({
            transparent = transparency_enabled,
            overrides=function(colors)
                return {
                    ["@markup.link.url.markdown_inline"] = { link = "Special" }, -- (url)
                    ["@markup.link.label.markdown_inline"] = { link = "WarningMsg" }, -- [label]
                    ["@markup.italic.markdown_inline"] = { link = "Exception" }, -- *italic*
                    ["@markup.raw.markdown_inline"] = { link = "String" }, -- `code`
                    ["@markup.list.markdown"] = { link = "Function" }, -- + list
                    ["@markup.quote.markdown"] = { link = "Error" }, -- > blockcode
                    ["@markup.list.checked.markdown"] = { link = "WarningMsg" } -- - [X] checked list item
                }
            end
        })
        vim.cmd("colorscheme kanagawa")
    end,
}

