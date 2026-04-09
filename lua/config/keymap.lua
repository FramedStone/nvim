vim.keymap.set('n', '<C-E>', '<cmd>Ex<CR>', { desc = 'file explorer' })
vim.keymap.set(
	'n',
	'<C-s>',
	':%s///gc | update <Home><Right><Right><Right>',
	{ desc = 'replace all strings within the file with confirmation' }
)
vim.keymap.set('x', 'p', '"_dP', { desc = "doesn't copy the pasted line" })
vim.keymap.set('n', '<leader>dh', '<cmd>nohl<CR>', { desc = 'remove highlight' })

-- fzf
vim.keymap.set('n', '<C-f>', function()
	require('fzf-lua').files()
end, { desc = 'Find files' })
vim.keymap.set('n', '<C-g>', function()
	require('fzf-lua').live_grep()
end, { desc = 'Live grep search' })

-- undotree
vim.keymap.set('n', '<leader>ut', "<cmd>lua require('undotree').toggle()<cr>")

-- harpoon
local harpoon = require('harpoon')

harpoon:setup()
vim.keymap.set('n', '<C-a>', function()
	harpoon:list():add()
end)
vim.keymap.set('n', '<C-h>', function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)

-- quickfix
vim.keymap.set('n', '<C-q>t', function()
	local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
	if qf_winid > 0 then
		vim.cmd('cclose')
	else
		vim.cmd('botright copen')
	end
end, { desc = 'Toggle Quickfix' })
vim.keymap.set('n', '<C-q>c', ':cexpr []<CR>', { desc = 'Clear Quickfix List' })
vim.keymap.set('n', '<C-q>j', ':cnext<CR>zz', { desc = 'Next Quickfix' })
vim.keymap.set('n', '<C-q>k', ':cprev<CR>zz', { desc = 'Prev Quickfix' })
-- vim.keymap.set('n', 'H', vim.lsp.buf.hover, { desc = 'Hover' })
vim.keymap.set(
	'n',
	'<C-q>d',
	':cdo s///gc | update <Home><Right><Right><Right><Right><Right><Right>',
	{ desc = 'QuickFix Do Change String with Confirmation' }
)
