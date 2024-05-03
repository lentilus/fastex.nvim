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
    {"rt","\\sqrt{", "}"},
    {"ag","\\langle ", "\\rangle"},
    {"lr","\\left(", "\\right)"},
}
local bracket_trig = "([%${}%(%)]?)(%S+)%s?"
for _, val in pairs(post_brackets) do
    table.insert(snippets, ssnip( bracket_trig..val[1], "<>"..val[2].."<>"..val[3], {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end)
    }, math, 100))

    table.insert(snippets, ssnip( "(%b())%s?"..val[1], val[2].."<>"..val[3], {
        f(function(_, snip) return snip.captures[1] end),
    }, math, 1000))

    table.insert(snippets, ssnip( "(%b[])%s?"..val[1], val[2].."<>"..val[3], {
        f(function(_, snip) return snip.captures[1] end),
    }, math, 1000))

    table.insert(snippets, ssnip( "(%b{})%s?"..val[1], val[2].."<>"..val[3], {
        f(function(_, snip) return snip.captures[1] end),
    }, math, 1000))
end

for _, val in pairs(post_brackets) do
    table.insert(snippets, ssnip( "%s;"..val[1], val[2].."<>"..val[3], {
        d(1, get_visual)
    }, math, 10000))
end

local post_tuples = {
    {"tt","(", ")"}, -- generic tuple
    {"dd","d(", ")"}, -- metric
    {"ss","\\langle ", "\\rangle"}, -- dotproduct
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

    -- Epsilon Ball
    ssnip("(.*%s)be%s?(%S+)%s+", "<>B_{\\varepsilon}(<>)", {
        f(function(_, sp) return sp.captures[1] end),
        f(function(_, sp) return sp.captures[2] end),
    }, math),


    ssnip("(.*)%s?dif%s?(%S+)%s+", "<>^{(<>)}", {
        f(function(_, sp) return sp.captures[1] end),
        f(function(_, sp) return sp.captures[2] end),
    }, math),

    -- ssnip("(.*)%s+is%s+(%S+)%s", "<>\\tx{-<>}", {
    --     f(function(_, sp) return sp.captures[1] end),
    --     f(function(_, sp) return sp.captures[2] end),
    -- }, math),
    --
    -- ssnip("(.*)%s+si", "<>\\tx{-<>}", {
    --     f(function(_, sp) return sp.captures[1] end),
    --     i(1),
    -- }, math),
    --
    -- ssnip("(.*%$)%s?is%s+(%S+)%s", "<>-<> ", {
    --     f(function(_, sp) return sp.captures[1] end),
    --     f(function(_, sp) return sp.captures[2] end),
    -- }, not_math),

    -- ssnip("([Ss]ei)%s+(%$.-%$)%s+(%S+)%s", "<> <>-<> ", {
    --     f(function(_, sp) return sp.captures[1] end),
    --     f(function(_, sp) return sp.captures[2] end),
    --     f(function(_, sp) return sp.captures[3] end),
    -- }, not_math),

    --1 through n
    ssnip("%s(%S+)%s?tn", "<>_1,\\dots,<>_n", {
        f(function(_, sp) return sp.captures[1] end),
        f(function(_, sp) return sp.captures[1] end),
    }, math),

    table.unpack(snippets),
}
