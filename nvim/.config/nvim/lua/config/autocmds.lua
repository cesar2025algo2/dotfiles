-- ~/.config/nvim/lua/config/autocmds.lua

local autocmd = vim.api.nvim_create_autocmd

-- Resaltar texto al copiar (Yank)
autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch", -- El color que se va a ver
			timeout = 150, -- Cuánto dura el resaltado (ms)
		})
	end,
})

autocmd("BufWritePre", {
	desc = "Limpiar espacios en blanco al final de la línea",
	pattern = { "*.c", "*.cpp", "*.lua", "*.py", "*.sh", "*.tex" },
	callback = function()
		local save_cursor = vim.api.nvim_win_get_cursor(0)
		vim.cmd([[%s/\s\+$//e]])
		vim.api.nvim_win_set_cursor(0, save_cursor)
	end,
})
-- Autocomando para manejar enlaces inteligentes en Markdown con <Enter> sobre la ruta
-- Importante: si el link es de la forma [ver link](/ruta/al/link.pdf), entonces posicionarse sobre la ruta y luego dar enter
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.keymap.set("n", "<CR>", function()
			-- ... (captura del archivo bajo el cursor)
			local file = vim.fn.expand("<cfile>")

			-- Convertimos la ruta relativa (ej: ../02_Projects/archivo.tex)
			-- en una ruta absoluta real dentro de tu sistema de archivos (:p)
			local ruta_absoluta = vim.fn.fnamemodify(file, ":p")

			-- 1. Si son archivos que abrimos con aplicaciones externas
			if file:match("%.pdf$") or file:match("%.png$") then
				-- Le pasamos 'ruta_absoluta' a la app en vez de 'file'
				vim.fn.jobstart({ "zathura", ruta_absoluta }, { detach = true })
				return
			elseif file:match("^http") or file:match("^https") then
				if file:match("youtube%.com") or file:match("youtu%.be") then
					-- local url_limpia = file:gsub("[<>]", "")
					vim.fn.jobstart({ "mpv", file }, { detach = true })
					return
				end
				vim.fn.jobstart({ "qutebrowser", file }, { detach = true }) -- Las URLs quedan igual
				return
			elseif file:match("%.jpg$") or file:match("%.jpeg$") then
				vim.fn.jobstart({ "imv", ruta_absoluta }, { detach = true })
				return
			elseif file:match("%.mp4$") then
				vim.fn.jobstart({ "mpv", ruta_absoluta }, { detach = true })
				return
			elseif file:match("%.tex$") then --revisar pues muestra archivo vacio
				-- Usá "foot", "alacritty" o la terminal que tengas instalada
				vim.cmd("vsplit " .. file)
				-- vim.fn.jobstart({ "foot", "nvim", ruta_absoluta }, { detach = true })
				return
			elseif file:match("%.odt") then
				-- Ejecuta xdg-open de fondo sin congelar Neovim
				vim.fn.jobstart({ "xdg-open", file }, { detach = true })

				return
			end

			-- -- Captura la palabra/ruta que está bajo el cursor
			-- local file = vim.fn.expand("<cfile>")
			--
			-- -- 1. Si es un enlace web o un archivo binario (PDF, imágenes, videos)
			-- if
			-- 	file:match("%.pdf$") or file:match("%.png$") --or
			-- then
			-- 	vim.fn.jobstart({ "zathura", file }, { detach = true })
			-- 	return
			-- elseif file:match("^http") or file:match("^https") then
			-- 	vim.fn.jobstart({ "qutebrowser", file }, { detach = true })
			-- 	return
			-- elseif file:match("%.jpg$") or file:match("%.jpeg$") then
			-- 	vim.fn.jobstart({ "imv", file }, { detach = true })
			-- 	return
			-- elseif file:match("%.mp4$") then
			-- 	vim.fn.jobstart({ "mpv", file }, { detach = true })
			-- 	return
			-- elseif file:match("%.tex$") then
			-- 	vim.cmd("vsplit " .. file)
			-- 	-- vim.fn.jobstart({ "foot", "nvim", file }, { detach = true })
			-- 	return
			-- elseif file:match("%.odt") then
			-- 	-- Ejecuta xdg-open de fondo sin congelar Neovim
			-- 	vim.fn.jobstart({ "xdg-open", file }, { detach = true })
			--
			-- 	return
			-- end

			-- 2. Si es un Wikilink normal o texto, dejamos que Neovim actúe normal.
			-- Intentamos ejecutar la acción nativa de saltar al archivo (gf)
			-- Si falla (porque es texto común), simplemente actúa como un Enter normal.
			--
			-- 2. Si no fue un link externo ni multimedia, manejamos los Wikilinks o texto común

			-- Capturamos la línea actual y la posición del cursor para ver si estamos dentro de un [[Wikilink]]
			local linea_actual = vim.api.nvim_get_current_line()
			local col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- Base 1 para Lua

			-- Buscamos si el cursor está parado dentro de algo con [[ ]]
			-- Una forma simple es ver si el archivo capturado viene de un wikilink o si la línea contiene corchetes
			if file:match("^%[%[") or linea_actual:match("%[%[.-%]%]") then
				-- Ejecutamos la acción nativa de ir a definición del LSP (lo mismo que hace gd)
				local clientes_lsp = vim.lsp.get_clients({ bufnr = 0 })
				if #clientes_lsp > 0 then
					vim.lsp.buf.definition()
					return
				end
			end
			local status, _ = pcall(vim.cmd, "normal! gf")
			if not status then
				-- Si 'gf' da error porque no es una ruta, hacemos un Enter común (bajar de línea)
				return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "n", false)
			end
		end, { buffer = true, silent = true, desc = "Abrir enlace inteligente" })
	end,
})

-- Autocomando para compilar LaTeX con Tectonic mostrando su salida nativa
vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex",
	callback = function()
		vim.keymap.set("n", "<leader>cf", function()
			-- 1. Guardar cambios en el archivo .tex
			vim.cmd("write")

			local ruta_tex = vim.fn.expand("%:p")
			local carpeta_destino = "03_Attachments"

			-- 2. Ejecutar de forma síncrona para heredar la salida por defecto de la terminal
			-- Usamos :! para que Neovim dibuje el output crudo de la herramienta
			vim.cmd(string.format("!tectonic --outdir %s %s", carpeta_destino, vim.fn.shellescape(ruta_tex)))
		end, { buffer = true, silent = true, desc = "Compilar LaTeX con Tectonic nativo" })
	end,
})
