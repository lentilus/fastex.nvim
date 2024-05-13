local ls = require("luasnip")
local helper = require("fastex.luasnip_helpers")

local snip = helper.std_snip
local math = helper.math
local not_math = helper.not_math
local get_visual = helper.get_visual
-- local gsnip = helper.group_snip
local mgsnip = helper.mgroup_snip
local cap = helper.cap

local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node

local snippets = {}

local enc = {
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

for _, val in pairs(enc) do
    table.insert(snippets, mgsnip( "#"..val[1], val[2].."<>"..val[3], {cap(1)}, math))
end

return {
    -- tuple stuff
    mgsnip("#,%s?#tt", "(<>,<>)", { cap(2), cap(1) }, math),
    mgsnip("#,%s?#dd", "d(<>,<>)", { cap(2), cap(1) }, math),
    mgsnip("#,%s?#sa", "\\langle <>,<>\\rangle", { cap(2), cap(1) }, math),

    -- subscript
    mgsnip("#j", "<>_", { cap(1) }, math),
    mgsnip("#k", "<>^", { cap(1) }, math),

    -- hinder autofix
    mgsnip("(.*[%^_]{)", "<>", { cap(1) }, math),
    mgsnip("(.*[%^_][%a%d]%s?%s?)", "<>", { cap(1) }, math),

    -- autofix
    mgsnip("(.*)_%s?#%s", "<>_{<>}", { cap(2), cap(1) }, math, 100),
    mgsnip("(.*)%^%s?#%s", "<>_{<>}", { cap(2), cap(1) }, math, 100),

    snip("bb", "(<>)", {i(1)}, math),
    -- single letters to variables
    snip("(%w)(%s)", "$<>$<>", { cap(1), cap(2) }, not_math),

    -- Fractions -- 
    snip("ff", "\\frac{<>}{<>}", { d(1, get_visual), i(2) }, math),
    mgsnip("#/%s", "\\frac{<>}{<>}", { cap(1), i(1) }, math),
    mgsnip("#/#%s", "\\frac{<>}{<>}", { cap(2), cap(1) }, math),
    mgsnip("#//%s", "\\faktor{<>}{<>}", { cap(1), i(1) }, math),
    mgsnip("#%s?//#%s%s+", "\\faktor{<>}{<>}", { cap(2), cap(1) }, math, 100),

    mgsnip("#sr", "\\stackrel{<>}{<>}", { i(1), cap(1) }, math),
    mgsnip("#ub", "\\underbrace{<>}_\\tx{<>}", { cap(1), i(1)}, math),

    -- series ---
    snip("(%a_?%w?)se", "(<>)", { cap(1) }, math),

    -- map ---
    snip("ma%s+(%S+)%s+", "\\from <>\\to ", { cap(1) }, math),

    -- f(x) : f of x
    mgsnip("(.-)%s?of%s?#%s", "<>(<>)", { cap(2),cap(1) }, math),

    -- Epsilon Ball
    mgsnip("be%s?#%s", "B_{\\varepsilon}(<>)", { cap(1)}, math),

    -- partial derivative
    mgsnip("(.*)pt%s?#%s#%s", "<>\\frac{\\partial <>}{\\partial <>}", { cap(3),cap(2),cap(1) }, math),

    -- derivative
    snip("(.*)%s?dif%s?(%S+)%s+", "<>^{(<>)}", { cap(1), cap(2) }, math),

    --1 through n
    mgsnip("(.*)%s#%s?tn", "<> <>_1,\\dots,<>_n", { cap(2), cap(1), cap(1) }, math),

    table.unpack(snippets)
}
