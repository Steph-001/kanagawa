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
    -- Use search_paths instead of cwd to specify multiple directories
    search_paths = {
      '/mnt/c/Users/steph/OneDrive - Région Île-de-France/notes',
      '~/personal',
      '~/dev-notes',
    }
  })
end, { desc = 'Search in all note folders' })


















-- Tag search with file preview for markdown notes with YAML front matter
-- Enhanced version with preview functionality similar to live_grep
-- FIXED: Updated to use current fzf-lua syntax for preview options

-- Function to extract YAML front matter from a markdown file
local function extract_front_matter(file_path)
  local file = io.open(file_path, "r")
  if not file then
    return nil
  end
  
  local content = file:read("*all")
  file:close()
  
  -- Check if file has YAML front matter (starts with ---)
  local front_matter_text = content:match("^%-%-%-\n(.-)\n%-%-%-\n")
  if not front_matter_text then
    -- Try alternative format with spaces after dashes
    front_matter_text = content:match("^%-%-%-%s*\n(.-)\n%-%-%-%s*\n")
    if not front_matter_text then
      return nil
    end
  end
  
  -- Parse the YAML front matter
  local metadata = {}
  for line in front_matter_text:gmatch("[^\r\n]+") do
    -- Skip empty lines
    if line:match("^%s*$") then
      goto continue
    end
    
    -- Extract key-value pairs
    local key, value = line:match("^%s*([^:]+):%s*(.*)$")
    if key and value then
      key = key:gsub("^%s+", ""):gsub("%s+$", "") -- Trim whitespace
      value = value:gsub("^%s+", ""):gsub("%s+$", "") -- Trim whitespace
      
      -- Handle array values [item1, item2, item3]
      if value:match("^%[.+%]$") then
        local items = {}
        for item in value:sub(2, -2):gmatch("[^,]+") do
          items[#items+1] = item:gsub("^%s+", ""):gsub("%s+$", "")
        end
        metadata[key] = items
      -- Handle quoted strings
      elseif value:match('^".*"$') or value:match("^'.*'$") then
        metadata[key] = value:sub(2, -2)
      else
        metadata[key] = value
      end
    end
    
    ::continue::
  end
  
  return metadata
end

-- Function to get tags from a file's front matter
local function get_tags_from_file(file_path)
  local metadata = extract_front_matter(file_path)
  if not metadata or not metadata.tags then
    return {}
  end
  
  local tags = metadata.tags
  -- If tags is a string, split it by commas
  if type(tags) == "string" then
    local result = {}
    for tag in tags:gmatch("[^,]+") do
      result[#result+1] = tag:gsub("^%s+", ""):gsub("%s+$", "")
    end
    return result
  end
  
  return tags
end

-- Function to find all markdown files in directories
local function find_markdown_files(directories)
  local files = {}
  
  for _, dir in ipairs(directories) do
    -- Expand the path to handle ~ for home directory
    local expanded_dir = vim.fn.expand(dir)
    
    -- Debug output to help troubleshoot
    vim.notify("Searching in: " .. expanded_dir, vim.log.levels.INFO)
    
    local handle
    -- Try using ripgrep first (faster)
    if vim.fn.executable('rg') == 1 then
      handle = io.popen('rg --files --glob "*.md" "' .. expanded_dir .. '" 2>/dev/null')
    else
      -- Fall back to find
      handle = io.popen('find "' .. expanded_dir .. '" -type f -name "*.md" 2>/dev/null')
    end
    
    if handle then
      local count = 0
      for file in handle:lines() do
        files[#files+1] = file
        count = count + 1
      end
      handle:close()
      
      -- Debug output to help troubleshoot
      vim.notify("Found " .. count .. " files in " .. expanded_dir, vim.log.levels.INFO)
    end
  end
  
  return files
end

-- Keymap for searching notes by tags with preview
vim.keymap.set('n', '<leader>ft', function()
  -- Define your notes directories
  local notes_dirs = {
    '/mnt/c/Users/steph/OneDrive - Région Île-de-France/notes',
    '~/dev-notes',
    '~/personal',
    -- Add more directories as needed
  }
  
  -- Find all markdown files
  local files = find_markdown_files(notes_dirs)
  
  -- Show a notification if no files were found
  if #files == 0 then
    vim.notify('No markdown files found in the specified directories', vim.log.levels.WARN)
    return
  end
  
  vim.notify('Processing ' .. #files .. ' markdown files...', vim.log.levels.INFO)
  
  -- Process files to extract tags
  local all_tags = {}
  local tag_to_files = {}
  local tag_count = {}
  
  for _, file_path in ipairs(files) do
    local tags = get_tags_from_file(file_path)
    for _, tag in ipairs(tags) do
      if not all_tags[tag] then
        all_tags[tag] = true
        tag_to_files[tag] = {}
        tag_count[tag] = 0
      end
      tag_to_files[tag][#tag_to_files[tag]+1] = file_path
      tag_count[tag] = tag_count[tag] + 1
    end
  end
  
  -- Convert tags table to list for fzf-lua with count information
  local tags_list = {}
  for tag, _ in pairs(all_tags) do
    tags_list[#tags_list+1] = string.format("%s (%d)", tag, tag_count[tag])
  end
  table.sort(tags_list)
  
  -- If no tags were found
  if #tags_list == 0 then
    vim.notify('No tags found in markdown files', vim.log.levels.WARN)
    return
  end
  
  -- Use fzf-lua to select a tag
  require('fzf-lua').fzf_exec(tags_list, {
    prompt = 'Tags> ',
    actions = {
      ['default'] = function(selected)
        -- Extract tag name without count
        local tag = selected[1]:match("^([^(]+)"):gsub("%s+$", "")
        local matching_files = tag_to_files[tag]
        
        -- Now show files that have this tag with preview
        require('fzf-lua').fzf_exec(matching_files, {
          prompt = 'Files with tag [' .. tag .. ']> ',
          -- Enable preview window with current syntax
          previewer = "builtin",
          winopts = {
            preview = {
              wrap = "nowrap",
              title = "File Preview",
              title_pos = "center"
            }
          },
          -- Add file icons and git status if available
          file_icons = true,
          git_icons = true,
          actions = {
            ['default'] = function(selected_file)
              vim.cmd('edit ' .. selected_file[1])
            end
          }
        })
      end
    }
  })
end, { desc = 'Search notes by tags with preview' })

-- Alternative implementation: Search for notes with specific tag directly (with preview)
vim.keymap.set('n', '<leader>fs', function()
  -- Prompt user for tag to search
  vim.ui.input({ prompt = 'Enter tag to search: ' }, function(tag)
    if not tag or tag == '' then return end
    
    -- Define your notes directories
    local notes_dirs = {
      '/mnt/c/Users/steph/OneDrive - Région Île-de-France/notes',
      '~/dev-notes',
      '~/personal',
      -- Add more directories as needed
    }
    
    -- Find all markdown files
    local files = find_markdown_files(notes_dirs)
    
    -- Find files with matching tag
    local matching_files = {}
    for _, file_path in ipairs(files) do
      local tags = get_tags_from_file(file_path)
      for _, t in ipairs(tags) do
        if t:lower() == tag:lower() then
          matching_files[#matching_files+1] = file_path
          break
        end
      end
    end
    
    -- Show matching files with fzf-lua and preview
    if #matching_files > 0 then
      require('fzf-lua').fzf_exec(matching_files, {
        prompt = 'Files with tag [' .. tag .. ']> ',
        -- Enable preview window with current syntax
        previewer = "builtin",
        winopts = {
          preview = {
            wrap = "nowrap",
            title = "File Preview",
            title_pos = "center"
          }
        },
        -- Add file icons and git status if available
        file_icons = true,
        git_icons = true,
        actions = {
          ['default'] = function(selected)
            vim.cmd('edit ' .. selected[1])
          end
        }
      })
    else
      vim.notify('No files found with tag: ' .. tag, vim.log.levels.WARN)
    end
  end)
end, { desc = 'Search for specific tag with preview' })



