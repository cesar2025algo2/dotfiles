-- ~/.config/nvim/after/ftplugin/python.lua
vim.keymap.set("n", "<leader>r", require("config.utils").run_code, {
	buffer = true,
	desc = "Ejecutar código Python",
})
