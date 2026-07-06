-- ~/.config/nvim/lua/after/ftplugin/tex.lua
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

-- Puedes agregar más configuraciones específicas para TeX aquí
-- Activar el corrector ortográfico solo en este búfer
vim.opt_local.foldmethod = "indent"
vim.opt_local.spell = true
-- Configurar el idioma en español
vim.opt_local.spelllang = "es"

-- (Opcional) Si escribís fórmulas matemáticas, esto ayuda a que wrap no rompa líneas a mitad de palabra
vim.opt_local.wrap = true
