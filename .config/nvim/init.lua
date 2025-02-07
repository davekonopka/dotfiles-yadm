-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("config.lazy")

vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true, silent = true })

-- empty setup using defaults
require("nvim-tree").setup()
