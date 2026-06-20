-- ~/.config/nvim/lua/plugins/markdown-preview.lua
-- requiere `nodejs` y `npm`. `sudo pacman -S nodejs npm`
return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	-- El plugin solo se carga cuando presiones una de estas teclas
	keys = {
		{ "<leader>mp", "<cmd>MarkdownPreview<cr>", desc = "Markdown Preview Start" },
		{ "<leader>ms", "<cmd>MarkdownPreviewStop<cr>", desc = "Markdown Preview Stop" },
	},
	build = "cd app && npm install",
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end,
	ft = { "markdown" },
}
