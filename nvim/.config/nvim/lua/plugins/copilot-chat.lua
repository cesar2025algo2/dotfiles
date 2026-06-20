-- ~/.config/nvim/lua/plugins/copilot-chat.lua
-- Al encenderse con `:CopilotChat` o `<leader>cc`, se habilita `:Copilot enable`, con el consiguiente aumento de 1G ram. luego puedes desabilitar Copilot (`:Copilot disable`), y con esto la ram disminuye y puedes seguir usando el chat.
return {
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = {
		{ "zbirenbaum/copilot.lua" },
		{ "nvim-lua/plenary.nvim" }, -- Dependencia para manejar archivos
	},
	cmd = "CopilotChat", -- Se carga solo cuando pones :CopilotChat
	keys = {
		{ "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat: Toggle" },
	},
	opts = {
		debug = false, -- No consume logs innecesarios
		-- mappings = {
		-- 	submit_prompt = {
		-- 		normal = "<CR>", -- En modo normal, Enter envía el prompt
		-- 		insert = "<C-s>", -- En modo inserto, Ctrl+s envía el prompt
		-- 	},
		-- },
	},
}
