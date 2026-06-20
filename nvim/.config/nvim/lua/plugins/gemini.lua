-- ~/.config/nvim/lua/plugins/gemini.lua
return {
	{
		"supermaven-inc/supermaven-nvim",
		keys = {
			{ "<leader>md", "<cmd>SupermavenStop<cr>", desc = "Supermaven: Desactivar" },
			{ "<leader>me", "<cmd>SupermavenStart<cr>", desc = "Supermaven: Activar" },
			{ "<leader>mt", "<cmd>SupermavenToggle<cr>", desc = "Supermaven: Toggle (On/Off)" },
		},
		opts = {
			keymaps = {
				accept_suggestion = "<M-l>",
				clear_suggestion = "<C-]>",
				next_suggestion = "<C-j>",
				previous_suggestion = "<C-k>",
				select_suggestion = "<CR>",
			},
			log_level = "off", -- Ahorra ciclos de CPU del Celeron
		},
		config = function(_, opts)
			require("supermaven-nvim").setup(opts)
			-- Forzamos el uso de la versión gratuita al cargar el plugin
			vim.api.nvim_create_autocmd("User", {
				pattern = "SupermavenStarted",
				callback = function()
					vim.cmd("SupermavenUseFree")
				end,
			})
		end,
	},
}
