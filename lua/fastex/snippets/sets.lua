
local ls = require("luasnip")
local i = ls.insert_node
local helper = require("latex.luasnip_helpers")
local first_word = helper.begin_snip
local snip = helper.std_snip
local math = helper.math
local not_math = helper.not_math local ri = helper.ri
local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
    ------------------------------------------------
    -- Sets ----------------------------------------
    ------------------------------------------------
    -- set
    snip("st", "\\set{<>}", {i(1)}, math),
    -- set definition
    snip("dst", "\\set{<>}{<>}", {i(1, "x"), i(2, "condition")}, math),

    -- middle seperator
    snip("||", "\\middle|", {}, math),

    -- tuple
    -- snip("tp", "(<>,<>)", {i(1, "a"), i(2, "b")}, math),

    -- empty set
    snip("es", "\\emptyset", {}, math),

    -- set with empty set
    snip("ses", "\\set{\\emptyset\\}", {}, math),

    -- superset
    snip("sp", "\\supset", {}, math),

    -- subset
    snip("sb", "\\subset", {}, math),

    -- superset equals
    snip("sep", "\\supseteq", {}, math),

    -- subset equals
    snip("seb", "\\subseteq", {}, math),

    -- cap
    snip("ca", "\\cap", {}, math),

    -- cup
    snip("cu", "\\cup", {}, math),

    -- set minus
    snip("sem", "\\setminus", {}, math),
}

