-- ~/.config/nvim/lua/config/keymaps.lua

-- Limpiar búsqueda con Esc (quita el resaltado de la búsqueda)
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

-- Traducir en split vertical
vim.keymap.set("n", "<leader>tre", utils.traducir, { desc = "Traducir palabra (split)" })
vim.keymap.set("v", "<leader>tre", utils.traducir, { desc = "Traducir selección (split)" })

-- Traducir en ventana flotante
vim.keymap.set("n", "<leader>trf", utils.traducir_flotante, { desc = "Traducir palabra (flotante)" })
vim.keymap.set("v", "<leader>trf", utils.traducir_flotante, { desc = "Traducir selección (flotante)" })

-- Crear el comando :Translate para la línea de comandos de Neovim
vim.api.nvim_create_user_command("Translate", function(opts)
	-- Si el usuario pasó un argumento (ej: :Translate goal), se lo enviamos a la función
	if opts.args and opts.args ~= "" then
		utils.traducir_flotante(opts.args)
	else
		-- Si el usuario no pasó nada (ej: escribió solo :Translate),
		-- cae por defecto en la palabra bajo el cursor
		utils.traducir_flotante()
	end
end, {
	nargs = "?", -- Significa que el argumento es opcional
	desc = "Traducir una palabra o frase en una ventana flotante",
})
