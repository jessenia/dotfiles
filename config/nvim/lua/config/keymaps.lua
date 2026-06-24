-- ~/.config/nvim/lua/config/keymaps.lua

local keymap = vim.keymap.set

local opts = function(desc)
  return { noremap = true, silent = true, desc = desc }
end

-- Save / quit
keymap("n", "<leader>w", "<cmd>w<CR>", opts("Save file"))
keymap("n", "<leader>q", "<cmd>q<CR>", opts("Quit window"))
keymap("n", "<leader>Q", "<cmd>qa<CR>", opts("Quit all"))

-- Clear search highlight
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", opts("Clear search highlight"))

-- Better movement for wrapped lines
keymap("n", "j", "gj", opts("Move down visual line"))
keymap("n", "k", "gk", opts("Move up visual line"))

-- Move selected lines up/down
keymap("v", "J", ":m '>+1<CR>gv=gv", opts("Move selection down"))
keymap("v", "K", ":m '<-2<CR>gv=gv", opts("Move selection up"))

-- Keep cursor centered
keymap("n", "<C-d>", "<C-d>zz", opts("Half-page down centered"))
keymap("n", "<C-u>", "<C-u>zz", opts("Half-page up centered"))
keymap("n", "n", "nzzzv", opts("Next search result centered"))
keymap("n", "N", "Nzzzv", opts("Previous search result centered"))

-- Better paste
keymap("x", "<leader>p", [["_dP]], opts("Paste without replacing register"))

-- Clipboard
keymap({ "n", "v" }, "<leader>y", [["+y]], opts("Yank to system clipboard"))
keymap("n", "<leader>Y", [["+Y]], opts("Yank line to system clipboard"))

-- Delete without copying
keymap({ "n", "v" }, "<leader>d", [["_d]], opts("Delete without copying"))

-- Window navigation (<C-h/j/k/l>) is handled by vim-tmux-navigator
-- (see lua/plugins/navigation.lua) so it flows seamlessly into tmux panes.

-- Window resize
keymap("n", "<C-Up>", "<cmd>resize +2<CR>", opts("Increase window height"))
keymap("n", "<C-Down>", "<cmd>resize -2<CR>", opts("Decrease window height"))
keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts("Decrease window width"))
keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts("Increase window width"))

-- Buffers
keymap("n", "<leader>bn", "<cmd>bnext<CR>", opts("Next buffer"))
keymap("n", "<leader>bp", "<cmd>bprevious<CR>", opts("Previous buffer"))
keymap("n", "<leader>bd", "<cmd>bdelete<CR>", opts("Delete buffer"))

-- Splits
keymap("n", "<leader>sv", "<cmd>vsplit<CR>", opts("Vertical split"))
keymap("n", "<leader>sh", "<cmd>split<CR>", opts("Horizontal split"))
keymap("n", "<leader>se", "<C-w>=", opts("Equalize splits"))
keymap("n", "<leader>sx", "<cmd>close<CR>", opts("Close split"))

-- Terminal
keymap("n", "<leader>tt", "<cmd>terminal<CR>", opts("Open terminal"))
keymap("t", "<Esc>", [[<C-\><C-n>]], opts("Exit terminal mode"))

-- AI coding terminals
keymap("n", "<leader>tc", "<cmd>terminal claude<CR>", opts("Open Claude terminal"))
keymap("n", "<leader>tx", "<cmd>terminal codex<CR>", opts("Open Codex terminal"))
keymap("n", "<leader>tp", "<cmd>terminal pieces run<CR>", opts("Open Pieces terminal"))
