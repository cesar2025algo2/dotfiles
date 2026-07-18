-- ~/.config/nvim/lua/config/utils.lua
-- Funciones de utilidad (NO dependen de plugins)
local M = {}

-- funcion que ejecuta el codigo actual en una ventana dedicada
M.run_code = function()
	vim.cmd("silent! write")

	-- Detectar tipo de archivo
	local filetype = vim.bo.filetype
	local filename = vim.fn.expand("%:p")
	local cmd = ""

	-- Lógica de detección
	if filetype == "python" then
		local venv_python = vim.fn.getcwd() .. "/.venv/bin/python"
		local python_exe = vim.fn.executable(venv_python) == 1 and venv_python or "python3"
		cmd = string.format("%s '%s'", python_exe, filename)
	elseif filetype == "c" then
		-- Compila y ejecuta: genera un binario temporal y lo corre
		local output = "/tmp/" .. vim.fn.expand("%:t:r")
		cmd = string.format("gcc '%s' -o %s && %s", filename, output, output)
	elseif filetype == "cpp" then
		-- Compilación C++ con estándar moderno y advertencias
		local output = "/tmp/" .. vim.fn.expand("%:t:r")
		cmd = string.format("g++ -O2 '%s' -o %s && %s", filename, output, output)
	elseif filetype == "java" then
		-- Java: Compila y luego ejecuta la Clase (asume que el archivo tiene el nombre de la clase)
		local class_name = vim.fn.expand("%:t:r")
		local dir = vim.fn.expand("%:p:h")
		-- Compila en el directorio actual y ejecuta
		cmd = string.format("javac '%s' && java -cp '%s' %s", filename, dir, class_name)
	else
		print("Lenguaje no configurado para ejecución automática.")
		return
	end

	-- Ejecución en ventana dedicada
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].buftype == "terminal" then
			vim.api.nvim_win_close(win, true)
		end
	end

	-- Abrimos el split abajo
	vim.cmd("botright 10split")

	-- Ejecutamos la terminal usando el comando de Neovim directamente
	-- Usamos 'term' seguido del comando. Esto NO está deprecated y es muy estable.
	local shell_cmd = cmd .. "; echo -e '\\n[Proceso terminado]'; read"

	-- Ejecutamos mediante la API de comandos para evitar conflictos de tipos
	vim.cmd("terminal " .. shell_cmd)

	-- 4. Entrar en modo inserto para que el 'read' capture el Enter
	vim.cmd("startinsert")
end

-- funcion que genera un preview pdf temporal usando pandoc y pdflatex, llamada desde keymaps.lua
function M.pandoc_pdf_preview()
	vim.cmd("silent write")

	local input = vim.fn.expand("%")
	local output = "/tmp/" .. vim.fn.expand("%:t:r") .. ".pdf"
	local cmd = string.format("pandoc %s -o %s --pdf-engine=pdflatex", input, output)

	local error_output = {}

	print("Compilando...")

	vim.fn.jobstart(cmd, {
		-- Capturamos los errores línea por línea
		on_stderr = function(_, data)
			if data then
				for _, line in ipairs(data) do
					if line ~= "" then
						table.insert(error_output, line)
					end
				end
			end
		end,
		on_exit = function(_, code)
			if code == 0 then
				vim.fn.jobstart("zathura " .. output, { detach = true })
				print("✔ PDF generado en " .. output)
			else
				print("✖ Error en la compilación")
				if #error_output > 0 then
					-- 1. Unimos TODO el error en un solo string largo
					local raw_error = table.concat(error_output, " ")

					-- 2. Limpieza agresiva de saltos de línea y espacios múltiples
					local clean_error = raw_error:gsub("%s+", " "):gsub("^%s+", "")

					vim.cmd("botright 10new")
					local buf = vim.api.nvim_get_current_buf()

					-- 3. Lo insertamos como UNA SOLA LÍNEA (metida en una tabla)
					vim.api.nvim_buf_set_lines(buf, 0, -1, false, { clean_error })

					-- 4. Forzamos el ajuste de línea (Wrap)
					vim.opt_local.wrap = true
					vim.opt_local.linebreak = true -- Corta por palabras, no por letras

					-- Estética
					vim.opt_local.buftype = "nofile"
					vim.opt_local.bufhidden = "wipe"
					vim.opt_local.swapfile = false
					vim.opt_local.filetype = "bash"
					vim.api.nvim_buf_set_name(buf, "Pandoc Errors")
					-- ... después de set_lines ...
					vim.opt_local.cursorline = true -- Resalta la línea para que no se te pierda la vista
					vim.opt_local.spell = false -- Desactiva el corrector ortográfico en los errores
					-- Color rosado/rojo de "Warning" real
					vim.cmd("highlight PandocErrorGuibg guibg=#2d1b22")
					vim.cmd("setlocal winhighlight=Normal:PandocErrorGuibg")

					-- Atajo para cerrar con 'q'
					vim.keymap.set("n", "q", ":q<CR>", { buffer = buf, silent = true })
				end
			end
		end,
	})
