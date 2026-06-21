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

-- crea wikilinks
vim.keymap.set("n", "<leader>wl", function()
	utils.generate_wikilink_toc()
end, { desc = "Generar TOC de Wikilinks" })

-- Crear una nota nueva automáticamente en 00_Inbox con Frontmatter (debe estar posicionado en vault)
vim.keymap.set("n", "<leader>nn", function()
	utils.new_note()
end, { desc = "New Note en 00_Inbox" })
