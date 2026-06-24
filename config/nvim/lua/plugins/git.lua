-- ~/.config/nvim/lua/plugins/git.lua

return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()

      vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", {
        noremap = true,
        silent = true,
        desc = "Git blame line",
      })

      vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", {
        noremap = true,
        silent = true,
        desc = "Git preview hunk",
      })

      vim.keymap.set("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", {
        noremap = true,
        silent = true,
        desc = "Git reset hunk",
      })
    end,
  },
}
