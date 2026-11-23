return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" }, -- Lazy-load when opening a file
	opts = {},
	config = function()
		vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#a7c080" }) -- Everforest Green
		vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#7fbbb3" }) -- Everforest Blue
		vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#e67e80" }) -- Everforest Red
	end,
}
