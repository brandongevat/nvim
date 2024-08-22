vim.g.mapleader = " " -- Remaps the leader to space

-- Commands
vim.keymap.set("n", "<leader>s", ":w<CR>", { noremap = true, silent = true }) -- Maps the write command

-- Vim
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) -- Maps the explorer command

-- LSP 
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format) -- Maps the current LSP formatter
vim.keymap.set("n", "<leader>wa", vim.lsp.buf.code_action) -- Maps the current LSP code action 
