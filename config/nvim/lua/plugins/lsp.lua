-- ~/.config/nvim/lua/plugins/lsp.lua

return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "terraformls",
          "yamlls",
          "jsonls",
          "bashls",
        },
      })

      local lspconfig = require("lspconfig")

      local on_attach = function(_, bufnr)
        local keymap = vim.keymap.set

        local opts = function(desc)
          return {
            noremap = true,
            silent = true,
            buffer = bufnr,
            desc = desc,
          }
        end

        keymap("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
        keymap("n", "gr", vim.lsp.buf.references, opts("Go to references"))
        keymap("n", "K", vim.lsp.buf.hover, opts("Hover docs"))
        keymap("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename symbol"))
        keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))

        keymap("n", "<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, opts("Format buffer"))
      end

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                checkThirdParty = false,
              },
            },
          },
        },
        pyright = {},
        terraformls = {},
        yamlls = {},
        jsonls = {},
        bashls = {},
      }

      for server, server_config in pairs(servers) do
        server_config.on_attach = on_attach
        lspconfig[server].setup(server_config)
      end

      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, {
        noremap = true,
        silent = true,
        desc = "Show diagnostic",
      })

      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {
        noremap = true,
        silent = true,
        desc = "Previous diagnostic",
      })

      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {
        noremap = true,
        silent = true,
        desc = "Next diagnostic",
      })

      vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, {
        noremap = true,
        silent = true,
        desc = "Diagnostic list",
      })
    end,
  },
}
