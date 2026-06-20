-- ~/.config/nvim/lua/plugins/copilot.lua
-- habilitar con `<leader>ce`, aumentará 1G ram. Luego de deshabilitar `<leader>ce`, ram disminuye 1G.
return {
	{
		"zbirenbaum/copilot.lua",
		-- Usamos cmd y keys para que NO se cargue al iniciar Neovim
		cmd = "Copilot",
		keys = {
			-- Al presionar cualquiera de estos, se cargará este plugin Y el de abajo
			{ "<leader>ce", "<cmd>Copilot enable<CR>", desc = "[c]opilot [e]nable" },
			{ "<leader>cd", "<cmd>Copilot disable<CR>", desc = "[c]opilot [d]isable" },
			{ "<leader>cs", "<cmd>Copilot status<CR>", desc = "[c]opilot [s]tatus" },
			{ "<leader>cp", "<cmd>Copilot panel<CR>", desc = "[c]opilot [p]anel" },
		},
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = true, -- Si vas a usar copilot-cmp, desactiva las sugerencias nativas para que no se solapen (ghost text vs menú de cmp)
					auto_trigger = true, -- CRÍTICO: No sugerir nada hasta que presiones un atajo
					hide_during_completion = true, -- Oculta el ghost text si el menú flotante está abierto
					keymap = {
						accept = "<M-l>", -- Alt + l para aceptar la sugerencia de ghost
						accept_word = false, -- aceptar solo la siguiente palabra (en lugar de toda la sugerencia)
						accept_line = false, -- aceptar solo la siguiente línea (en lugar de toda la sugerencia)
						next = "<M-]>", -- siguiente sugerencia (si hay varias)
						prev = "<M-[>", -- sugerencia anterior
						dismiss = "<C-]>", -- descartar la sugerencia actual
					},
				},
				panel = {
					enabled = false, -- si es true, entonces desconecta el panel de copilot-cmp o del provider en blink-cmp y desconecta el menú de cmp, mostrando las sugerencias en una ventana flotante (más parecido a la experiencia de github copilot). En ese caso puedes descomentar el codigo siguiente.
					-- auto_refresh = false, -- si querés que se actualice solo mientras escribís (puede consumir más)
					-- layout = {
					-- 	position = "bottom", -- "bottom", "right", "top", "left"
					-- 	ratio = 0.4, -- tamaño relativo de la ventana (40%)
					-- },
					-- keymap = {
					-- 	accept = "<CR>", -- aceptar la sugerencia donde esté el cursor (en lugar de la primera)
					-- 	jump_prev = "[[",
					-- 	jump_next = "]]",
					-- 	refresh = "gr",
					-- 	open = "<M-CR>", -- Alt + Enter
					-- 	. Comandos principales
					-- Una vez habilitado, puedes interactuar con él mediante comandos de Neovim:
					-- :Copilot panel: Abre la ventana con las sugerencias.
					-- En la ventana del panel:
					-- q: Cierra el panel.
					-- r: Refresca las sugerencias (útil si cambiaste el código y quieres ver opciones nuevas).
				},
				server_opts_override = { trace = "off" }, -- Esto ayuda un poco con el consumo de recursos en CPUs modestas
				-- Si quieres limitar a ciertos filetypes, descomenta este bloque y ajusta a tu gusto. De lo contrario, se activará en TODO (lo cual puede ser pesado en archivos grandes o con sintaxis compleja). gitcopilot detecta tu workspace y no se activa en repositorios sin código, y parece que esta activo en todos los archivos del workspace, incluso los que no son de código, pero no consume recursos en archivos sin código, así que no es un gran problema. De todas formas, si quieres limitarlo a ciertos filetypes, puedes hacerlo aquí.
				filetypes = {
					["*"] = false, -- Desactiva TODO por defecto
					python = true, -- Solo permite en lo que vos quieras
					lua = true,
					c = true,
					markdown = true,
					latex = true, -- Si usas archivos .tex directamente, activalo aquí
					tex = true, -- (A veces el filetype es 'tex' en lugar de 'latex')
					help = false, -- No sugerir en manuales de ayuda
					gitcommit = true, -- Opcional: a veces es mejor escribir tus propios mensajes de commit
					gitrebase = false,
					hgcommit = false,
					cvs = false,
					["."] = false, -- No activar en archivos sin extensión (evita carga innecesaria)
				},
			})

			-- En caso de que se cargue el plugin y se habilite Copilot desde que se abre el archivo, este codigo desactiva usando la API interna. De este modo, no aumenta 1G de ram!
			local ok, command = pcall(require, "copilot.command")
			if ok then
				command.disable()
			else
				vim.cmd("Copilot disable")
			end
		end,
	},
}
