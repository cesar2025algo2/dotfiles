-- ~/.config/nvim/lua/plugins/treesitter.lua
return {

    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = function()
      -- No hace falta setup() para lo básico. Solo instalamos parsers si faltan
      local parsers = {
        "lua", "python", "javascript", "typescript",
        "markdown", "markdown_inline", "vim", "vimdoc", "bash",
        "json", "yaml", "toml", "html", "css", "cpp", "c", "latex",
      }
      require("nvim-treesitter").install(parsers)

-- Activa Tree-sitter correctamente (highlight + indent + folds)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = parsers,
        callback = function()
          -- Activa resaltado semántico con Tree-sitter
          pcall(vim.treesitter.start)

          -- Desactiva el viejo resaltado regex (importante para evitar conflictos)
          vim.bo.syntax = "off"

          -- Indentación inteligente basada en Tree-sitter (mejor que smartindent)
         -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

          -- Asegura folds con Tree-sitter
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end,
      })

-- Nueva forma de selección incremental en Neovim 0.12 (recomendada)
-- Neovim trae estos mapeos nativos (basados en Tree-sitter cuando el parser está cargado):
--
-- En modo Visual (v):
-- an → selecciona el nodo padre (expandir hacia afuera)
-- in → selecciona el nodo hijo (hacia adentro)
-- ]n → siguiente nodo hermano
-- [n → nodo hermano anterior

end,

}
