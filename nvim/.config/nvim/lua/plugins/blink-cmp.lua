-- ~/.config/nvim/lua/plugins/blink-cmp.lua
return {
	{
		"saghen/blink.compat",
		-- use the latest release, via version = '*', if you also use the latest release for blink.cmp
		version = "*",
		-- lazy.nvim will automatically load the plugin when it's required by blink.cmp
		lazy = true,
		-- make sure to set opts so that lazy.nvim calls blink.compat's setup
		opts = {},
	},
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = {
			"rafamadriz/friendly-snippets",
			"L3MON4D3/LuaSnip",
			"moyiz/blink-emoji.nvim",
			"ray-x/cmp-sql",
			"giuxtaposition/blink-cmp-copilot",
		},

		config = function(_, opts)
			-- 1. Cargar snippets de VSCode (friendly-snippets)
			require("luasnip.loaders.from_vscode").lazy_load()

			-- 2. Cargar tus snippets de la carpeta custom (~/.config/nvim/lua/snippets/)
			require("luasnip.loaders.from_lua").lazy_load({
				paths = { vim.fn.stdpath("config") .. "/lua/snippets/" },
			})

			require("blink.cmp").setup(opts)
		end,

		-- use a release tag to download pre-built binaries
		version = "1.*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 1. Especificamos que use el motor nativo de Neovim
			snippets = {
				preset = "luasnip", -- Esto usa vim.snippet de Neovim 0.10/0.11
			},
			keymap = {
				preset = "default",
				["<C-Z>"] = { "accept", "fallback" },
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = {
				menu = {
					draw = {
						columns = {
							{ "kind_icon", "label", gap = 1 }, -- Icono y Nombre
							{ "kind" }, -- Tipo (Class, Function, etc)
						},
					},
					border = "rounded", -- Opciones: 'single', 'double', 'rounded', 'solid', 'shadow'

					winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
				},
				documentation = {
					auto_show = true,
					window = {
						border = "rounded",
					},
				},
			},
			signature = {
				enabled = true, -- habilita signature
				window = { border = "rounded" }, -- pone borde redondeados a signature
			},

			sources = {
				default = {
					"lsp",
					"path",
					"snippets",
					"buffer",
					"emoji",
					"sql",
					"copilot",
				},
				providers = {
					-- 2. Agregamos el provider de Copilot usando blink.compat
					copilot = {
						name = "copilot",
						-- module = "blink.compat.source",
						module = "blink-cmp-copilot",
						score_offset = 100, -- Le damos prioridad alta para que aparezca arriba
						async = true,
						opts = {},
					},
					emoji = {
						module = "blink-emoji",
						name = "Emoji",
						score_offset = 15, -- Tune by preference
						opts = { insert = true }, -- Insert emoji (default) or complete its name
						should_show_items = function()
							return vim.tbl_contains(
								-- Enable emoji completion only for git commits and markdown.
								-- By default, enabled for all file-types.
								{ "gitcommit", "markdown" },
								vim.o.filetype
							)
						end,
					},
					sql = {
						-- IMPORTANT: use the same name as you would for nvim-cmp
						name = "sql",
						module = "blink.compat.source",

						-- all blink.cmp source config options work as normal:
						score_offset = -3,
						opts = {},
						should_show_items = function()
							return vim.tbl_contains(
								-- Enable emoji completion only for git commits and markdown.
								-- By default, enabled for all file-types.
								{ "sql" },
								vim.o.filetype
							)
						end,
					},
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
}
