-- ~/.config/nvim/lua/plugins/navigation.lua
-- Seamless Ctrl-h/j/k/l movement between Neovim splits and tmux panes.
-- The matching tmux side lives in ~/.tmux.conf (is_vim smart switching).

return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<CR>",  desc = "Navigate left (split/pane)" },
      { "<C-j>", "<cmd>TmuxNavigateDown<CR>",  desc = "Navigate down (split/pane)" },
      { "<C-k>", "<cmd>TmuxNavigateUp<CR>",    desc = "Navigate up (split/pane)" },
      { "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Navigate right (split/pane)" },
    },
  },
}
