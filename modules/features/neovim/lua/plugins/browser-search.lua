return {
	"jvegaf/browse.nvim",
	keys = {
		{ "<leader>ff", "<cmd>VisualSearch<cr>", mode = "v", desc = "Search on web" },
		{ "<leader>fb", "<cmd>VisualBookmarks<cr>", mode = "v", desc = "Search on web bookmarks" },
		{ "<leader>si", "<cmd>InputSearch<cr>", desc = "Search on web" },
	},
	after = function()
		-- code
		local bookmarks = {
			["github"] = {
				["name"] = "search github from neovim",
				["code_search"] = "https://github.com/search?q=%s&type=code",
				["repo_search"] = "https://github.com/search?q=%s&type=repositories",
				["issues_search"] = "https://github.com/search?q=%s&type=issues",
				["pulls_search"] = "https://github.com/search?q=%s&type=pullrequests",
			},
			["npm"] = "https://www.npmjs.com/search?q=%s",
			["pipy"] = "https://pypi.org/search/?q=%s",
			["stackoverflow"] = "https://stackoverflow.com/search?q=%s",
			["youtube"] = "https://www.youtube.com/results?search_query=%s&page=&utm_source=opensearch",
		}

		local browse = require("browse")

		local function command(name, rhs, opts)
			opts = opts or {}
			vim.api.nvim_create_user_command(name, rhs, opts)
		end

		command("InputSearch", function()
			browse.input_search()
		end, {})

		command("VisualSearch", function(input)
			browse.input_search(input)
		end, {})

		-- this will open telescope using dropdown theme with all the available options
		-- in which `browse.nvim` can be used
		command("Browse", function()
			browse.browse({ bookmarks = bookmarks })
		end)

		command("Bookmarks", function()
			browse.open_bookmarks({ bookmarks = bookmarks })
		end)

		command("VisualBookmarks", function(input)
			browse.open_bookmarks({ bookmarks = bookmarks, visual_text = input })
		end)

		command("DevdocsSearch", function()
			browse.devdocs.search()
		end)

		command("DevdocsFiletypeSearch", function()
			browse.devdocs.search_with_filetype()
		end)

		command("MdnSearch", function()
			browse.mdn.search()
		end)
	end,
}
