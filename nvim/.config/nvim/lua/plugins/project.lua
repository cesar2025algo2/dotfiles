-- ~/.config/nvim/lua/plugins/project.lua
return {
	"coffebar/neovim-project",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"Shatur/neovim-session-manager",
		"ibhagwan/fzf-lua", -- Especificamos que use fzf-lua
	},
	lazy = false,
	priority = 100,

	init = function()
		-- Esto es lo que pide el git para guardar estados de plugins
		vim.opt.sessionoptions:append("globals")
	end,

	opts = {
		projects = {
			"~/projects/*",
			"~/work/*",
			"~/estudio/*",
			"~/.config/nvim*", -- El asterisco agarra nvim y nvim-test4
			"~/uncuyo/*",
		},
		picker = {
			type = "fzf-lua",
		},
		-- Solo cargá la última sesión si vos querés
		last_session_on_startup = true,

		-- Evitá sesiones en lugares que no son proyectos
		session_manager_opts = {
			autosave_ignore_dirs = {
				vim.fn.expand("~"), -- No guardar sesión si estás en el home
				"/tmp",
			},
			autosave_ignore_filetypes = {
				"gitcommit",
				"gitrebase",
				"qf", -- Quickfix list
				"toggleterm",
			},
		},
	},

	keys = {
		{
			"<leader>fp",
			":NeovimProjectDiscover<CR>",
			desc = "Find Project",
		},
		{
			"<leader>fr",
			":NeovimProjectHistory<CR>",
			desc = "Recent Projects",
		},
	},
}
