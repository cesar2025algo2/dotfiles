local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- Función para obtener la fecha/hora como ID
local function get_id()
	return os.date("%Y%m%d%H%M")
end

ls.add_snippets("markdown", {
	s("yaml", {
		t({ "---", "id: " }),
		f(get_id), -- Genera el ID automático: 202310271030
		t({ "", "title: " }),
		i(1, "título"), -- El cursor saltará aquí primero
		t({ "", "aliases: [" }),
		i(2), -- Luego saltará aquí
		t({ "]", "tags: [" }),
		i(3), -- Y luego aquí
		t({ "]", "---", "" }),
		i(0), -- Posición final del cursor
	}),
})
