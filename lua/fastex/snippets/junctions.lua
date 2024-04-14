local helper = require("fastex.luasnip_helpers")
local ls = require("luasnip")
local i = ls.insert_node
local snip = helper.std_snip
local math = helper.math
local not_math = helper.not_math
local ri = helper.ri
local d = ls.dynamic_node

return {
    snip("an", "\\land ", {}, math),
    snip("or", "\\lor ", {}, math),
    snip("neg", "\\neg ", {}, math),
    snip("no", "\\not ", {}, math),
    snip("ip", "\\implies ", {}, math),
    snip("ib", "\\impliedby ", {}, math),
    snip("if", "\\iff ", {}, math),
}
