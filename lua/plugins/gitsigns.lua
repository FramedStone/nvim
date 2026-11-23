return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" }, -- Lazy-load when opening a file
	opts = {
		signcolumn = false,
		numhl = true,
		linehl = false,
	},
}
