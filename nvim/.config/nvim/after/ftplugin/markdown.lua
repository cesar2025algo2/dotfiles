-- ~/.config/nvim/after/ftplugin/markdown.lua

-- Función específica de Markdown (local, no exportada)
local function generate_wikilink_toc()
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

-- Keymap que usa la función
vim.keymap.set("n", "<leader>toc", generate_wikilink_toc, {
	buffer = true,
	desc = "Generar TOC de wikilinks",
})

-- 1. Keymap para abrir enlaces inteligentemente
vim.keymap.set("n", "<CR>", function()
	local file = vim.fn.expand("<cfile>")
	local ruta_absoluta = vim.fn.fnamemodify(file, ":p")

	-- Archivos PDF, imágenes, etc.
	if file:match("%.pdf$") then
		vim.fn.jobstart({ "zathura", ruta_absoluta }, { detach = true })
		return
	elseif file:match("%.png$") or file:match("%.jpg$") or file:match("%.jpeg$") then
		if file:match("%.png$") then
			vim.fn.jobstart({ "imv", ruta_absoluta }, { detach = true })
		else
			vim.fn.jobstart({ "imv", ruta_absoluta }, { detach = true })
		end
		return
	elseif file:match("^https?://") then
		if file:match("youtube%.com") or file:match("youtu%.be") then
			vim.fn.jobstart({ "mpv", file }, { detach = true })
		else
			vim.fn.jobstart({ "qutebrowser", file }, { detach = true })
		end
		return
	elseif file:match("%.mp4$") then
		vim.fn.jobstart({ "mpv", ruta_absoluta }, { detach = true })
		return
	elseif file:match("%.odt$") or file:match("%.docx$") then
		vim.fn.jobstart({ "xdg-open", ruta_absoluta }, { detach = true })
		return
	end

	-- Wikilinks y LSP
	local linea_actual = vim.api.nvim_get_current_line()
	if file:match("^%[%[") or linea_actual:match("%[%[.-%]%]") then
		local clientes_lsp = vim.lsp.get_clients({ bufnr = 0 })
		if #clientes_lsp > 0 then
			vim.lsp.buf.definition()
			return
		end
	end

	-- Fallback a gf o Enter normal
	local status, _ = pcall(vim.cmd, "normal! gf")
	if not status then
		return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "n", false)
	end
end, {
	buffer = true,
	silent = true,
	desc = "Abrir enlace inteligente",
})

-- Otras configuraciones específicas de Markdown
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.spell = true
vim.opt_local.spelllang = "es"
