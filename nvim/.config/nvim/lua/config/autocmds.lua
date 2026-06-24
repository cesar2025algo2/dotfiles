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
				vim.fn.jobstart({ "foot", "nvim", ruta_absoluta }, { detach = true })
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
			local status, _ = pcall(vim.cmd, "normal! gf")
			if not status then
				-- Si 'gf' da error porque no es una ruta, hacemos un Enter común (bajar de línea)
				return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "n", false)
			end
		end, { buffer = true, silent = true, desc = "Abrir enlace inteligente" })
	end,
})
