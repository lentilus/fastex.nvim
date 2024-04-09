local ls = require("luasnip")
local i = ls.insert_node
local helper = require("fastex.luasnip_helpers")
local first_word = helper.begin_snip
local snip = helper.std_snip
local math = helper.math
local not_math = helper.not_math local ri = helper.ri
local line_begin = require("luasnip.extras.expand_conditions").line_begin

-- local ls = require("luasnip")
-- local i = ls.insert_node
local f = ls.function_node
-- local helper = require("math.luasnip_helpers")
-- local line_start = helper.line_start
local line_running = helper.line_running
-- local math = helper.math
-- local not_math = helper.not_math
-- local ri = helper.ri

return {
    ------------------------------------------------
    -- Relations -----------------------------------
    ------------------------------------------------
    -- equal
    snip("ee", "= ", {}, math),

    -- not equal
    snip("ne", "\\neq ", {}, math),

    -- less than
    snip("lt", "<< ", {}, math),

    -- less than or equal
    snip("le", "\\leq ", {}, math),

    -- greater than
    snip("gt", ">> ", {}, math),

    -- greater than or equal
    snip("ge", "\\geq ", {}, math),
}

