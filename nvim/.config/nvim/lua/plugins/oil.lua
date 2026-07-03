-- ~\.config/nvim/lua/plugins/oil.lua
return {
	"stevearc/oil.nvim",
	keys = { { "-", "<cmd>Oil --float<CR>", desc = "Open Parent Directory in Oil" } },
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		-- keymaps = {
		-- 	-- Mapea 'gO' (u otra tecla que prefieras) para abrir con el sistema
		-- 	["gO"] = { "actions.open_external", desc = "Abrir con programa externo (Zathura/MPV/etc)" },
		-- },
		keymaps = {
			["<CR>"] = function()
				local oil = require("oil")
				local entry = oil.get_cursor_entry()

				if entry then
					local name = entry.name
					-- Detectar la extensión del archivo (ignorando mayúsculas/minúsculas)
					if name:match("%.pdf$") or name:match("%.PDF$") then
						local path = oil.get_current_dir() .. name
						-- Ejecuta zathura en segundo plano liberando Neovim
						vim.fn.jobstart({ "zathura", path }, { detach = true })
						return
					elseif name:match("%.mp4$") or name:match("%.mkv$") then
						-- Ejemplo extra: abrir videos con mpv automáticamente
						local path = oil.get_current_dir() .. name
						vim.fn.jobstart({ "mpv", path }, { detach = true })
						return
					end
				end
				-- Si no es un PDF o formato especial, usa el comportamiento normal de Oil
				oil.select()
			end,
		},
	},
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	--lazy = false,
}
