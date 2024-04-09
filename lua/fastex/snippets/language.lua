local ls = require("luasnip")
local i = ls.insert_node
local helper = require("fastex.luasnip_helpers")
local first_word = helper.begin_snip
local snip = helper.std_snip
local math = helper.math local not_math = helper.not_math local ri = helper.ri
local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
    -- ()
    snip("bb", "(<>)", {i(1, " ")}, not_math),

    -- ,sodass
    snip("sd", "\\text{ s.d. } ", {}, math),

    -- ,mit
    snip("mit", "\\text{ mit } ", {}, math),

    -- ,also
    snip("also", "\\text{ also } ", {}, math),

    -- ,wobei
    snip("wobei", "\\text{ wobei } ", {}, math),

    -- ,wenn
    snip("wenn", "\\text{ wenn } ", {}, math),

    -- ,falls
    snip("fl", "\\text{ falls } ", {}, math),

    -- K"orper
    snip("kpr", "K\"orper ", {}, not_math),
}
