local ls = require("luasnip")
local helper = require("fastex.luasnip_helpers")

local ssnip = helper.std_snip
local math = helper.math
local not_math = helper.not_math
local get_visual = helper.get_visual

local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node

local snippets = {}

local post_brackets = {
    {"iv","", "^{-1}"},
    {"rb","(", ")"},
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
local bracket_trig = "([%${}%(%)]?)(%S+)%s?"
for _, val in pairs(post_brackets) do
    local snippet1 = ssnip( bracket_trig..val[1], "<>"..val[2].."<>"..val[3], {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end)
    }, math, 100)
    local snippet2 = ssnip( "(%b())%s?"..val[1], val[2].."<>"..val[3], {
        f(function(_, snip) return snip.captures[1] end),
    }, math, 10000)
    local snippet3 = ssnip( "(%b[])%s?"..val[1], val[2].."<>"..val[3], {
        f(function(_, snip) return snip.captures[1] end),
    }, math, 10000)
    local snippet4 = ssnip( "(%b{})%s?"..val[1], val[2].."<>"..val[3], {
        f(function(_, snip) return snip.captures[1] end),
    }, math, 10000)

    table.insert(snippets, snippet1)
    table.insert(snippets, snippet2)
    table.insert(snippets, snippet3)
    table.insert(snippets, snippet4)
end

local post_tuples = {
    {"t","(", ")"},
    {"d","d(", ")"},
    {"s","\\langle ", "\\rangle"}, -- dotproduct
}

local tupel_trig="([{}%(%)%$]?)(%S+)%s?[;,]%s?(%S+)%s"
for _, val in pairs(post_tuples) do
    local snippet = ssnip( tupel_trig..val[1], "<>"..val[2].."<>,<>"..val[3], {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
        f(function(_, snip) return snip.captures[3] end),
    }, math, 100)
    table.insert(snippets, snippet)
end

return {

    ssnip("bb", "(<>)", {i(1)}, math),

    -- tuple
    ssnip("([{}%(%)%$]?)(%S+)%s?[;,]%s?(%S+) t", "<>(<>,<>)", {
    f(function(_, snip) return snip.captures[1] end),
    f(function(_, snip) return snip.captures[2] end),
    f(function(_, snip) return snip.captures[3] end),
    }, math),

    -- metrik
    ssnip("([{}%(%)%$]?)(%S+)%s?[;,]%s?(%S+) d", "<>d(<>,<>)", {
    f(function(_, snip) return snip.captures[1] end),
    f(function(_, snip) return snip.captures[2] end),
    f(function(_, snip) return snip.captures[3] end),
    }, math),

    -- single letters to variables
    ssnip("(%w)(%s)", "$<>$<>", {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
    }, not_math),

    -- Fractions -- 
    ssnip("ff", "\\frac{<>}{<>}", { d(1, get_visual), i(2) }, math),
    ssnip("(%S+)%s?//(%S+)%s+", "\\faktor{<>}{<>}", {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
    }, math, 100),
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
    ssnip("(%S+)%s?ub", "\\underbrace{<>}_\\tx{<>}", { f(function(_, snip) return snip.captures[1] end), i(1)}, math),

    -- map ---
    ssnip("map%s+(%S+)%s+", "\\from <>\\to ", {
        f(function(_, sp) return sp.captures[1] end),
    }, math),

    -- f(x) : f of x
    ssnip("(.*)%s?of%s?(%S+)%s+", "<>(<>)", {
        f(function(_, sp) return sp.captures[1] end),
        f(function(_, sp) return sp.captures[2] end),
    }, math),

    ssnip("(.*)%s?dif%s?(%S+)%s+", "<>^{(<>)}", {
        f(function(_, sp) return sp.captures[1] end),
        f(function(_, sp) return sp.captures[2] end),
    }, math),

    ssnip("(.*)%s+is%s+(%S+)%s", "<>\\tx{-<>}", {
        f(function(_, sp) return sp.captures[1] end),
        f(function(_, sp) return sp.captures[2] end),
    }, math),

    ssnip("(.*)%s+si", "<>\\tx{-<>}", {
        f(function(_, sp) return sp.captures[1] end),
        i(1),
    }, math),

    ssnip("(.*%$)%s?is%s+(%S+)%s", "<>-<> ", {
        f(function(_, sp) return sp.captures[1] end),
        f(function(_, sp) return sp.captures[2] end),
    }, not_math),

    ssnip("([Ss]ei)%s+(%$.-%$)%s+(%S+)%s", "<> <>-<> ", {
        f(function(_, sp) return sp.captures[1] end),
        f(function(_, sp) return sp.captures[2] end),
        f(function(_, sp) return sp.captures[3] end),
    }, not_math),

    table.unpack(snippets),
}
