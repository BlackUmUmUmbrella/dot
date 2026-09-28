--- References ---
-- https://github.com/lazyvim/lazyvim
-- https://github.com/nvchad/nvchad
-- https://github.com/astronvim/astronvim
-- https://github.com/nvim-lua/kickstart.nvim
-- https://github.com/ayamir/nvimdots

--- Options ---
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.cmdheight = 0
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.cursorline = true

--- Keybindings ---
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.keymap.set({ "i", "c" }, "jk", "<Esc>", { desc = "Back to normal mode" })
vim.keymap.set({ "n" }, "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set({ "n" }, "<C-j>", "<C-w>j", { desc = "Go to bottom window" })
vim.keymap.set({ "n" }, "<C-k>", "<C-w>k", { desc = "Go to top window" })
vim.keymap.set({ "n" }, "<C-l>", "<C-w>l", { desc = "Go to right window" })
vim.keymap.set({ "i" }, "<C-a>", "<Home>", { desc = "Go to line head" })
vim.keymap.set({ "i" }, "<C-e>", "<End>", { desc = "Go to line end" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

--- AutoCmd --
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("my_highlight_yank", { clear = true }),
	callback = function()
		if vim.fn.has("nvim-0.13") == 1 then
			vim.hl.hl_op()
		else
			(vim.hl or vim.highlight).on_yank({ timeout = 1000 })
		end
	end,
})
vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup("my_goto_last_loc", { clear = true }),
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
			return
		end
		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("my_close_with_q", { clear = true }),
	pattern = {
		"PlenaryTestPopup",
		"checkhealth",
		"dap-float",
		"dbout",
		"gitsigns-blame",
		"grug-far",
		"help",
		"lspinfo",
		"neotest-output",
		"neotest-output-panel",
		"neotest-summary",
		"notify",
		"qf",
		"spectre_panel",
		"startuptime",
		"tsplayground",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.schedule(function()
			vim.keymap.set("n", "q", function()
				vim.cmd("close")
				pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
			end, {
				buffer = event.buf,
				silent = true,
				desc = "Quit buffer",
			})
		end)
	end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = vim.api.nvim_create_augroup("my_fix_json_conceal", { clear = true }),
	pattern = { "json", "jsonc", "json5" },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = vim.api.nvim_create_augroup("my_auto_create_dir", { clear = true }),
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("my_disable_auto_comment", { clear = true }),
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
	desc = "Disable automatic comment leader on new line",
})
vim.api.nvim_create_autocmd("VimResized", {
	group = vim.api.nvim_create_augroup("my_resize_splits", { clear = true }),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
	desc = "Auto-resize splits when window is resized",
})
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("my_term_settings", { clear = true }),
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"
		vim.opt_local.spell = false
		vim.cmd("startinsert")
	end,
	desc = "Terminal window settings and auto-insert",
})
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("my_wrap_spell", { clear = true }),
	pattern = { "gitcommit", "markdown", "text", "plaintex" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
	desc = "Enable wrap and spell check for prose",
})
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
	group = vim.api.nvim_create_augroup("my_auto_cursorline", { clear = true }),
	callback = function()
		if vim.bo.buftype == "" then
			vim.opt_local.cursorline = true
		end
	end,
	desc = "Enable cursorline in active window",
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
	group = vim.api.nvim_create_augroup("my_auto_cursorline", { clear = true }),
	callback = function()
		vim.opt_local.cursorline = false
	end,
	desc = "Disable cursorline in inactive window",
})
vim.api.nvim_create_autocmd("BufReadPre", {
	group = vim.api.nvim_create_augroup("my_big_file_protect", { clear = true }),
	callback = function(event)
		local max_size = 2 * 1024 * 1024
		local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(event.buf))
		if ok and stats and stats.size > max_size then
			vim.b[event.buf].bigfile = true
			vim.opt_local.swapfile = false
			vim.opt_local.foldmethod = "manual"
			vim.opt_local.undolevels = -1
			vim.cmd("syntax off")
		end
	end,
	desc = "Disable heavy features on large files",
})

--- Packages ---
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local profile = vim.env.NVIM_PROFILE or "lazyvim"
vim.g.profile = profile
local specs = {}
if vim.g.profile == "lazyvim" then
	specs = {
		{
			"LazyVim/LazyVim",
			opts = { colorscheme = "tokyonight-night" },
		},
		{ import = "lazyvim.plugins" },
		{ import = "lazyvim.plugins.extras.editor.illuminate" },
		{ import = "lazyvim.plugins.extras.editor.navic" },
		{ import = "lazyvim.plugins.extras.editor.overseer" },
		{ import = "lazyvim.plugins.extras.editor.refactoring" },
		{ import = "lazyvim.plugins.extras.lang.json" },
		{ import = "lazyvim.plugins.extras.lang.python" },
		{ import = "lazyvim.plugins.extras.lang.toml" },
		{ import = "lazyvim.plugins.extras.lang.yaml" },
		{ import = "lazyvim.plugins.extras.lsp.none-ls" },
		{ import = "lazyvim.plugins.extras.ui.treesitter-context" },
		{
			"folke/snacks.nvim",
			opts = {
				scroll = {
					enabled = false,
				},
			},
		},
		{
			"saghen/blink.cmp",
			opts = {
				completion = {
					menu = {
						border = "rounded",
						winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
					},
					documentation = {
						window = {
							border = "rounded",
						},
					},
				},
			},
		},
	}
