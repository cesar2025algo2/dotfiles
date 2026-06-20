-- ~/.config/nvim/lua/config/utils.lua
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

-- funcion que genera wikilinks (util para hacer indices de wikilinks)
-- genera indice de wikilinks con anclas `#`
function M.generate_wikilink_toc()
	local bufnr = vim.api.nvim_get_current_buf()
	local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "markdown")
	if not ok then
		return
	end

	local tree = parser:parse()[1]
	local root = tree:root()

	local query = vim.treesitter.query.parse(
		"markdown",
		[[
        (atx_heading) @heading
    ]]
	)

	local toc = { "# Índice", "" }
	local has_headings = false

	for _, node, _ in query:iter_captures(root, bufnr) do
		local text = vim.treesitter.get_node_text(node, bufnr)

		-- Capturamos el nivel y el texto
		local symbols, title = text:match("^(#+)%s*(.-)%s*$") -- (.-) captura mínima para limpiar espacios finales

		if title and title ~= "" then
			has_headings = true
			local level = #symbols

			-- Ignoramos el H1 si es el título principal (opcional, si quieres incluirlo borra el 'if level > 1')
			if level > 0 then
				local indent = string.rep("  ", level - 1)
				-- Formato [[#Título]] para que sea un ancla interna
				table.insert(toc, indent .. "- [[#" .. title .. "]]")
			end
		end
	end

	if has_headings then
		vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, toc)
		vim.api.nvim_buf_set_lines(bufnr, #toc, #toc, false, { "" })
		print("Índice de Wikilinks generado con anclas (#).")
	end
end

-- -- genera indice de wikilinks sin anclas `#`
-- function M.generate_wikilink_toc()
-- 	local bufnr = vim.api.nvim_get_current_buf()
-- 	-- Intentamos obtener el parser de markdown
-- 	local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "markdown")
-- 	if not ok then
-- 		print("Treesitter para Markdown no instalado")
-- 		return
-- 	end
--
-- 	local tree = parser:parse()[1]
-- 	local root = tree:root()
--
-- 	-- Usamos una query más genérica que capture todo el encabezado
-- 	local query = vim.treesitter.query.parse(
-- 		"markdown",
-- 		[[
--         (atx_heading) @heading
--     ]]
-- 	)
--
-- 	local toc = { "# Índice", "" }
-- 	local has_headings = false
--
-- 	for _, node, _ in query:iter_captures(root, bufnr) do
-- 		local text = vim.treesitter.get_node_text(node, bufnr)
--
-- 		-- Extraemos el nivel (cuántos # hay)
-- 		local symbols, title = text:match("^(#+)%s*(.*)")
--
-- 		if title then
-- 			has_headings = true
-- 			local level = #symbols
-- 			-- Opcional: Indentación según el nivel (H1 -> sin indentar, H2 -> 2 espacios, etc.)
-- 			local indent = string.rep("  ", level - 1)
-- 			table.insert(toc, indent .. "- [[" .. title .. "]]")
-- 		end
-- 	end
--
-- 	if has_headings then
-- 		-- Inserta el índice al principio del archivo
-- 		vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, toc)
-- 		-- Añadir una línea en blanco extra al final del índice
-- 		vim.api.nvim_buf_set_lines(bufnr, #toc, #toc, false, { "" })
-- 		print("Índice de Wikilinks generado.")
-- 	else
-- 		print("No se encontraron encabezados.")
-- 	end
-- end

-- Crear una nota nueva automáticamente en 00_Inbox con Frontmatter
function M.new_note()
	-- 1. Pedir el título de la nota al usuario
	local titulo = vim.fn.input("Nombre de la nueva nota: ")
	if titulo == "" then
		print("\nCreación cancelada.")
		return
	end

	-- 2. Sanitizar el nombre del archivo
	local nombre_archivo = titulo:gsub("%s+", "-"):lower() .. ".md"

	-- --- VALIDACIÓN COMPACTA EN MÚLTIPLES CARPETAS ---
	-- Agrupamos las carpetas donde queremos buscar que no se repita
	local carpetas_vault = { "00_Inbox/", "01_Notes/", "02_Projects/" }
	local fs = vim.uv or vim.loop

	for _, carpeta in ipairs(carpetas_vault) do
		local ruta_chequeo = carpeta .. nombre_archivo
		if fs.fs_stat(ruta_chequeo) then
			-- Usamos string.format para que el mensaje te diga la carpeta exacta dinámicamente
			print(string.format("\n⚠️ ¡Error! Ya existe una nota con ese nombre en %s", carpeta))
			return
		end
	end

	local ruta_completa = "00_Inbox/" .. nombre_archivo
	-- 3. Generar el ID único basado en el tiempo actual (Ej: 202606191305)
	local id_timestamp = os.date("%Y%m%d%H%M")

	-- 4. Definir la plantilla del Frontmatter
	local template = {
		"---",
		"id: " .. id_timestamp,
		"aliases: []",
		"tags: []",
		"---",
		"# " .. titulo,
		"",
		"",
	}

	-- 6. Abrir el archivo en un buffer de Neovim
	vim.cmd("edit " .. ruta_completa)

	-- 7. Inyectar el template de forma segura
	vim.api.nvim_buf_set_lines(0, 0, -1, false, template)

	-- Mover el cursor al final del archivo para empezar a escribir derecho viejo
	vim.api.nvim_win_set_cursor(0, { #template, 0 })
end

return M