end

function M.new_zettel_note()
	local title = vim.fn.input("Título de la nota: ")
	if title == "" then
		print("\nCreación cancelada.")
		return
	end

	local date = os.date("%Y%m%d%H%M")
	local year = os.date("%Y")
	local slug = title:gsub("%s+", "-"):lower()
	local filename = string.format("./6_Zettelkasten/%s/%s-%s.md", year, date, slug)

	if vim.uv.fs_stat(filename) then
		print("\n⚠️ ¡Error! Ya existe una nota con ese título")
		return
	end

	-- USANDO [=[ ]=] PARA EVITAR PROBLEMAS CON [[ ]]
	local template = string.format(
		[=[
---
id: %s
title: %s
tags: []
fecha: %s
modificado: %s
tipo: permanente
---

# %s

## Contexto
> ¿Qué me llevó a escribir esto?

## Contenido
> Una idea atómica, clara y concisa


## Conexiones
- [[ ]] ← Notas relacionadas

## Fuentes
-

## Reflexión
> ¿Por qué es importante esta idea?
]=],
		date,
		title,
		os.date("%Y-%m-%d"),
		os.date("%Y-%m-%d %H:%M"), -- Inicialmente igual a la de creación
		title
	)

	vim.cmd("edit " .. filename)
	vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(template, "\n"))
	vim.cmd("normal /## Contenido\rj")
end

