local ls = require("luasnip")
local i = ls.insert_node
local helper = require("fastex.luasnip_helpers")
local snip = helper.std_snip
local math = helper.math
local cap = helper.cap

local snippets = {}
local auto_backslash = {
    "in",
    "to",
    "neg",
    "item",
    "sim",
    "ker",
    "dim",
    "mod",
    "dots",
    "vdots",
    "ddots",
    "quad",
    "perp",
    "oplus",
    "det",
    "Vol",
    "sin",
    "cos",
    "tan",
    "mable"
}

for _, val in pairs(auto_backslash) do
    table.insert(snippets, snip("(.*)" .. val, "<>\\" .. val, { cap(1) }, math))
end

return {
    snip("fa", "\\forall", {}, math),
    snip("ex", "\\exists", {}, math),
    snip("ni", "\\not\\in", {}, math),

    -- logical chunks
    snip("fen", "\\forall\\varepsilon>>0", {}, math),
    snip("fdn", "\\forall\\delta>>0", {}, math),
    snip("edd", "\\exists\\delta>>0", {}, math),
    snip("enn", "\\exists\\varepsilon>>0", {}, math),

    -- boolean logic
    snip("an", "\\land ", {}, math),
    snip("or", "\\lor ", {}, math),
    snip("no", "\\not ", {}, math),
    snip("ip", "\\implies ", {}, math),
    snip("ib", "\\impliedby ", {}, math),
    snip("if", "\\iff ", {}, math),

    -- relations
    snip("el", "=", {}, math),
    snip("df", ":=", {}, math),
    snip("lt", "<<", {}, math),
    snip("gt", ">>", {}, math),
    snip("le", "\\leq ", {}, math),
    snip("ne", "\\neq ", {}, math),
    snip("ge", "\\geq ", {}, math),

    -- operators
    snip("(.*)sk", "<>+", { cap(1) }, math, 1100),
    snip("(.*)ak", "<>-", { cap(1) }, math, 1100),
    snip("oak", "\\oplus ", {}, math),
    snip("bak", "\\boxplus ", {}, math),
    snip("xx", "\\times ", {}, math),
    snip("bxx", "\\boxtimes ", {}, math),
    snip("by", "\\cdot ", {}, math),

    -- sets
    snip("set", "\\set{<>}", { i(1) }, math),
    snip("st", "\\set{<>}{<>}", { i(1, "x"), i(2, "filter") }, math),
    snip("es", "\\emptyset ", {}, math),
    snip("ses", "\\set{\\emptyset\\}", {}, math),
    snip("sp", "\\supset ", {}, math),
    snip("sb", "\\subset ", {}, math),
    snip("sep", "\\supseteq ", {}, math),
    snip("seb", "\\subseteq ", {}, math),
    snip("nn", "\\cap ", {}, math),
    snip("uu", "\\cup ", {}, math),
    snip("bnn", "\\bigcap", {}, math, 1000),
    snip("buu", "\\bigcup", {}, math, 1000),
    snip("snn", "\\cap ", {}, math),
    snip("suu", "\\cup ", {}, math),
    snip("bsnn", "\\bigcap", {}, math, 1000),
    snip("bsuu", "\\bigcup", {}, math, 1000),
    snip("sem", "\\setminus ", {}, math),

    snip("mt", "\\mapsto ", {}, math),
    snip("to", "\\to ", {}, math),
    snip("ast", "\\ast ", {}, math),
    snip("oo", "\\circ ", {}, math),
    snip("iso", "\\cong ", {}, math),
    snip("ddx", "\\frac{d<>}{d<>}", { i(1, "f"), i(2, "x") }, math),
    snip("con", "\\contrain{<>}", { i(1) }, math),

    snip("it", "\\int_{<>}^{<>}", { i(1, "a"), i(2, "b") }, math),
    snip("oit", "\\int_{\\Omega}", {}, math),
    snip("dit", "\\int_{<>}", { i(1, "\\Omega") }, math), -- integral with Domain
    snip("sm", "\\sum_{<>}^{<>}", { i(1, "i=0"), i(2, "\\infty") }, math),
    snip("lim", "\\lim_{<> \\to <>}", { i(1, "x"), i(2, "\\infty") }, math),
    snip("ii", "\\infty", {}, math),

    snip("sgn", "\\sgn(<>)", { i(2) }, math),
    snip("ord", "\\ord(<>)", { i(2) }, math),
    snip("end", "\\End(<>)", { i(1, "V") }, math),
    snip("hom", "\\Hom(<>)", { i(1, "V") }, math),
    snip("imo", "\\Iso(<>)", { i(1, "V") }, math),
    snip("ime", "\\Isome(<>)", { i(1, "V") }, math),
    snip("ig", "\\Image ", {}, math),
    snip("hp", "\\HP(<>)", { i(2) }, math),
    snip("gl", "\\GL(<>,<>)", { i(1, "n \\times n"), i(1, "\\K") }, math),
    snip("eig", "\\Eig(<>,<>)", { i(1, "A"), i(2, "\\lambda") }, math),
    snip("mat", "\\Mat(<> \\times <>; <>)", { i(1, "n"), i(2, "n"), i(3, "\\K") }, math),

    snip("rn", "\\R^n", {}, math),

    unpack(snippets)
}
