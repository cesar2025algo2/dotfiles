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
					cwd = "~/uncuyo",
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
					cwd = "~/uncuyo",
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
					cwd = "~/uncuyo",
					prompt = "Buscar en Encabezados> ",
					search = "^#", -- regex: una o más # al inicio de línea
					no_esc = true,
					glob = "**/*.md", -- solo archivos markdown
					rg_opts = "--smart-case --no-heading --line-number --color=always",
				})
			end,
			desc = "Buscar solo en [H]eading",
		},
		-- ============================================
		-- MEJORAS PARA ZETTELKASTEN CON FZF-LUA
		-- ============================================

		-- 2. Insertar enlace con autocompletado (usando fzf-lua)
		{
			"<leader>zi",
			function()
				require("fzf-lua").files({
					cwd = "./6_Zettelkasten",
					prompt = "🔗 Enlazar a> ",
					actions = {
						default = function(selected)
							local path = selected[1]
							if path == nil then
								return
							end
							local name = vim.fn.fnamemodify(path, ":t:r")
							-- Remover el ID (YYYYMMDDHHMM_) del nombre para el enlace
							local display_name = name:gsub("^%d+_", "")
							vim.cmd("normal i[[" .. display_name .. "]]")
						end,
					},
				})
			end,
			desc = "[Z]ettel [I]nsertar enlace",
		},
		-- Buscar en Inbox
		{
			"<leader>fi",
			function()
				require("fzf-lua").files({
					cwd = "./0_Inbox",
					prompt = "📥 Inbox> ",
				})
			end,
			desc = "[F]ind en [I]nbox",
		},
		-- Buscar en Materias
		{
			"<leader>fm",
			function()
				require("fzf-lua").files({
					cwd = "./2_Materias",
					prompt = "📖 Materias> ",
				})
			end,
			desc = "[F]ind en [M]aterias",
		},
		-- Buscar en Recursos
		{
			"<leader>fr",
			function()
				require("fzf-lua").files({
					cwd = "./1_Recursos",
					prompt = "🔧 Recursos> ",
				})
			end,
			desc = "[F]ind en [R]ecursos",
		},

		-- Buscar en todo el vault
		{
			"<leader>fv",
			function()
				require("fzf-lua").files({
					cwd = "~/uncuyo",
					prompt = "📚 Vault> ",
				})
			end,
			desc = "[F]ind en [V]ault",
		},

		-- 4. Buscar tags específicas en "6_Zettelkasten" (mejora de tu configuración actual)
		{
			"<leader>zt",
			function()
				local tag = vim.fn.input("Tag a buscar: ")
				if tag == "" then
					return
				end
				require("fzf-lua").grep({
					cwd = "./6_Zettelkasten",
					prompt = "🏷️ Tag: " .. tag .. "> ",
					search = "^tags:.*" .. tag .. ".*",
					no_esc = true,
					glob = "**/*.md",
					rg_opts = "--smart-case --no-heading --line-number --color=always ",
				})
			end,
			desc = "[Z]ettel buscar [T]ag",
		},

		-- 4. Buscar tags específicas en todo el vault (mejora de tu configuración actual)
		-- simil `<leader>ftv`
		{
			"<leader>zs",
			function()
				local tag = vim.fn.input("Tag a buscar: ")
				if tag == "" then
					return
				end
				require("fzf-lua").grep({
					cwd = ".",
					prompt = "🏷️ Tag: " .. tag .. "> ",
					search = "^tags:.*" .. tag .. ".*",
					no_esc = true,
					glob = "**/*.md",
					rg_opts = "--smart-case --no-heading --line-number --color=always ",
				})
			end,
			desc = "[Z]ettel buscar [T]ag",
		},

		-- 5. Buscar notas que enlazan a la actual (notas entrantes)
		{
			"<leader>zg",
			function()
				-- Obtener el nombre del archivo actual sin extensión
				local current = vim.fn.expand("%:t:r")
				-- Remover el ID para la búsqueda
				local name = current:gsub("^%d+_", "")
				require("fzf-lua").grep({
					cwd = "./6_Zettelkasten",
					prompt = "🔗 Notas que enlazan a: " .. name .. "> ",
					search = "[[" .. name .. "]]",
					no_esc = true,
					glob = "**/*.md",
					rg_opts = "--smart-case --no-heading --line-number --color=always ",
				})
			end,
			desc = "[Z]ettel [G]rep enlaces entrantes",
		},

		-- 6. Encontrar notas sin enlaces (huérfanas)
		{
			"<leader>zu",
			function()
				-- Buscar todas las notas que no tienen enlaces salientes
				require("fzf-lua").grep({
					cwd = "./6_Zettelkasten",
					prompt = "🔗 Notas huérfanas> ",
					search = "^#", -- Simplificado: mostrar notas que solo tienen título
					no_esc = true,
					glob = "**/*.md",
					rg_opts = "--smart-case --no-heading --line-number --color=always ",
				})
			end,
			desc = "[Z]ettel [U]nlinked notes",
		},

		-- 7. Buscar en todo el Zettelkasten (tus notas atómicas)
		{
			"<leader>zz",
			function()
				require("fzf-lua").files({
					cwd = "./6_Zettelkasten",
					prompt = "📚 Zettelkasten> ",
				})
			end,
			desc = "[F]ind en [Z]ettelkasten",
		},
		-- Buscar solo archivos Markdown en el vault
		{
			"<leader>fvm",
			function()
				require("fzf-lua").files({
					cwd = "~/uncuyo",
					prompt = "📝 Markdown> ",
					fd_opts = "--type f --extension md",
				})
			end,
			desc = "[F]ind en [V]ault [M]arkdown",
		},

		-- Buscar solo archivos PDF en el vault
		{
			"<leader>fvp",
			function()
				require("fzf-lua").files({
					cwd = "~/uncuyo",
					prompt = "📄 PDFs> ",
					fd_opts = "--type f --extension pdf",
				})
			end,
			desc = "[F]ind en [V]ault [P]DFs",
		},

		-- Buscar solo archivos TeX en el vault
		{
			"<leader>fvx",
			function()
				require("fzf-lua").files({
					cwd = "~/uncuyo",
					prompt = "📐 TeX> ",
					fd_opts = "--type f --extension tex",
				})
			end,
			desc = "[F]ind en [V]ault [T]eX",
		},

		-- Buscar solo código (Python, C, etc.)
		{
			"<leader>fvc",
			function()
				require("fzf-lua").files({
					cwd = "~/uncuyo",
					prompt = "💻 Code> ",
					fd_opts = "--type f --extension py --extension c --extension cpp --extension java --extension go",
				})
			end,
			desc = "[F]ind en [V]ault [C]ódigo",
		},
	},
}
