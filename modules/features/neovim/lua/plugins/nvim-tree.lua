return {
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		version = "*",
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		keys = {
			{ "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree Toggle" },
			-- { "<leader>o", "<cmd>NvimTreeFocus<cr>",  desc = "NvimTree Focus" },
		},
		after = function()
			local api = require("nvim-tree.api")
			api.events.subscribe(api.events.Event.FileCreated, function(file)
				vim.cmd("edit " .. file.fname)
			end)

			local function my_on_attach(bufnr)
				local function edit_or_open()
					local node = api.tree.get_node_under_cursor()

					if node.nodes ~= nil then
						-- expand or collapse folder
						api.node.open.edit()
					else
						-- open file
						api.node.open.edit()
						-- Close the tree if file was opened
						api.tree.close()
					end
				end

				-- open as vsplit on current node
				local function vsplit_preview()
					local node = api.tree.get_node_under_cursor()

					if node.nodes ~= nil then
						-- expand or collapse folder
						api.node.open.edit()
					else
						-- open file as vsplit
						api.node.open.vertical()
					end

					-- Finally refocus on tree if it was lost
					api.tree.focus()
				end

				local function opts(desc)
					return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
				end

				api.config.mappings.default_on_attach(bufnr)

				vim.keymap.set("n", "l", edit_or_open, opts("Edit Or Open"))
				vim.keymap.set("n", "L", vsplit_preview, opts("Vsplit Preview"))
				vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Folder"))
				vim.keymap.set("n", "H", api.node.navigate.parent, opts("Parent"))
			end

			require("nvim-tree").setup({
				diagnostics = {
					enable = true,
					icons = {
						hint = "",
						info = "",
						warning = "",
						error = "",
					},
				},
				on_attach = my_on_attach,
				renderer = {
					group_empty = true,
					highlight_git = true,
					root_folder_modifier = ":~",
					icons = {
						glyphs = {
							git = {
								unstaged = "",
								staged = "",
								unmerged = "",
								renamed = "➜",
								untracked = "",
								deleted = "",
								ignored = "◌",
							},
						},
					},
				},
				-- update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file
				update_focused_file = {
					enable = true,
					update_root = true,
				},
				git = {
					timeout = 500,
				},
				actions = {
					open_file = {
						quit_on_open = true,
						resize_window = false,
					},
				},
				view = {
					width = 40,
					side = "left",
				},
				trash = {
					cmd = "trash",
					require_confirm = true,
				},
				tab = {
					sync = {
						open = true,
						close = true,
						ignore = {},
					},
				},
			})

			vim.api.nvim_create_autocmd("QuitPre", {
				callback = function()
					local invalid_win = {}
					local wins = vim.api.nvim_list_wins()
					for _, w in ipairs(wins) do
						local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
						if bufname:match("NvimTree_") ~= nil then
							table.insert(invalid_win, w)
						end
					end
					if #invalid_win == #wins - 1 then
						-- Should quit, so we close all invalid windows.
						for _, w in ipairs(invalid_win) do
							vim.api.nvim_win_close(w, true)
						end
					end
				end,
			})
		end,
	},
}
