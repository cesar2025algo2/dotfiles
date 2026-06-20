-- ~/.config/nvim/lua/core/ui.lua

-- 1. Configuración del Tema
-- vim.cmd.colorscheme("catppuccin")

-- 2. Monkey Patch para bordes redondeados en ventanas flotantes
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or "rounded"
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Aquí podrías añadir más configuraciones visuales en el futuro (ej. iconos, tabline)