function M.new_inbox_note()
	local titulo = vim.fn.input("Nombre de la nueva nota: ")
	if titulo == "" then
		print("\nCreación cancelada.")
		return
	end

	local id_timestamp = os.date("%Y%m%d%H%M")

	-- Slug con guiones
	local slug = titulo:gsub("%s+", "-"):lower()
	local nombre_archivo = string.format("%s-%s.md", id_timestamp, slug)
	local ruta_completa = "~/uncuyo/0_Inbox/" .. nombre_archivo

	if vim.uv.fs_stat(ruta_completa) then
		print("\n⚠️ ¡Error! Ya existe una nota con ese nombre en 0_Inbox/")
		return
	end

	local template = {
		"---",
		"id: " .. id_timestamp,
		"aliases: []",
		"tags: [inbox]",
		"fecha: " .. os.date("%Y-%m-%d"),
		"modificado: " .. os.date("%Y-%m-%d %H:%M"), -- Inicialmente igual
		"---",
		"# " .. titulo,
		"",
		"## Contexto",
		"> ¿De dónde viene esta nota? (clase, lectura, idea propia)",
		"",
		"## Contenido",
		"",
		"",
		"## Conexiones",
		"- ",
		"",
		"## Acciones",
		"- [ ] Procesar esta nota",
		"- [ ] Mover a la carpeta correspondiente",
	}

	vim.cmd("edit " .. ruta_completa)
	vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
	vim.api.nvim_win_set_cursor(0, { #template, 0 })
end

-- Actualiza automáticamente el campo 'modificado' en el frontmatter de Markdown
function M.update_markdown_modified_date()
	local bufnr = vim.api.nvim_get_current_buf()

	-- Solo actuar si el buffer realmente fue modificado
	if not vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
		return
	end

	-- Leemos las primeras 20 líneas (suficiente para cualquier frontmatter estándar)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 20, false)
	local inside_frontmatter = false
	local updated = false
	local closing_yaml_line = nil

	local current_date = os.date("%Y-%m-%d %H:%M")

	for i, line in ipairs(lines) do
		if line == "---" then
			if not inside_frontmatter then
				inside_frontmatter = true
			else
				-- Encontramos el cierre del frontmatter
				closing_yaml_line = i
				break
			end
		elseif inside_frontmatter then
			-- Si el campo ya existe, lo actualizamos
			if line:match("^modificado%s*:") then
				lines[i] = "modificado: " .. current_date
				updated = true
				break
			end
		end
	end

	-- Si salimos del bucle y no se actualizó, pero encontramos el cierre del frontmatter (nota vieja)
	if not updated and closing_yaml_line then
		-- Insertamos el campo justo antes de la línea de cierre '---'
		table.insert(lines, closing_yaml_line, "modificado: " .. current_date)
		updated = true
	end

	-- Si hubo cambios, actualizamos el buffer manteniendo la posición del cursor
	if updated then
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_buf_set_lines(bufnr, 0, #lines, false, lines)
		-- Evitamos que el cursor tire error si por alguna razón la posición quedó fuera de rango
		pcall(vim.api.nvim_win_set_cursor, 0, cursor_pos)
	end
end

-- Abrir archivo usando la api de oil
function M.open_link()
	-- Obtener la palabra/enlace bajo el cursor de forma segura
	local file = vim.fn.expand("<cfile>")

	-- Verificar si es un directorio local válido
	if vim.fn.isdirectory(file) == 1 then
		-- Abrir el directorio usando la API de Oil
		require("oil").open(file)
	else
		-- Si no es un directorio (es un link web o un archivo),
		-- mantener el comportamiento nativo de Neovim/gx
		vim.cmd("normal! gx")
	end
end

-- ==============================================================================
-- FUNCIÓN PRIVADA HELPER (Acepta un argumento opcional)
-- ==============================================================================

--- Obtiene y sanitiza el texto a traducir
--- @param argument string? Texto enviado directamente desde un comando (opcional)
--- @return string|nil El texto a traducir, o nil si no se encontró nada válido
local function obtener_texto_traduccion(argument)
	-- 1. Si el usuario ya pasó un texto directo (ej: desde :Translate goal), lo usamos de una
	if argument and argument ~= "" then
		return argument
	end

	local query = ""
	local mode = vim.api.nvim_get_mode().mode

	if mode:match("[vV]") then
		-- Salimos del modo visual de manera segura para actualizar las marcas '< y '>
		local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
		vim.api.nvim_feedkeys(esc, "x", false)

		-- Obtenemos las marcas de inicio y fin de la selección
		local start_pos = vim.fn.getpos("'<")
		local end_pos = vim.fn.getpos("'>")

		-- Extraemos las líneas seleccionadas del buffer actual
		local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
		if #lines == 0 then
			return nil
		end

		-- Si es una selección parcial en una sola línea, recortamos los caracteres sobrantes
		if #lines == 1 then
			lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
		else
			lines[1] = string.sub(lines[1], start_pos[3])
			lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
		end

		-- Unimos y limpiamos el texto
		query = table.concat(lines, " ")
		query = query:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
	else
		-- Modo normal: palabra bajo el cursor
		query = vim.fn.expand("<cword>")
	end

	if not query or query == "" then
		vim.notify("No hay texto para traducir", vim.log.levels.WARN)
		return nil
	end

	return query
end

-- ==============================================================================
-- FUNCIONES PÚBLICAS (Se exportan para tus Keymaps)
-- ==============================================================================

--- Traduce usando un split vertical interactivo
function M.traducir(word)
	local query = obtener_texto_traduccion(word) -- <-- Le pasamos word al helper
	if not query then
		return
	end -- Si no hay texto, salimos (el helper ya tiró el aviso)

	-- 1. Abrimos el split vertical
	vim.cmd("vsplit")
	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(win, buf)

	-- 2. Ejecutamos el script
	local cmd = "enes " .. vim.fn.shellescape(query)
	vim.fn.termopen(cmd, {
		on_exit = function()
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
		end,
	})

	-- Atajos del buffer de traducción
	vim.keymap.set("t", "<Esc>", "<C-\\><C-n>:close<CR>", { buffer = buf, silent = true })

	-- Foco a la terminal interactiva de less
	vim.cmd("startinsert")
end

--- Traduce usando una ventana flotante interactiva
function M.traducir_flotante(word)
	local query = obtener_texto_traduccion(word) -- <-- Le pasamos word al helper
	if not query then
		return
	end

	-- 1. Crear el buffer de la flotante
	local buf = vim.api.nvim_create_buf(false, true)

	-- Dimensiones centradas
	local width = math.min(85, vim.o.columns - 10)
	local height = math.min(25, vim.o.lines - 6)
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	local opts = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
		title = " Traducción: " .. query .. " ",
		title_pos = "center",
	}

	-- 2. Abrir ventana flotante
	local win = vim.api.nvim_open_win(buf, true, opts)

	-- 3. Ejecutar el script
	local cmd = "enes " .. vim.fn.shellescape(query)
	vim.fn.termopen(cmd, {
		on_exit = function()
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
		end,
	})

	-- Atajos de emergencia para cerrar la flotante
	vim.keymap.set("t", "<Esc>", "<C-\\><C-n>:close<CR>", { buffer = buf, silent = true })

	-- Foco a la terminal interactiva de less
	vim.cmd("startinsert")
end

-- Configura el corrector ortográfico bilingüe y sus keymaps para el buffer actual
function M.setup_bilingual_spell()
	-- 1. Configuración básica del buffer actual
	vim.opt_local.spell = true
	vim.opt_local.spelllang = { "es", "en" }

	-- 2. Función interna para cambiar de idioma
	local function set_spell_lang(lang, label)
		vim.opt_local.spelllang = lang
		vim.cmd("redraw")
		vim.notify("Corrector: " .. label, vim.log.levels.INFO, { title = "Spellcheck" })
	end

	-- 3. Mapeos locales al buffer actual
	vim.keymap.set("n", "<leader>se", function()
		set_spell_lang("en_us", "English (en_us)")
	end, { buffer = true, desc = "Spell check English" })

	vim.keymap.set("n", "<leader>ss", function()
		set_spell_lang("es", "Spanish")
	end, { buffer = true, desc = "Spell check Spanish" })

	vim.keymap.set("n", "<leader>sb", function()
		set_spell_lang({ "es", "en" }, "Bilingual (es, en)")
	end, { buffer = true, desc = "Bilingual spell check" })
end

return M
