local ls = require("luasnip")
local i = ls.insert_node
local helper = require("fastex.luasnip_helpers")
local snip = helper.std_snip
local math = helper.math

return {
    snip("fa", "\\forall ", {}, math),
    snip("ex", "\\exists ", {}, math),
    snip("in", "\\in ", {}, math),
    snip("ni", "\\not\\in ", {}, math),

    -- logic
    snip("an", "\\land ", {}, math),
    snip("or", "\\lor ", {}, math),
    snip("neg", "\\neg ", {}, math),
    snip("no", "\\not ", {}, math),
    snip("ip", "\\implies ", {}, math),
    snip("ib", "\\impliedby ", {}, math),
    snip("if", "\\iff ", {}, math),

    -- relations
    snip("ee", "=", {}, math),
    snip("lt", "<<", {}, math),
    snip("gt", ">>", {}, math),
    snip("le", "\\leq ", {}, math),
    snip("ne", "\\neq ", {}, math),
    snip("ge", "\\geq ", {}, math),

    -- basic math operators
    snip("ss", "+", {}, math),
    snip("mm", "-", {}, math),
    snip("xx", "\\times ", {}, math),
    snip("by", "\\cdot ", {}, math),

    -- sets
    snip("set", "\\set{<>}", {i(1)}, math),
    snip("st", "\\set{<>}{<>}", {i(1, "x"), i(2, "filter")}, math),
    snip("es", "\\emptyset ", {}, math),
    snip("ses", "\\set{\\emptyset\\}", {}, math),
    snip("sp", "\\supset ", {}, math),
    snip("sb", "\\subset ", {}, math),
    snip("sep", "\\supseteq ", {}, math),
    snip("seb", "\\subseteq ", {}, math),
    snip("ca", "\\cap ", {}, math),
    snip("cu", "\\cup ", {}, math),
    snip("sem", "\\setminus ", {}, math),

    snip("mt", "\\mapsto ", {}, math),
    snip("to", "\\to ", {}, math),
    snip("ast", "\\ast ", {}, math),
    snip("oo", "\\circ ", {}, math),
    snip("sim", "\\sim ", {}, math),
    snip("ddx", "\\frac{d<>}{d<>}", { i(1, "f"), i(2, "x") }, math),

    snip("it", "\\int_{<>}^{<>}", { i(1, "a"), i(2, "b") }, math),
    snip("sm", "\\sum_{<>}^{<>}", { i(1, "i=0"), i(2, "\\infty") }, math),
    snip("lim", "\\lim_{<> \\to <>}", { i(1, "x"), i(2, "\\infty") }, math),

    snip("ker", "\\ker ", {}, math),
    snip("dim", "\\dim ", {}, math),
    snip("sim", "\\sim ", {}, math),
    snip("det", "\\det ", {}, math),
    snip("sgn", "\\sgn(<>)", { i(2) }, math),
    snip("ord", "\\ord(<>)", { i(2) }, math),
    snip("end", "\\End(<>)", { i(1, "V") }, math),
    snip("hom", "\\Hom(<>)", { i(1, "V") }, math),
    snip("ig", "\\Image ", {}, math),
    snip("hp", "\\HP(<>)", { i(2) }, math),
    snip("gl", "\\GL(<>,<>)", { i(1, "n \\times n"), i(1, "\\K") }, math),
    snip("eig", "\\Eig(<>,<>)", { i(1, "A"), i(2, "\\lambda") }, math),
    snip("mat", "\\Mat(<> \\times <>; <>)", { i(1, "n"), i(2, "n"), i(3, "\\K") }, math),
}
