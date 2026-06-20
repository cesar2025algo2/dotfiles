return {
	"dhruvasagar/vim-table-mode",

	config = function()
		-- Configuración opcional
		vim.g.table_mode_corner = "+" -- Usa '+' para las esquinas (estilo Grid Table)

		-- Si quieres que se active automáticamente en archivos Markdown
		-- vim.api.nvim_create_autocmd('FileType', {
		--   pattern = 'markdown',
		--   command = 'TableModeEnable',
		-- })
	end,
}
