-- Leader: the key that starts custom shortcuts
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Line numbers and scrolling
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8

-- Indentation: tabs, displayed as 2 columns
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Interface
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true

-- Reload files changed outside nvim (for example, by an AI agent)
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	command = "checktime",
})

-- Keymaps
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "<leader>sv", "<cmd>Vexplore<CR>", { desc = "Split vertical (file explorer)" })
vim.keymap.set("n", "<leader>sh", "<cmd>Sexplore<CR>", { desc = "Split horizontal (file explorer)" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>?", function()
	vim.cmd.vsplit(vim.fn.stdpath("config") .. "/CHEATSHEET.md")
end, { desc = "Open cheatsheet" })

-- Files named .json that actually allow comments (JSONC)
vim.filetype.add({
	filename = {
		["cmux.json"] = "jsonc",
	},
})

-- Plugins: bootstrap lazy.nvim, then load every spec in lua/plugins/
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = { import = "plugins" },
	install = { colorscheme = { "kanagawa-wave" } },
	rocks = { enabled = false },
	change_detection = { notify = false },
})
