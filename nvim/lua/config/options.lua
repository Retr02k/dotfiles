vim.g.mapleader = " "            -- Sets the "leader key" (used for custom shortcuts) to Space

vim.opt.number = true            -- Shows absolute line numbers on the left
vim.opt.relativenumber = false   -- Disables relative line numbers

vim.opt.termguicolors = true     -- Enables 24-bit RGB colors (better themes/UI)

vim.opt.cursorline = true        -- Highlights the current line where the cursor is
vim.opt.signcolumn = "yes"       -- Always shows the sign column (prevents text shifting)


vim.opt.expandtab = false        -- Use real tabs instead of spaces
vim.opt.shiftwidth = 4           -- Number of spaces used for each indentation level
vim.opt.tabstop = 4              -- Number of spaces a tab character looks like
vim.opt.shiftround = true        -- Rounds indentation to nearest shiftwidth
vim.opt.smartindent = true       -- Automatically indents based on syntax/structure

vim.opt.mouse = "a"              -- Enables mouse support in all modes

vim.opt.clipboard = "unnamedplus" -- Uses system clipboard for copy/paste

vim.opt.ignorecase = true        -- Case-insensitive search
vim.opt.smartcase = true         -- Case-sensitive if uppercase letters are used in search

vim.opt.splitbelow = true        -- New horizontal splits open below current window
vim.opt.splitright = true        -- New vertical splits open to the right

vim.opt.scrolloff = 8            -- Keeps 8 lines visible above/below cursor when scrollinog

vim.opt.list = true
vim.opt.listchars = {
    space = "·",      -- spaces
    tab = "→ ",       -- tabs
    trail = "•",      -- trailing spaces
    extends = "❯",
    precedes = "❮",
    nbsp = "␣",
}
