local ls = require("luasnip")
local i = ls.insert_node
local f = ls.function_node
local helper = require("latex.luasnip_helpers")
local line_start = helper.line_start
local line_running = helper.line_running
local math = helper.math
local not_math = helper.not_math
local ri = helper.ri

return {
    -- define a mapping
    line_running("map", "<> \\rightarrow <>, <> \\mapsto <> ", { i(1, "A"), i(2, "B"), i(3, "x"), i(4, "x'") }, math),

    -- maps to
    line_running("ms", "\\mapsto ", {}, math),

    -- rightarrow
    line_running("mp", "\\longrightarrow ", {}, math),

    -- fancy mapping
    line_running("fma", [[
        \begin{align*}
            <> & \longrightarrow <>\\
            <> & \longmapsto <>
        \end{align*}
    ]], { i(1, "A"), i(2, "B"), i(3, "x"), i(4, "x'") }, math),

    -- *
    line_running("xx", "\\ast ", {}, math),

    -- o
    line_running("oo", "\\circ ", {}, math),

    -- tilde
    line_running("sim", "\\sim ", {}, math),

    -- d/dx
    line_running("ddx", "\\frac{d<>}{d<>}", { i(1, "f"), i(2, "x") }, math),

}
