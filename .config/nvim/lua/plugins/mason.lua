-- Languages supported
local servers = {
  'ansiblels',                       -- Ansible
  'bashls',                          -- Bash
  'dockerls',                        -- Docker
  'docker_compose_language_service', -- Docker Compose
  'golangci_lint_ls',                -- Go (linting)
  'gopls',                           -- Go
  'html',                            -- HTML
  'helm_ls',                         -- Helm
  'biome',                           -- JavsScript, JSON, TypeScript
  'lua_ls',                          -- Lua
  'marksman',                        -- Markdown
  'pylsp',                           -- Python
  'terraformls',                     -- Terraform
  'tflint',                          -- Terraform
  'ts_ls',                           -- TypeScript
}

local overrides = {}

return {
  -- https://github.com/williamboman/mason.nvim
  { "williamboman/mason.nvim",       opts = {} },

  -- https://github.com/williamboman/mason-lspconfig.nvim
  {
    "williamboman/mason-lspconfig.nvim",
    opts = { ensure_installed = servers },
  },

  -- https://github.com/lukas-reineke/lsp-format.nvim
  { "lukas-reineke/lsp-format.nvim", opts = { sync = true } },

  -- https://github.com/neovim/nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {},
    config = function()
      local lspconfig = require("lspconfig")
      local lspformat = require("lsp-format")

      -- Capture default LSP capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

      -- Setup each LSP
      for _, server in ipairs(servers) do
        local opts = overrides[server] or {}
        opts = vim.tbl_deep_extend("force", opts, {
          capabilities = capabilities,
          on_attach = function(client)
            -- Ensure formatting is enabled
            if client.server_capabilities then
              client.server_capabilities.documentFormattingProvider = true
            end
            lspformat.on_attach(client)
          end,
        })
        lspconfig[server].setup(opts)
      end
    end,
  },
}
