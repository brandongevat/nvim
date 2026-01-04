-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

return require('lazy').setup({
	{
		"3rd/image.nvim",
		build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
		opts = {
			processor = "magick_cli",
		}
	},

	{
		"iamcco/markdown-preview.nvim",
		ft = { "markdown" },
		build = function()
			-- First install yarn if needed
			if vim.fn.executable('yarn') == 0 then
				vim.fn.system('pnpm install -g yarn')
			end
			vim.fn.system('cd ~/.local/share/nvim/lazy/markdown-preview.nvim/app && yarn install')
		end,
		config = function()
			vim.g.mkdp_browser = 'firefox'
		end,
	},

	{
		"tpope/vim-fugitive",
	},

	{
		'ojroques/nvim-osc52',
		config = function()
			require('osc52').setup {
				max_length = 0,
				silent = false,
				trim = false,
				tmux_passthrough = false,
			}

			local function copy()
				if vim.v.event.operator == 'y' and vim.v.event.regname == '+' then
					require('osc52').copy_register('+')
				end
				if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
					require('osc52').copy_register('"')
				end
			end

			vim.api.nvim_create_autocmd('TextYankPost', {
				pattern = '*',
				callback = copy,
			})
		end
	},

	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		-- or                            , branch = '0.1.x',
		dependencies = { { 'nvim-lua/plenary.nvim' } }
	},

	{
		'rose-pine/neovim',
		as = 'rose-pine',
		config = function()
			vim.cmd('colorscheme rose-pine')
		end
	},

	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate'
	},

	{
		'nvim-treesitter/playground',
	},

	{
		'fatih/vim-go',
		config = function()
			vim.g.go_fmt_command = "gofmt"
			vim.cmd [[autocmd BufWritePre *.go :silent! lua vim.lsp.buf.formatting_sync()]]
		end
	},

	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		dependencies = {
			{ 'neovim/nvim-lspconfig' },
			{ 'williamboman/mason.nvim' },
			{ 'williamboman/mason-lspconfig.nvim' },

			{ 'hrsh7th/nvim-cmp' },
			{ 'hrsh7th/cmp-buffer' },
			{ 'hrsh7th/cmp-path' },
			{ 'saadparwaiz1/cmp_luasnip' },
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'hrsh7th/cmp-nvim-lua' },

			{ 'L3MON4D3/LuaSnip' },
			{ 'rafamadriz/friendly-snippets' },
		},

		config = function()
			local cmp = require('cmp')
			local cmp_lsp = require("cmp_nvim_lsp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				cmp_lsp.default_capabilities())

			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"rust_analyzer",
					"gopls",
					"clangd",
					"basedpyright",
					"dockerls",
					"docker_compose_language_service",
					"bashls",
					"ansiblels",
					"yamlls",
					"vtsls",
				},
				handlers = {


					function(server_name) -- default handler (optional)
						require("lspconfig")[server_name].setup {
							capabilities = capabilities
						}
					end,

					["lua_ls"] = function()
						local lspconfig = require("lspconfig")
						lspconfig.lua_ls.setup {
							capabilities = capabilities,
							settings = {
								Lua = {
									diagnostics = {
										globals = { "vim", "it", "describe", "before_each", "after_each" },
									}
								}
							}
						}
					end,

					["basedpyright"] = function()
						local lspconfig = require("lspconfig")
						lspconfig.basedpyright.setup {
							capabilities = capabilities
						}
					end,
				}
			})

			local cmp_select = { behavior = cmp.SelectBehavior.Select }

			cmp.setup({
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
					['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
					['<C-y>'] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
				}, {
					{ name = 'buffer' },
				})
			})

			vim.diagnostic.config({
				-- update_in_insert = true,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			})
		end
	}
})
