local ls = require("luasnip")
local f = ls.function_node
local i = ls.insert_node
local helper = require("fastex.luasnip_helpers")
local snip = helper.std_snip
local math = helper.math
local cap = helper.cap

return {
	snip("([A-Z])%1", "\\mathbb{<>}", { cap(1) }, math, 100),
	snip("[A-Z]ca", "\\mathcal{<>}", { cap(1) }, math, 100),

	-- higher priority by default:
	snip("CC", "\\C ", {}, math),
	snip("KK", "\\K ", {}, math),
	snip("QQ", "\\Q ", {}, math),
	snip("RR", "\\R ", {}, math),
	snip("ZZ", "\\Z ", {}, math),
	snip("NN", "\\N ", {}, math),
	snip("La", "\\La ", {}, math),

	snip("(\\%a)%s?(%d)%s", "<>^<> ", { cap(1), cap(2) }, math),
}
