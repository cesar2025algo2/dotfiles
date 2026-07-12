-- ~/.config/nvim/lua/plugins/live-preview.lua
return {
	"brianhuster/live-preview.nvim",
	dependencies = {
		"ibhagwan/fzf-lua",
	},
	opts = {
		browser = "qutebrowser", -- Especifica el navegador
		-- O si prefieres la ruta completa:
		-- browser = "/usr/bin/qutebrowser",
	},
}
