local ls = require("luasnip")
local f = ls.function_node
local i = ls.insert_node
local helper = require("fastex.luasnip_helpers")
local snip = helper.std_snip
local math = helper.math

return {
    snip("([ABDEFGHIJKLMNOPSTUVWXY])%1", "\\mathbb{<>}", {
            f(function(_, sp) return sp.captures[1] end)
        }, math
    ),
    snip("CC", "\\C ", {}, math),
    snip("KK", "\\K ", {}, math),
    snip("La", "\\La ", {}, math),
    snip("QQ", "\\Q ", {}, math),
    snip("RR", "\\R ", {}, math),
    snip("ZZ", "\\Z ", {}, math),
}
