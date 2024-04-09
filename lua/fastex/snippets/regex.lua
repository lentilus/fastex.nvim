local ls = require("luasnip")
local helper = require("fastex.luasnip_helpers")

local ssnip = helper.std_snip
local math = helper.math
local not_math = helper.not_math

local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node

local get_visual = function(args, parent)
    if (#parent.snippet.env.LS_SELECT_RAW > 0) then
        return ls.snippet_node(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
    else -- If LS_SELECT_RAW is empty, return a blank insert node
        return ls.snippet_node(nil, i(1))
    end
end

return {

    ssnip("([^\\]-)bb", "<>(<>)", {
        f(function(_, snip) return snip.captures[1] end),
        d(1, get_visual)
    }, math),

    ssnip("(%S+)%s?;%s?(%S+) d", "d(<>,<>) ", {
    f(function(_, snip) return snip.captures[1] end),
    f(function(_, snip) return snip.captures[2] end)
    }, math),

    ssnip("(%S+)%s?;%s?(%S+) t", "(<>,<>) ", {
    f(function(_, snip) return snip.captures[1] end),
    f(function(_, snip) return snip.captures[2] end)
    }, math),

    -- fraction
    ssnip("ff", "\\frac{<>}{<>}", { d(1, get_visual), i(2) }, math),

    -- single letters are variables $x$
    ssnip("(%a)(%s)", "$<>$<>", {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
    }, not_math),

    ssnip("(%S+)jj(.)", "<>_<> ", {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
    }, math),

    ssnip("(%S+)kk(.)", "<>^<> ", {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
    }, math),

    ssnip("(%S+)jk(.)(.)", "<>_<>^<> ", {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
        f(function(_, snip) return snip.captures[3] end),
    }, math),

    ssnip("(%S+)JJ", "<>_{<>} ", { f(function(_, snip) return snip.captures[1] end), i(1, "sub") }, math),

    ssnip("(%S+)KK", "<>^{<>} ", { f(function(_, snip) return snip.captures[1] end), i(1, "sup") }, math),

    ssnip("(%S+)JK", "<>_{<>}^{<>} ", { f(function(_, snip) return snip.captures[1] end), i(1, "sub"), i(2, "sup") },
        math),

    -- inverse
    ssnip("(%S+)iv", "<>^{-1} ", { f(function(_, snip) return snip.captures[1] end), }, math),

    ssnip("(%S+)ag", "\\langle <>\\rangle ", { f(function(_, snip) return snip.captures[1] end), }, math),

    ssnip("(%S+)vv", "\\vec{<>} ", { f(function(_, snip) return snip.captures[1] end), }, math),

    ssnip("(%S+)ht", "\\hat{<>} ", { f(function(_, snip) return snip.captures[1] end), }, math),

    ssnip("(%S+)br", "\\bar{<>} ", { f(function(_, snip) return snip.captures[1] end), }, math),

    ssnip("(%S+)sr", "\\stackrel{<>}{<>} ", { i(1), f(function(_, snip) return snip.captures[1] end), }, math),

    ssnip("(%a+)(%d)%s", "<>_<> ", {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
    }, math),

    ssnip("(%a+)%d(%d)", "<>^<> ", {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
    }, math),

    ssnip("(%a+)(%d)%s", "$<>_<>$ ", {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
    }, not_math),

    ssnip("(%a+)%d(%d)%s", "$<>^<>$ ", {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
    }, not_math),

    ssnip("(%b())/", "\\frac{<>}{<>} ", {
        f(function(_, snip) return snip.captures[1] end),
        d(1, get_visual)
    }, math),

    ssnip("([%w%d]+)/([%w%d]+)%s", "\\frac{<>}{<>} ", {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
    }, math),

    ssnip("([%w%d]+)/ ", "\\frac{<>}{<>} ", {
        f(function(_, snip) return snip.captures[1] end),
        d(1, get_visual)
    }, math),

    ssnip("(%b())uu", "$\\begin{pmatrix}<>\\end{pmatrix}$ ", {
        f(
            function(_, snip)
                local captured = snip.captures[1]
                -- remove first (
                local str = captured:sub(2)
                -- remove last )
                str = str:sub(1, -2)
                str = string.gsub(str, "%s+", "\\\\ ")
                return str
            end
        ),
    }, math),
}
