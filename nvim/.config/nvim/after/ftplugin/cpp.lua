-- ~/.config/nvim/after/ftplugin/cpp.lua
vim.keymap.set("n", "<leader>r", require("config.utils").run_code, {
	buffer = true,
	desc = "Compilar y ejecutar C++",
})
