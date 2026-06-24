-- ~/.config/nvim/lua/plugins/treesitter.lua

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- Pin to the master branch: the rewritten `main` branch removed the
    -- `nvim-treesitter.configs` module and the classic `.setup()` API used below.
    branch = "master",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "dockerfile",
          "go",
          "hcl",
          "json",
          "lua",
          "markdown",
          "python",
          "terraform",
          "toml",
          "vim",
          "vimdoc",
          "yaml",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
