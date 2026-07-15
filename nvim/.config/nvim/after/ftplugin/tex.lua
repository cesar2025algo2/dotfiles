-- ~/.config/nvim/lua/after/ftplugin/tex.lua

local opts = { buffer = true }

-- ============================================
-- KEYMAPS DE VIMTEX
-- ============================================

vim.keymap.set("n", "<leader>ll", ":VimtexCompile<CR>", {
	buffer = true,
	desc = "Compilar con VimTeX",
})

vim.keymap.set("n", "<leader>lv", ":VimtexView<CR>", {
	buffer = true,
	desc = "Ver PDF",
})

vim.keymap.set("n", "<leader>lk", ":VimtexStop<CR>", {
	buffer = true,
	desc = "Detener compilación",
})

vim.keymap.set("n", "<leader>le", ":VimtexErrors<CR>", {
	buffer = true,
	desc = "Ver errores",
})

vim.keymap.set("n", "<leader>lt", ":VimtexTocToggle<CR>", {
	buffer = true,
	desc = "Tabla de contenidos",
})

vim.keymap.set("n", "<leader>ls", ":VimtexStatus<CR>", {
	buffer = true,
	desc = "Estado de compilación",
})

vim.keymap.set("n", "<leader>lc", ":VimtexClean<CR>", {
	buffer = true,
	desc = "Limpiar archivos auxiliares",
})

-- ============================================
-- TUS KEYMAPS ORIGINALES
-- ============================================

vim.keymap.set("n", "<leader>cf", function()
	vim.cmd("write")
	-- Compila en la misma carpeta
	vim.cmd("!tectonic %")
	-- O compila en una carpeta específica
	-- vim.cmd("!tectonic --outdir 03_Attachments %")
end, {
	buffer = true,
	desc = "Guardar y compilar con Tectonic",
})

-- ============================================
-- KEYMAPS ADICIONALES PARA LATEX
-- ============================================

-- Entornos
vim.keymap.set("n", "<leader>ee", "o\\begin{equation}<CR>\\end{equation}<ESC>O", {
	buffer = true,
	desc = "Entorno equation",
})

vim.keymap.set("n", "<leader>ea", "o\\begin{align}<CR>\\end{align}<ESC>O", {
	buffer = true,
	desc = "Entorno align",
})

vim.keymap.set("n", "<leader>ei", "o\\begin{itemize}<CR>\\item <CR>\\end{itemize}<ESC>O", {
	buffer = true,
	desc = "Entorno itemize",
})

vim.keymap.set("n", "<leader>en", "o\\begin{enumerate}<CR>\\item <CR>\\end{enumerate}<ESC>O", {
	buffer = true,
	desc = "Entorno enumerate",
})

-- Formato de texto
vim.keymap.set("n", "<leader>tb", 'ciw\\textbf{<C-r>"}<ESC>', {
	buffer = true,
	desc = "Texto en negrita",
})

vim.keymap.set("n", "<leader>ti", 'ciw\\textit{<C-r>"}<ESC>', {
	buffer = true,
	desc = "Texto en cursiva",
})

-- ============================================
-- OPCIONES DE BUFFER
-- ============================================

-- Puedes agregar más configuraciones específicas para TeX aquí
-- Activar el corrector ortográfico solo en este búfer
vim.opt_local.foldmethod = "indent"
vim.opt_local.spell = true
-- Configurar el idioma en español
vim.opt_local.spelllang = "es"

-- (Opcional) Si escribís fórmulas matemáticas, esto ayuda a que wrap no rompa líneas a mitad de palabra
vim.opt_local.wrap = true
vim.opt_local.conceallevel = 2
