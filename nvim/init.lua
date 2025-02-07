-- Bootstrap lazy.nvim, LazyVim, and your plugins
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set number")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local plugins = {
    "catppuccin/nvim", name = "catppuccin", priority = 1000,
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    }
}
}

local opts = {}
require("lazy").setup(plugins, opts)

require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"

local config = require("nvim-treesitter.configs")
config.setup({
    ensure_installed = {"c", "lua", "python", "java", "vim", "html", "css", "javascript"},
    highlight = { enable = true },
    indent = { enable = true }
})

-- Telescope setup to search only in the current directory
require('telescope').setup{
  defaults = {
    -- Use fd or rg for dynamic searching, don't preload files
    find_command = {'fd', '--type', 'f', '--hidden', '--exclude', '.git'},  -- Using fd for dynamic search

    -- Ensure results start at the bottom (ascending order)
    sorting_strategy = "ascending", 

    prompt_position = "top", -- Keep prompt at the top
    layout_strategy = "horizontal",  -- Horizontal layout for search results
    layout_config = {
      width = 0.75, -- Controls width of the Telescope window
      preview_width = 0.5, -- Controls preview area width
    },
    
    -- Don't preload files, only search as you type
    file_ignore_patterns = {"node_modules", ".git", "dist"},

    -- Disable file preloading: Use a dynamic file search only when typing something
    -- Prevents searching when you first open the picker
    prompt_prefix = "Akim-> ",
    selection_caret = "=> ",
  },

  -- Custom picker setup for `find_files`
  pickers = {
    find_files = {
      -- Use fd dynamically for searching files
      find_command = {'fd', '--type', 'f', '--hidden', '--exclude', '.git'},
    },
  },

  extensions = {
    -- Add any other extensions here
  },
}


-- Keybinding to open `find_files` picker (can be customized)
vim.api.nvim_set_keymap('n', '<C-p>', ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>', {})
-- Focus on NeoTree (File Explorer) with Ctrl+h
vim.api.nvim_set_keymap('n', '<C-h>', ':Neotree toggle<CR>', { noremap = true, silent = true })

-- Focus on the next window with Ctrl+l
vim.api.nvim_set_keymap('n', '<C-l>', ':wincmd l<CR>', { noremap = true, silent = true })

-- Optional: If you want to move to the previous window (Ctrl+k), you can add this:
vim.api.nvim_set_keymap('n', '<C-k>', ':wincmd h<CR>', { noremap = true, silent = true })



-- Configuration for NeoTree with icons
require("neo-tree").setup({
  close_if_last_window = true,
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,
  default_component_configs = {
    icon = {
      folder_closed = "",  -- Icon for closed folders
      folder_open = "",    -- Icon for open folders
      default = "",        -- Default icon for files
    },
    modified = {
      symbol = "●",  -- Icon for modified files
    },
    git_status = {
      added = "",    -- Icon for added files
      modified = "", -- Icon for modified files
      deleted = "",  -- Icon for deleted files
      renamed = "➜",  -- Icon for renamed files
      untracked = "", -- Icon for untracked files
      ignored = "",  -- Icon for ignored files
      unstaged = "", -- Icon for unstaged files
      staged = "✓",   -- Icon for staged files
    },
  },
  filesystem = {
    filtered_items = {
      hide_dotfiles = false, -- Set to true to hide dotfiles
      hide_gitignored = true, -- Hide git-ignored files
    },
    follow_current_file = true, -- Follow the current file
    group_empty_dirs = true, -- Group empty directories together
  },
  window = {
    position = "left", -- Position the NeoTree window on the left
    width = 30, -- Set the width of the NeoTree window
    mappings = {
      ["o"] = "open", -- Mapping to open files/folders
      ["C"] = "close_node", -- Mapping to close a folder
    }
  },
})
