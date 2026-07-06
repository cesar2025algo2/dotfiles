-- ~/.config/nvim/after/ftplugin/c.lua
vim.keymap.set("n", "<leader>r", require("config.utils").run_code, {
	buffer = true,
	desc = "Compilar y ejecutar C",
})
