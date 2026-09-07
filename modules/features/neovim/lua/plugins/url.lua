return {
	{
		"sontungexpt/url-open",
		cmd = "URLOpenUnderCursor",
		after = function()
			local status_ok, url_open = pcall(require, "url-open")
			if not status_ok then
				return
			end
			url_open.setup({})

			vim.keymap.set("n", "gx", "<esc>:URLOpenUnderCursor<cr>")
		end,
	},
	{
		"axieax/urlview.nvim",
		cmd = { "UrlView" },
		keys = {
			{ "<leader>bu", "<cmd>UrlView buffer<cr>", desc = "urlview: buffers" },
			{ "<leader>zu", "<cmd>UrlView lazy<cr>", desc = "urlview: lazy" },
			{
				"<leader>bU",
				"<cmd>UrlView buffer action=clipboard<cr>",
				desc = "urlview: copy links",
			},
		},
		opts = {
			default_title = "Links:",
			default_picker = "native",
			default_prefix = "https://",
			default_action = "system",
		},
	},
}
