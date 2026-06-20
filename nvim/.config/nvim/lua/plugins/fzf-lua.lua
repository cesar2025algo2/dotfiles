-- ~/.config/nvim/lua/plugins/fzf-lua.lua
return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	-- dependencies = { "nvim-tree/nvim-web-devicons" },
	-- or if using mini.icons/mini.nvim
	dependencies = { "echasnovski/mini.icons" },
	opts = {},
	keys = {
		{
			"<leader>ff",
			function()
				require("fzf-lua").files()
			end,
			desc = "[f]ind [f]iles in project directory",
		},
		{
			"<leader>fg",
			function()
				require("fzf-lua").live_grep()
			end,
			desc = "[f]ind by [g]repping in project directory",
		},
		{
			"<leader>fc",
			function()
				require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "[f]ind in neovim [c]onfiguration",
		},
		{
			"<leader>fh",
			function()
				require("fzf-lua").helptags()
			end,
			desc = "[f]ind [h]elp",
		},
		{
			"<leader>fk",
			function()
				require("fzf-lua").keymaps()
			end,
			desc = "[f]ind [k]eymaps",
		},
		{
			"<leader>fb",
			function()
				require("fzf-lua").builtin()
			end,
			desc = "[f]ind [b]uiltin FZF",
		},
		{ -- busca la palabra simple
			"<leader>fw",
			function()
				require("fzf-lua").grep_cword()
			end,
			desc = "[f]ind current [w]ord",
		},
		{ -- busca la palabra incluyendo símbolos especiales
			"<leader>fW",
			function()
				require("fzf-lua").grep_cWORD()
			end,
			desc = "[f]ind current [W]ORD",
		},
		{
			"<leader>fd",
			function()
				require("fzf-lua").diagnostics_document()
			end,
			desc = "[f]ind [d]iagnostics",
		},
		{
			"<leader>fr",
			function()
				require("fzf-lua").resume()
			end,
			desc = "[f]ind [r]esume",
		},
		{
			"<leader>fo",
			function()
				require("fzf-lua").oldfiles()
			end,
			desc = "[f]ind [o]ld Files",
		},
		{
			"<leader>fa",
			function()
				require("fzf-lua").lsp_references()
			end,
			desc = "find lsp_references",
		},
		{ -- Si tienes muchos archivos abiertos, este comando te permite saltar entre ellos. Es mucho más rápido que usar pestañas.
			"<leader><leader>",
			function()
				require("fzf-lua").buffers()
			end,
			desc = "[\\] Find existing buffers",
		},
		{ -- Busca texto pero solo dentro del archivo que tienes abierto en ese momento
			"<leader>/",
			function()
				require("fzf-lua").lgrep_curbuf()
			end,
			desc = "[/] Live grep the current buffer",
		},
		{
			"<leader>fm",
			function()
				require("fzf-lua").commands()
			end,
			desc = "[f]ind co[m]mands",
		},
		-- los siguientes son para usar en el vault
		{
			"<leader>fvt",
			function()
				require("fzf-lua").live_grep({
					cwd = "./01_Notes",
					prompt = "Notes Text> ",
				})
			end,
			desc = "Buscar texto en 01_Notes",
		},
		{
			"<leader>fva",
			function()
				require("fzf-lua").files({
					cwd = "./03_Attachments",
					prompt = "Attachments>",
				})
			end,
			desc = "Buscar solo Adjuntos",
		},
		{
			"<leader>fvn",
			function()
				require("fzf-lua").files({
					cwd = "./01_Notes",
					prompt = "Notes>",
				})
			end,
			desc = "Buscar files solo en Notes",
		},
		-- Buscar TEXTO en todo el Vault (Notas y Proyectos), ignorando carpetas de binarios/adjuntos
		{
			"<leader>fvi",
			function()
				require("fzf-lua").live_grep({
					prompt = "Live Grep (Vault)> ",
					rg_opts = "--column --line-number --no-heading --color=always --smart-case "
						.. "--glob '!03_Attachments/*' "
						.. "--glob '!04_Templates/*'", -- También ignoramos templates para no duplicar resultados
				})
			end,
			desc = "Buscar texto en el Vault",
		},
		-- Buscar notas por TAGS dentro del frontmatter
		{
			"<leader>fvt",
			function()
				require("fzf-lua").grep({
					cwd = "./01_Notes",
					prompt = "Valor de Tag> ",
					search = "^tags:.*", -- busca cualquier tag
					no_esc = true,
					glob = "**/*.md",
					rg_opts = "--smart-case --no-heading --line-number --color=always ", --..
					-- "--max-lines=40",   -- ajusta según el tamaño de tu frontmatter
				})
			end,
			desc = "Buscar valor de Tag en Frontmatter",
		},
		-- Buscar notas por ALIAS dentro del frontmatter
		{
			"<leader>fvl",
			function()
				require("fzf-lua").grep({
					cwd = "./01_Notes",
					prompt = "Alias en Frontmatter> ",
					search = "^aliases:",
					no_esc = true,
					glob = "**/*.md",
					rg_opts = "--smart-case --no-heading --line-number --color=always ", --..
					-- "--max-count=1 --max-lines=30",
				})
			end,
			desc = "[f]ind a[l]ias en Frontmatter",
		},
		-- Busca solo en headers
		{
			"<leader>fve", -- por ejemplo: find headings
			function()
				require("fzf-lua").grep({
					cwd = "./01_Notes",
					prompt = "Buscar en Encabezados> ",
					search = "^#", -- regex: una o más # al inicio de línea
					no_esc = true,
					glob = "**/*.md", -- solo archivos markdown
					rg_opts = "--smart-case --no-heading --line-number --color=always",
				})
			end,
			desc = "Buscar solo en [H]eading",
		},
	},
}
