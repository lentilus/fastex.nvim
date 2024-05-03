local ls = require("luasnip")
local helper = require("fastex.luasnip_helpers")

local ssnip = helper.std_snip
local math = helper.math
local not_math = helper.not_math
local f = ls.function_node

local snippets = {}

local script_trigs = {
    -- subscript
    {"(.*%w+)j(%S*)", "<>_<>"},
    {"(.*%b())j(%S*)", "<>_<>"},
    {"(.*%b[])j(%S*)", "<>_<>"},
    {"(.*%b{})j(%S*)", "<>_<>"},

    --- superscript
    {"(.*%w+)k(%S*)", "<>^<>"},
    {"(.*%b())k(%S*)", "<>^<>"},
    {"(.*%b[])k(%S*)", "<>^<>"},
    {"(.*%b{})k(%S*)", "<>^<>"},

    -- auto subscript
    {"(.*%a+)(%d)", "<>_<>"},
    {"(.*%b())(%d)", "<>_<>"},
    {"(.*%b[])(%d)", "<>_<>"},
    {"(.*%b{})(%d)", "<>_<>"},
}

for _, val in pairs(script_trigs) do
    local snippet = ssnip(val[1], val[2], {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
    }, math)

    table.insert(snippets, snippet)
end

return {

    ssnip("(%a+)(%d)%s", "$<>_<>$ ", {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
    }, not_math),

    ssnip("(%a+)%d(%d)%s", "$<>^<>$ ", {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
    }, not_math),

    -- postfix --
    ssnip("(.*)%^([^{][%w\\%^%b{}]+)%s", "<>^{<>}", {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
    }, math, 100),

    ssnip("(.*)_([^{][%w\\_{}%b{}]+)%s", "<>_{<>}", {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
    }, math, 100),

    ssnip("(.*)%^([^{][%w\\%^%b{}]+)(%_.)", "<>^{<>}<>", {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
        f(function(_, snip) return snip.captures[3] end),
    }, math, 100),

    ssnip("(.*)_([^{][%w\\_{}%b{}]+)(%^.)", "<>_{<>}<>", {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
        f(function(_, snip) return snip.captures[3] end),
    }, math, 100),

    table.unpack(snippets),
}
