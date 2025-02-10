vim.wo.number = true
vim.wo.relativenumber = true

-- Enable both number and relativenumber
vim.opt.number = true
vim.opt.relativenumber = true

-- Use absolute line numbers in insert mode
vim.api.nvim_create_augroup('numbertoggle', {})
vim.api.nvim_create_autocmd(
	{ 'BufEnter', 'FocusGained', 'InsertLeave' },
	{ pattern = '*', command = 'set relativenumber', group = 'numbertoggle' }
)
vim.api.nvim_create_autocmd(
	{ 'BufLeave', 'FocusLost', 'InsertEnter' },
	{ pattern = '*', command = 'set norelativenumber', group = 'numbertoggle' }
)
