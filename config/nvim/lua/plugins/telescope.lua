-- Fuzzy finder for files, text, buffers, help and more
local function builtin(name, opts)
	return function()
		require("telescope.builtin")[name](opts)
	end
end

return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = "Telescope",
	keys = {
		{
			"<C-p>",
			function()
				-- Files tracked by git; falls back to all files outside a repo
				if not pcall(require("telescope.builtin").git_files) then
					require("telescope.builtin").find_files()
				end
			end,
			desc = "Find git files",
		},
		{ "<leader>ff", builtin("find_files"), desc = "Find files" },
		{ "<leader>fg", builtin("live_grep"), desc = "Grep in project" },
		{ "<leader>fw", builtin("grep_string"), desc = "Grep word under cursor" },
		{ "<leader>fb", builtin("buffers"), desc = "Open buffers" },
		{ "<leader>fr", builtin("oldfiles"), desc = "Recent files" },
		{ "<leader>fh", builtin("help_tags"), desc = "Help pages" },
		{ "<leader>fk", builtin("keymaps"), desc = "Keymaps" },
		{ "<leader>fd", builtin("find_files", { cwd = "~/dotfiles" }), desc = "Dotfiles" },
		{ "<leader>/", builtin("current_buffer_fuzzy_find"), desc = "Search in current file" },
	},
	opts = function()
		local actions = require("telescope.actions")
		return {
			defaults = {
				file_ignore_patterns = { "%.git/" },
				mappings = {
					i = {
						["<Esc>"] = actions.close,
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
					},
				},
			},
			pickers = {
				find_files = { hidden = true },
			},
		}
	end,
}
