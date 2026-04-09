-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
	local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
			{ out, 'WarningMsg' },
			{ '\nPress any key to exit...' },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = ';'

-- Setup lazy.nvim
require('lazy').setup({
	spec = {
		-- import your plugins
		{ import = 'plugins' },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { 'habamax' } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

vim.cmd([[autocmd FileType * set formatoptions-=ro]]) -- remove auto comment on new line
vim.opt.guicursor = 'a:block'
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true -- uses spaces instead of tabs
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.foldmethod = 'manual'
-- vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- conform.nvim
vim.api.nvim_create_autocmd('BufWritePre', {
	pattern = '*',
	callback = function(args)
		require('conform').format({ bufnr = args.buf })
	end,
})

-- make undo states persistent for undotree.nvim
-- Enable persistent undo
vim.opt.undofile = true
