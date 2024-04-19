local ls = require("luasnip")
local helper = require("fastex.luasnip_helpers")

local ssnip = helper.std_snip
local math = helper.math
local not_math = helper.not_math
local get_visual = helper.get_visual

local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node

local bracket_snippets = {}
local auto_brackets = {
    {"iv","", "^{-1}"},
    {"bb","(", ")"},
    {"sq","[", "]"},
    {"abs","|", "|"},
    {"ht","\\hat{", "}"},
    {"br","\\bar{", "}"},
    {"dt","\\dot{", "}"},
    {"vv","\\vec{", "}"},
    {"nr","\\norm{", "}"},
    {"ag","\\langle ", "\\rangle"},
    {"lr","\\left(", "\\right)"},
}
local bracket_trig = "(%S+)%s?"
for _, val in pairs(auto_brackets) do
    local snippet = ssnip( bracket_trig..val[1], val[2].."<>"..val[3], {f(function(_, snip) return snip.captures[1] end)}, math)
    table.insert(bracket_snippets, snippet)
end

return {
    -- tuple
    ssnip("fn%s+(%S+)%s+(%S+)%s", "<>(<>)", {
    f(function(_, snip) return snip.captures[1] end),
    f(function(_, snip) return snip.captures[2] end)
    }, math),

    -- tuple
    ssnip("(%S+)%s?[;,]%s?(%S+) t", "(<>,<>)", {
    f(function(_, snip) return snip.captures[1] end),
    f(function(_, snip) return snip.captures[2] end)
    }, math),

    -- metrik
    ssnip("(%S+)%s?[;,]%s?(%S+) d", "d(<>,<>)", {
    f(function(_, snip) return snip.captures[1] end),
    f(function(_, snip) return snip.captures[2] end)
    }, math),

    -- single letters to variables
    ssnip("(%w)(%s)", "$<>$<>", {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
    }, not_math),


    -- Superscript -- Subscript --
    ssnip("(%S+)jj(%w)", "<>_<>", {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
    }, math),

    ssnip("(%S+)kk(%w)", "<>^<>", {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
    }, math),

    ssnip("(%S+)jk(%w)(%w)", "<>_<>^<>", {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
        f(function(_, snip) return snip.captures[3] end),
    }, math),

    -- fix in post
    ssnip("(.*)_(%w%w+)%s", "<>_{<>}", {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
    }, math),

    ssnip("(.*)%^(%w%w+)%s", "<>^{<>}", {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
    }, math),
    --

    -- avoid confilict with jj, kk and jk
    ssnip("([A-Za-hl-z%)}]+)(%d)", "<>_<>", {
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

    -- Fractions -- 
    ssnip("ff", "\\frac{<>}{<>}", { d(1, get_visual), i(2) }, math),
    ssnip("//", "\\faktor{<>}{<>}", { d(1, get_visual), i(2) }, math),
    ssnip("(%b())/", "\\frac{<>}{<>}", {
        f(function(_, snip) return snip.captures[1] end),
        d(1, get_visual)
    }, math),

    ssnip("([%w%d]+)/([%w%d]+)%s", "\\frac{<>}{<>}", {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
    }, math),

    ssnip("([%w%d]+)/ ", "\\frac{<>}{<>}", {
        f(function(_, snip) return snip.captures[1] end),
        d(1, get_visual)
    }, math),

    --
    ssnip("(%S+)%s?sr", "\\stackrel{<>}{<>}", { i(1), f(function(_, snip) return snip.captures[1] end), }, math),

    table.unpack(bracket_snippets),
}
