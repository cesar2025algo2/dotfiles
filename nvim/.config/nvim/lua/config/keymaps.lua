-- ~/.config/nvim/lua/config/keymaps.lua

-- Limpiar búsqueda con Esc
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Navegación entre ventanas más fácil
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Mover a ventana izquierda" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Mover a ventana derecha" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Mover a ventana inferior" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Mover a ventana superior" })

-- Salir de insertar con 'jk' (más rápido que Esc)
vim.keymap.set("i", "jk", "<ESC>")

-- Usa Ctrl+d para insertar acentos (á, é, ñ) en modo inserto
-- Ahora, en modo inserto, hacés: `<C-d>` + `a` + `'` y debería salir la `á`.
vim.keymap.set("i", "<C-d>", "<C-k>", { noremap = true, desc = "Insertar Digraph (acentos)" })

-- Con esto, Esc te saca del modo interactivo de la terminal
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Modo Normal en Terminal" })

local utils = require("config.utils")

-- Atajo: <leader>r para ejecutar Python y otros, usando nuestra utilidad
-- Mapeo unificado para ejecutar tanto Python como C, C++ y otros
vim.keymap.set("n", "<leader>r", utils.run_code, { desc = "run" })

-- Compilar Markdown a PDF con Reporte de Errores
vim.keymap.set("n", "<leader>p", utils.pandoc_pdf_preview, { desc = "Pandoc PDF Preview" })

-- Crear una nota nueva automáticamente en 0_Inbox con Frontmatter (debe estar posicionado en vault)
vim.keymap.set("n", "<leader>nn", function()
	utils.new_inbox_note()
end, { desc = "New Note en 0_Inbox" })

-- Abrir el índice general del Vault al toque con <leader>vi (Vault Index)
vim.keymap.set("n", "<leader>gi", ":edit ~/uncuyo/README.md<CR>", { desc = "Abrir Inicio del Vault" })

-- Nueva nota Zettelkasten (NO usa fzf-lua)
vim.keymap.set("n", "<leader>zn", utils.new_zettel_note, { desc = "[Z]ettel [N]ueva nota" })

-- Interceptar la apertura de enlaces a directorios locales
vim.keymap.set("n", "gx", utils.open_link, { desc = "Abrir link (Directorios en Oil)" })

-- Abrir el índice general del Vault al toque con <leader>vi (Vault Index)
vim.keymap.set("n", "<leader>gx", ":edit ~/uncuyo/1_Recursos/LaTeX/latex-resume.md<CR>", { desc = "Open LaTeX resume" })

-- -- Interceptar la apertura de enlaces a directorios locales
-- vim.keymap.set("n", "gx", function()
-- 	-- Obtener la palabra/enlace bajo el cursor de forma segura
-- 	local file = vim.fn.expand("<cfile>")
--
-- 	-- Verificar si es un directorio local válido
-- 	if vim.fn.isdirectory(file) == 1 then
-- 		-- Abrir el directorio usando la API de Oil
-- 		require("oil").open(file)
-- 	else
-- 		-- Si no es un directorio (es un link web o un archivo),
-- 		-- mantener el comportamiento nativo de Neovim/gx
-- 		vim.cmd("normal! gx")
-- 	end
-- end, { desc = "Abrir link (Directorios en Oil)" })
--

-- Traducir palabra bajo el cursor (Modo Normal)
vim.keymap.set("n", "<leader>tre", function()
	utils.traducir()
end, { desc = "Traducir palabra bajo el cursor (split)" })

-- Traducir selección (Modo Visual)
vim.keymap.set("v", "<leader>tre", function()
	-- Salimos momentáneamente del modo visual para que se actualicen las marcas de selección
	vim.cmd("esc")
	utils.traducir()
end, { desc = "Traducir texto seleccionado (split)" })

-- Traducir bajo el cursor en ventana flotante (Modo Normal)
vim.keymap.set("n", "<leader>trf", function()
	utils.traducir_flotante()
end, { desc = "Traducir palabra (flotante)" })

-- Traducir selección en ventana flotante (Modo Visual)
vim.keymap.set("v", "<leader>trf", function()
	vim.cmd("esc") -- salir de modo visual para actualizar marcas
	utils.traducir_flotante()
end, { desc = "Traducir selección (flotante)" })