end

if vim.g.profile == "astro" then
	specs = {
		{
			"AstroNvim/AstroNvim",
			version = "^6",
			import = "astronvim.plugins",
		},
		{ "AstroNvim/astrocommunity" },
		{ import = "astrocommunity.bars-and-lines.vim-illuminate" },
		{ import = "astrocommunity.code-runner.overseer-nvim" },
		{ import = "astrocommunity.color.modes-nvim" },
		{ import = "astrocommunity.color.nvim-highlight-colors" },
		{ import = "astrocommunity.diagnostics.trouble-nvim" },
		{ import = "astrocommunity.editing-support.nvim-treesitter-context" },
		{ import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
		{ import = "astrocommunity.editing-support.todo-comments-nvim" },
		{ import = "astrocommunity.indent.snacks-indent-hlchunk" },
		{ import = "astrocommunity.pack.json" },
		{ import = "astrocommunity.pack.python" },
		{ import = "astrocommunity.pack.toml" },
		{ import = "astrocommunity.pack.yaml" },
		{ import = "astrocommunity.programming-language-support.csv-vim" },
	}
end

if vim.g.profile == "nvchad" then
	vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
	specs = {
		{
			"NvChad/NvChad",
			lazy = false,
			branch = "v2.5",
			import = "nvchad.plugins",
			config = function()
				local ok, err = pcall(function()
					dofile(vim.g.base46_cache .. "defaults")
					dofile(vim.g.base46_cache .. "statusline")
				end)
				if not ok then
					vim.notify(err, vim.log.levels.ERROR)
				end
				require("nvchad.options")
				require("nvchad.autocmds")
				vim.schedule(function()
					require("nvchad.mappings")
				end)
			end,
		},
	}
end

if vim.g.profile == "mini" then
	specs = {
		{
			"nvim-mini/mini.nvim",
			version = "*",
			config = function()
				vim.cmd.colorscheme("miniwinter")
				require("mini.basics").setup()
				require("mini.icons").setup({
					style = "glyph",
				})
				require("mini.statusline").setup()
				require("mini.tabline").setup()
				require("mini.indentscope").setup({})
				require("mini.cursorword").setup({
					delay = 200,
				})
				require("mini.files").setup({
					windows = {
						preview = true,
						width_focus = 30,
						width_preview = 50,
					},
				})
				vim.keymap.set("n", "<leader>e", function()
					local MiniFiles = require("mini.files")
					if not MiniFiles.close() then
						MiniFiles.open(vim.api.nvim_buf_get_name(0), true)
					end
				end, { desc = "Open MiniFiles (current file)" })
				vim.keymap.set("n", "<leader>E", function()
					local MiniFiles = require("mini.files")
					if not MiniFiles.close() then
						MiniFiles.open()
					end
				end, { desc = "Open MiniFiles (cwd)" })
				require("mini.pick").setup({
					window = {
						config = function()
							local height = math.floor(0.4 * vim.o.lines)
							local width = math.floor(0.75 * vim.o.columns)
							return {
								anchor = "NW",
								height = height,
								width = width,
								col = math.floor((vim.o.columns - width) / 2),
								row = math.max(0, vim.o.lines - height - vim.o.cmdheight - 2),
								border = "rounded",
							}
						end,
					},
					options = {
						content_from_bottom = true,
					},
				})
				vim.keymap.set("n", "<leader>ff", "<Cmd>Pick files<CR>", { desc = "Find Files" })
				vim.keymap.set("n", "<leader>fb", "<Cmd>Pick buffers<CR>", { desc = "Find Buffers" })
				vim.keymap.set("n", "<leader>fw", "<Cmd>Pick grep_live<CR>", { desc = "Find Words" })
				require("mini.pairs").setup()
				require("mini.clue").setup({
					triggers = {
						{ mode = { "n", "x" }, keys = "<Leader>" },
						{ mode = "n", keys = "[" },
						{ mode = "n", keys = "]" },
						{ mode = "i", keys = "<C-x>" },
						{ mode = { "n", "x" }, keys = "g" },
						{ mode = { "n", "x" }, keys = "'" },
						{ mode = { "n", "x" }, keys = "`" },
						{ mode = { "n", "x" }, keys = '"' },
						{ mode = { "i", "c" }, keys = "<C-r>" },
						{ mode = "n", keys = "<C-w>" },
						{ mode = { "n", "x" }, keys = "z" },
					},
					clues = {
						require("mini.clue").gen_clues.square_brackets(),
						require("mini.clue").gen_clues.builtin_completion(),
						require("mini.clue").gen_clues.g(),
						require("mini.clue").gen_clues.marks(),
						require("mini.clue").gen_clues.registers(),
						require("mini.clue").gen_clues.windows(),
						require("mini.clue").gen_clues.z(),
					},
					window = {
						config = {},
						delay = 300,
						scroll_down = "<C-d>",
						scroll_up = "<C-u>",
					},
				})
			end,
		},
	}
end

require("lazy").setup({
	spec = specs,
	ui = {
		size = {
			width = 0.92,
			height = 0.92,
		},
		border = "rounded",
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"health",
				"man",
				"matchit",
				"matchparen",
				"netrw",
				"netrwFileHandlers",
				"netrwPlugin",
				"rplugin",
				"shada",
				"spellfile",
				"tarPlugin",
				"tutor",
				"tohtml",
				"zipPlugin",
			},
		},
	},
})
