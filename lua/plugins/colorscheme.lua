return {
	'neanias/everforest-nvim',
	priority = 1000, -- Ensure it loads before other plugins
	lazy = false, -- Load during startup
	config = function()
		require('everforest').setup({
			-- Optional configuration: "hard", "medium" (default), or "soft"
			background = 'hard',
			transparent_background_level = 2,
		})
		vim.cmd.colorscheme('everforest')
	end,
	-- Configure LazyVim to use Everforest as the default colorscheme
}
