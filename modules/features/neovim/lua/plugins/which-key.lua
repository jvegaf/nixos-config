-- This file contains the configuration for the which-key.nvim plugin in Neovim.

return {
	-- Plugin: which-key.nvim
	-- URL: https://github.com/folke/which-key.nvim
	-- Description: A Neovim plugin that displays a popup with possible keybindings of the command you started typing.
	"folke/which-key.nvim",

	-- init = function()
	-- 	-- Set the timeout for key sequences
	-- 	vim.o.timeout = true
	-- 	vim.o.timeoutlen = 300 -- Set the timeout length to 300 milliseconds
	-- end,
	after = function()
		local wk = require("which-key")
		wk.setup({
			preset = "modern",
		})

		wk.add({
			{ "<leader>a", group = "AI" }, -- group
			{ "<leader>o", group = "OpenCode" }, -- group
			{ "<leader>op", group = "Prompts" }, -- group
			{ "<leader>k", group = "Sidekick [AI]" }, -- group
			{ "<localleader>g", group = "Gitsigns" }, -- group
		})
	end,
	keys = {
		{
			-- Keybinding to show which-key popup
			"<leader>?",
			function()
				require("which-key").show({ global = false }) -- Show the which-key popup for local keybindings
			end,
		},
	},
}
