-- ~/.config/nvim/lua/plugins/tokyonight.lua
return {
	"folke/tokyonight.nvim",
	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		---@diagnostic disable-next-line: missing-fields
		require("tokyonight").setup({
			style = "night", -- night, storm, day, moon
			transparent = false,
			styles = {
				comments = { italic = false }, -- Disable italics in comments
			},
			--[[
			overrides = function(colors)
				return {
					["@markup.link.url.markdown_inline"] = { link = "Special" }, -- (url)
					["@markup.link.label.markdown_inline"] = { link = "WarningMsg" }, -- [label]
					["@markup.italic.markdown_inline"] = { link = "Exception" }, -- *italic*
					["@markup.raw.markdown_inline"] = { link = "String" }, -- `code`
					["@markup.list.markdown"] = { link = "Function" }, -- + list
					["@markup.quote.markdown"] = { link = "Error" }, -- > blockcode
					["@markup.list.checked.markdown"] = { link = "WarningMsg" }, -- - [X] checked list item
				}
			end,]]
		})
		-- load the colorscheme here
		vim.cmd("colorscheme tokyonight")
		-- Esto le da un color naranja/rojizo a las negritas en Markdown
		--vim.api.nvim_set_hl(0, "@markup.strong.markdown_inline", { fg = "#ff9e64", bold = true })
		vim.api.nvim_set_hl(0, "@markup.strong.markdown_inline", { fg = "#F38BA8", bold = true })
		--vim.api.nvim_set_hl(0, "@markup.italic.markdown_inline", { fg = "#ff9e64", italic = true })
		vim.api.nvim_set_hl(0, "@markup.italic.markdown_inline", { fg = "#F38BA8", italic = true })
	end,
}
