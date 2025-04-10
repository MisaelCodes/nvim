-- use meta accessors to use the nvim api with lua
-- it is available in github.com/nanotee/nvim-lua-guide
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.opt.number = true
vim.opt.relativenumber = true

vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})
-- looks for a path where the lazy.vim package manager is installed?
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- if not issue a git clone command to get the stable version of lazy
-- and put it in the lazypath variable
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
-- vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>cf", ":Neotree filesystem reveal right<CR>", {})
vim.keymap.set("n", "<leader>cfr", ":Neotree toggle position=right<CR>", {})
vim.keymap.set("n", "<leader>st", function()
	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 5)
end)
vim.keymap.set("t", "<C-X>", "<C-\\><C-n>:q<CR>", { noremap = true, silent = true })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
require("dapui").setup()
vim.keymap.set("n", "<leader>dk", function()
	require("dap").continue()
end)
-- vim.keymap.set(n, '<leader>dl', function() require('dap').run_last() end)
vim.keymap.set("n", "<leader>b", function()
	require("dap").toggle_breakpoint()
end)
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end
require("dap-go").setup({
	dap_configurations = {
		{
			type = "go",
			name = "Debug",
			request = "launch",
			program = "${file}",
			dlvFlags = { "--check-go-version=false" },
		},
	},
})
