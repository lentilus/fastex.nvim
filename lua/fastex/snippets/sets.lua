
local ls = require("luasnip")
local i = ls.insert_node
local helper = require("fastex.luasnip_helpers")
local first_word = helper.begin_snip
local snip = helper.std_snip
local math = helper.math
local not_math = helper.not_math local ri = helper.ri
local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
    snip("set", "\\set{<>}", {i(1)}, math),
    snip("st", "\\set{<>}{<>}", {i(1, "x"), i(2, "condition")}, math),
    snip("es", "\\emptyset", {}, math),
    snip("ses", "\\set{\\emptyset\\}", {}, math),
    snip("sp", "\\supset", {}, math),
    snip("sb", "\\subset", {}, math),
    snip("sep", "\\supseteq", {}, math),
    snip("seb", "\\subseteq", {}, math),
    snip("ca", "\\cap", {}, math),
    snip("cu", "\\cup", {}, math),
    snip("sem", "\\setminus", {}, math),
}

