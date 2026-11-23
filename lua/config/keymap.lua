vim.keymap.set("n", "<C-E>", "<cmd>Ex<CR>", { desc = "file explorer" })
vim.keymap.set(
	"n",
	"<C-s>",
	":%s///gc | update <Home><Right><Right><Right>",
	{ desc = "replace all strings within the file with confirmation" }
)
vim.keymap.set("x", "p", '"_dP', { desc = "doesn't copy the pasted line" })
vim.keymap.set("n", "<leader>dh", "<cmd>nohl<CR>", { desc = "remove highlight" })

-- fzf
vim.keymap.set("n", "<C-f>", function()
	require("fzf-lua").files()
end, { desc = "Find files" })
vim.keymap.set("n", "<C-g>", function()
	require("fzf-lua").live_grep()
end, { desc = "Live grep search" })

-- undotree
vim.keymap.set("n", "<leader>ut", "<cmd>lua require('undotree').toggle()<cr>")

-- harpoon
local harpoon = require("harpoon")

harpoon:setup()
vim.keymap.set("n", "<C-a>", function()
	harpoon:list():add()
end)
vim.keymap.set("n", "<C-h>", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)

-- quickfix
vim.keymap.set("n", "<C-q>t", function()
	local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
	if qf_winid > 0 then
		vim.cmd("cclose")
	else
		vim.cmd("botright copen")
	end
end, { desc = "Toggle Quickfix" })
vim.keymap.set("n", "<C-q>c", ":cexpr []<CR>", { desc = "Clear Quickfix List" })
-- vim.keymap.set('n', '<C-q>j', ':cnext<CR>zz', { desc = 'Next Quickfix' })
-- vim.keymap.set('n', '<C-q>k', ':cprev<CR>zz', { desc = 'Prev Quickfix' })
-- vim.keymap.set('n', 'H', vim.lsp.buf.hover, { desc = 'Hover' })
vim.keymap.set(
	"n",
	"<C-q>d",
	":cdo s///gc | update <Home><Right><Right><Right><Right><Right><Right>",
	{ desc = "QuickFix Do Change String with Confirmation" }
)
vim.keymap.set("n", "<C-q>d", vim.diagnostic.setqflist, { desc = "Add all diagnostic into Quickfix List" })

-- gitsigns
local gitsigns = require("gitsigns")

-- navigation
vim.keymap.set("n", "]h", function()
	if vim.wo.diff then
		vim.cmd.normal({ "]c", bang = true })
	else
		gitsigns.nav_hunk("next")
	end
end, { desc = "Next hunk" })
vim.keymap.set("n", "[h", function()
	if vim.wo.diff then
		vim.cmd.normal({ "[c", bang = true })
	else
		gitsigns.nav_hunk("prev")
	end
end, { desc = "Prev hunk" })

-- actions
local blame_windows = {} -- source window id -> blame window id

local function toggle_blame()
	local cur_buf = vim.api.nvim_get_current_buf()
	local cur_win = vim.api.nvim_get_current_win()

	-- cursor is inside a blame window: close it and go back to its source window
	if vim.bo[cur_buf].filetype == "gitsigns-blame" then
		for src_win, blame_win in pairs(blame_windows) do
			if blame_win == cur_win then
				blame_windows[src_win] = nil
				if vim.api.nvim_win_is_valid(src_win) then
					vim.api.nvim_set_current_win(src_win)
				end
				break
			end
		end
		vim.api.nvim_win_close(cur_win, true)
		return
	end

	-- blame window already open for this window: close it
	local blame_win = blame_windows[cur_win]
	if blame_win and vim.api.nvim_win_is_valid(blame_win) then
		blame_windows[cur_win] = nil
		vim.api.nvim_win_close(blame_win, true)
		return
	end

	-- remember blame windows that are already open
	local existing = {}
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "gitsigns-blame" then
			existing[win] = true
		end
	end

	gitsigns.blame()

	-- blame() is async: wait for its window to show up
	local new_blame_win
	vim.wait(2000, function()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
			if win ~= cur_win and not existing[win] and ft == "gitsigns-blame" then
				new_blame_win = win
				return true
			end
		end
		return false
	end, 10)

	if new_blame_win then
		blame_windows[cur_win] = new_blame_win
	end
end

vim.keymap.set("n", "<leader>hb", toggle_blame, { desc = "Toggle blame window" })
vim.keymap.set("n", "<leader>hQ", function()
	gitsigns.setqflist("all")
end, { desc = "Set all hunks into Quickfix List" })
vim.keymap.set("n", "<leader>hq", gitsigns.setqflist, { desc = "Set hunks into Quickfix List" })

-- select hunk
vim.keymap.set("x", "ih", gitsigns.select_hunk, { desc = "Select hunk" })
