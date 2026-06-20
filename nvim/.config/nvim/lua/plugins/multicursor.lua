-- ~/.config/nvim/lua/plugins/multicursor.lua
return {
	"mg979/vim-visual-multi",
	branch = "master",
	init = function()
		-- Desactivamos los mapeos que dan conflicto
		vim.g.VM_default_mappings = 0

		-- Ejemplo: Cambiar el color de los cursores para que resalten en tu terminal foot
		vim.g.VM_theme = "ocean"

		-- Configuramos solo los esenciales que sí funcionan bien
		vim.g.VM_maps = {
			["Find Under"] = "<C-n>",
			["Find Next"] = "<C-n>",
			["Select All"] = "<C-a>",
			["Start Regex Search"] = "<C-g>",
			["Add Cursor Up"] = "<C-Up>",
			["Add Cursor Down"] = "<C-Down>",
			["Cursor Left"] = "<S-Left>",
			["Cursor Right"] = "<S-Right>",
		}

		-- Opcional: Para que no te salte el mensaje de advertencia inicial
		vim.g.VM_show_warnings = 0
	end,
}
