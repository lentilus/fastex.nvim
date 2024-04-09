local ls = require("luasnip")
local i = ls.insert_node
local helper = require("latex.luasnip_helpers")
local line_start = helper.line_start
local line_running = helper.line_running
local math = helper.math
local not_math = helper.not_math
local ri = helper.ri

return {
    ------------------------------------------------
    -- Junktions -----------------------------------
    ------------------------------------------------
    -- and
    line_running("an", "\\land ", {}, math),

    -- or
    line_running("or", "\\lor ", {}, math),

    -- negation
    line_running("neg", "\\neg ", {}, math),

    -- not
    line_running("no", "\\not ", {}, math),

    -- implies
    line_running("ip", "\\implies ", {}, math),

    -- implied by
    line_running("ib", "\\impliedby ", {}, math),

    -- equivalent
    line_running("if", "\\iff ", {}, math),
}
