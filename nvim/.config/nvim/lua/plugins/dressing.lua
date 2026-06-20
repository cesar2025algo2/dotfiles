-- ~/.config/nvim/lua/plugins/dressing.lua
return {
  "stevearc/dressing.nvim",
  event = "VeryLazy", -- No es necesario que cargue al inicio
  opts = {
    input = {
      -- Para que las ventanas de input (como rename) sean consistentes
      enabled = true,
      default_prompt = "➤ ",
      border = "rounded", -- Bordes redondeados para un look moderno
    },
    select = {
      enabled = true,
      backend = { "fzf_lua", "builtin" },
      -- Esto hace que si tienes Telescope instalado, los select (code actions)
      -- usen la interfaz de búsqueda de Telescope automáticamente.
    },
  },
}
-- return {
-- 	"stevearc/dressing.nvim",
-- 	opts = {},
-- }

