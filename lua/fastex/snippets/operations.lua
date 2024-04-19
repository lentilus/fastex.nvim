local ls = require("luasnip")
local i = ls.insert_node
local helper = require("fastex.luasnip_helpers")
local snip = helper.std_snip
local math = helper.math

return {
    -- sum
    snip("sm", "\\sum_{<>}^{<>}", { i(1, "i=0"), i(2, "\\infty") }, math),

    -- plus
    snip("ss", "+ ", {}, math),

    -- cross product
    snip("cp", "\\times ", {}, math),

    -- by
    snip("by", "\\cdot ", {}, math),

    -- minus
    snip("mm", "- ", {}, math),

    -- integral
    snip("it", "\\int_{<>}^{<>}", { i(1, "a"), i(2, "b") }, math),
    snip("lim", "\\lim_{<> \\to <>}", { i(1, "x"), i(2, "\\infty") }, math),
    snip("ker", "\\ker ", {}, math),
    snip("dim", "\\dim ", {}, math),
    snip("ig", "\\Image ", {}, math),
    snip("eig", "\\Eig(<>,<>) ", { i(1, "A"), i(2, "\\lambda") }, math),
    snip("end", "\\End(<>) ", { i(1, "V") }, math),
    snip("hom", "\\Hom(,<>) ", { i(1, "V") }, math),
    snip("gl", "\\GL(<>,<>) ", { i(1, "n \\times n"), i(1, "\\K") }, math),
    snip("sgn", "\\sgn(<>) ", { i(2) }, math),
    snip("hp", "\\HP(<>) ", { i(2) }, math),
    snip("ord", "\\ord(<>) ", { i(2) }, math),
    snip("sim", "\\sim ", {}, math),
    snip("mat", "\\Mat(<> \\times <>; <>) ", { i(1, "n"), i(2, "n"), i(2, "\\K") }, math),

    snip("LL", "\\La ", {}, math),

    snip("KK", "\\K ", {}, math),
}
