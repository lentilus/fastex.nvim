local helper = require("fastex.luasnip_helpers")
local ls = require("luasnip")
local i = ls.insert_node
local snip = helper.std_snip
local math = helper.math

return {
    snip("map", "<> \\rightarrow <>, <> \\mapsto <> ", {
        i(1, "A"), i(2, "B"), i(3, "x"), i(4, "x'") }, math),

    snip("ms", "\\mapsto ", {}, math),
    snip("mp", "\\longrightarrow ", {}, math),
    snip("xx", "\\ast ", {}, math),
    snip("oo", "\\circ ", {}, math),
    snip("sim", "\\sim ", {}, math),
    snip("ddx", "\\frac{d<>}{d<>}", { i(1, "f"), i(2, "x") }, math),

}
