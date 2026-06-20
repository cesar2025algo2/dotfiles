-- ~\.config/nvim/lua/plugins/render-markdown.lua
return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you use standalone mini plugins
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {
		render_modes = { "n", "c", "t", "v" },
		-- Esto asegura que use los colores de tu tema
		enabled = true,
		latex = {
			enabled = true,
			-- Esto es clave: intenta usar estos convertidores si están en el sistema
			converter = { "utftex", "latex2text" },
			highlight = "RenderMarkdownMath",
			-- Si no renderiza bien, suele ser por lo siguiente:
			-- 1. Falta el **parser de treesitter para `latex`**.
			-- 2. Faltan las **dependencias del sistema** para convertir LaTeX a Unicode (`latex2text` o `utftex`).
		},
		yaml = { enabled = true },
		file_types = { "markdown", "Avante" }, -- opcional pero explícito
	},
}
