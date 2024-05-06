local ls = require("luasnip")
local helper = require("fastex.luasnip_helpers")

local ssnip = helper.std_snip
local math = helper.math
local not_math = helper.not_math
local get_visual = helper.get_visual
local cap = helper.cap

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

local balanced = {"{}","||","()","[]"}

local bracket_trig = "([%${}%(%)]?)(%S+)%s?"
for _, val in pairs(post_brackets) do
    table.insert(snippets, ssnip( bracket_trig..val[1], "<>"..val[2].."<>"..val[3], {
        cap(1),cap(2)
    }, math, 100))

    for _, bal in pairs(balanced) do
        table.insert(snippets, ssnip("(%b"..bal..")%s?"..val[1], val[2].."<>"..val[3], {
            cap(1)
        }, math, 1000))
    end
end

for _, val in pairs(post_brackets) do
    table.insert(snippets, ssnip( "%s;"..val[1], val[2].."<>"..val[3], {
        d(1, get_visual)
    }, math, 10000))
end

local post_tuples = {
    {"tt","(", ")"}, -- generic tuple
    {"dd","d(", ")"}, -- metric
    {"sa","\\langle ", "\\rangle"}, -- dotproduct
}

local tupel_trig="([{}%(%)%$]?)(%S+)%s?[;,]%s?(%S+)%s"
for _, val in pairs(post_tuples) do
    local snippet = ssnip( tupel_trig..val[1], "<>"..val[2].."<>,<>"..val[3], {cap(1), cap(2), cap(3)}, math, 100)

    for _, bal in pairs(balanced) do
        local bsnippet = ssnip( "(.*)(%b"..bal..")%s?[;,]%s?(%b"..bal..")%s"..val[1], "<>"..val[2].."<>,<>"..val[3], {
            cap(1), cap(2), cap(3)
        }, math, 200)
        table.insert(snippets, bsnippet)
    end

    table.insert(snippets, snippet)
end

return {

    ssnip("bb", "(<>)", {i(1)}, math),

    -- single letters to variables
    ssnip("(%w)(%s)", "$<>$<>", { cap(1), cap(2) }, not_math),

    -- Fractions -- 
    ssnip("ff", "\\frac{<>}{<>}", { d(1, get_visual), i(2) }, math),
    ssnip("(%S+)%s?//(%S+)%s+", "\\faktor{<>}{<>}", { cap(1), cap(2) }, math, 100),
    ssnip("(%b())/", "\\frac{<>}{<>}", { cap(1), d(1, get_visual) }, math),
    ssnip("([%w%d]+)/([%w%d]+)%s", "\\frac{<>}{<>}", { cap(1), cap(1) }, math),
    ssnip("([%w%d]+)/ ", "\\frac{<>}{<>}", { cap(1), d(1, get_visual) }, math),

    --
    ssnip("(%S+)%s?sr", "\\stackrel{<>}{<>}", { i(1), cap(1) }, math),
    ssnip("(%S+)%s?ub", "\\underbrace{<>}_\\tx{<>}", { cap(1), i(1)}, math),

    -- series ---
    ssnip("(%a_?%w?)se", "(<>)", { cap(1) }, math),

    -- map ---
    ssnip("ma%s+(%S+)%s+", "\\from <>\\to ", { cap(1) }, math),

    -- f(x) : f of x
    ssnip("(.*)%s?of%s?(%S+)%s+", "<>(<>)", { cap(1), cap(2) }, math),

    -- Epsilon Ball
    ssnip("(.*%s)be%s?(%S+)%s+", "<>B_{\\varepsilon}(<>)", { cap(1),cap(2) }, math),

    -- derivative
    ssnip("(.*)%s?dif%s?(%S+)%s+", "<>^{(<>)}", { cap(1), cap(2) }, math),

    --1 through n
    ssnip("%s(%S+)%s?tn", "<>_1,\\dots,<>_n", { cap(1), cap(1) }, math),

    table.unpack(snippets),
}
