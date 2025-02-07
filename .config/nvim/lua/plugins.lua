return {
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  "nvim-tree/nvim-web-devicons",
  "nvim-tree/nvim-tree.lua",
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = { "lua", "python", "javascript", "html", "css", "go" },
        highlight = { enable = true },
        incremental_selection = { enable = true },
        indent = { enable = true },
        fold = { enable = true },
      }
    end
  },
  "displeased/conventional.vim",
}
