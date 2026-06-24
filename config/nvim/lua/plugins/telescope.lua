-- ~/.config/nvim/lua/plugins/telescope.lua

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local builtin = require("telescope.builtin")

      vim.keymap.set("n", "<leader>ff", builtin.find_files, {
        desc = "Find files",
      })

      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {
        desc = "Live grep",
      })

      vim.keymap.set("n", "<leader>fb", builtin.buffers, {
        desc = "Find buffers",
      })

      vim.keymap.set("n", "<leader>fh", builtin.help_tags, {
        desc = "Find help",
      })

      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, {
        desc = "Recent files",
      })

      vim.keymap.set("n", "<leader>fs", builtin.grep_string, {
        desc = "Search word under cursor",
      })
    end,
  },
}