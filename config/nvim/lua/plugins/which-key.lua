-- Shows the available keys after a short pause (try <Space> and wait)
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		spec = {
			{ "<leader>f", group = "find" },
			{ "<leader>g", group = "git" },
			{ "<leader>s", group = "split" },
		},
	},
}
