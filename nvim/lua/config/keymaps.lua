local keymap = vim.keymap.set

-- Save
keymap("n", "<leader>w", "<cmd>w<CR>")

-- Quit
keymap("n", "<leader>q", "<cmd>q<CR>")

-- File Explorer
keymap("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")

-- Telescope
local builtin = require("telescope.builtin")

keymap("n", "<leader>ff", builtin.find_files, {})
keymap("n", "<leader>fg", builtin.live_grep, {})
keymap("n", "<leader>fb", builtin.buffers, {})
keymap("n", "<leader>fh", builtin.help_tags, {})
