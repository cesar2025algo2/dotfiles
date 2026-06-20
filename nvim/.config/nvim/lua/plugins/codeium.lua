-- ~/.config/nvim/lua/plugins/codeium.lua
-- Una vez instalado, abre nvim y ejecuta: :luafile ~/.config/nvim/lua/plugins/codeium.lua
-- Al entrar al estado enabled, en la barra de estado de nvim aparece un mensaje que dice for log codeium :Codeium Auth.
-- Luego aparece un cuadro para abrir el browser de autenticación donde puedes loggear y autorizar el uso de tu cuenta de github o de google.
-- te da un codigo de autorización que debes copiar y pegar en el cuadro de abajo.
-- si no aparece el cuadro de autorización, puedes escribir :Codeium Auth y te aparece el cuadro de autorización.
-- Elige la opcion que dice "tengo token" y copia el token y lo pega en el cuadro de abajo.
return {
	{
		"Exafunction/codeium.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp", -- solo si usás nvim-cmp
		},
		keys = {
			{
				"<leader>ci",
				function()
					require("codeium").enable()
				end,
				desc = "Enable Codeium",
			},
			{
				"<leader>ct",
				function()
					require("codeium").toggle()
				end,
				desc = "Toggle Codeium",
			},
		},

		log_level = "off", -- Ahorra ciclos de CPU del Celeron
		-- event = "InsertEnter",
		config = function()
			require("codeium").setup({

				virtual_text = {
					enabled = true, -- 👈 CLAVE: ghost text
				},
				-- configuración mínima
				enable_chat = false,
			})
		end,
	},
}
