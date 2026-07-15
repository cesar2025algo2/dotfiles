-- lua/plugins/vimtex.lua
return {
	"lervag/vimtex",
	lazy = false, -- Cargar siempre para documentos .tex
	ft = { "tex", "latex" }, -- Cargar solo para estos tipos de archivo
	config = function()
		-- Configuración principal
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_compiler_method = "tectonic"
		vim.g.vimtex_snippet_engine = "luasnip"

		-- Configuración de tectonic
		vim.g.vimtex_compiler_latexmk = {
			executable = "tectonic",
			options = {
				"-X",
				"compile",
				"--keep-logs",
				"--keep-intermediates",
				"--synctex",
			},
		}

		-- Visor PDF
		vim.g.vimtex_view_general_viewer = "zathura"
		vim.g.vimtex_view_general_options = "--synctex-forward @line @col @pdf @tex"

		-- Quickfix y errores
		vim.g.vimtex_quickfix_mode = 2
		vim.g.vimtex_quickfix_open_on_warning = 0

		-- Syntax y completado
		vim.g.vimtex_syntax_conceal = {
			enables = 1,
			default = 1,
		}
		vim.g.vimtex_complete_enabled = 1
		vim.g.vimtex_complete_engine = "blink-cmp" -- O "nvim-cmp" si usas nvim-cmp

		-- Objetos de texto (para usar con d, c, y)
		vim.g.vimtex_text_obj_enabled = 1
	end,
}
