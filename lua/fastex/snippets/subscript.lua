local ls = require("luasnip")
local helper = require("fastex.luasnip_helpers")

local ssnip = helper.std_snip
local math = helper.math
local not_math = helper.not_math
local cap = helper.cap
local f = ls.function_node

local snippets = {}

local script_trigs = {
    -- subscript
    {"(.*%w+)j(%S*)", "<>_<>"},
    {"(.*%b())j(%S*)", "<>_<>"},
    {"(.*%b[])j(%S*)", "<>_<>"},
    {"(.*%b{})j(%S*)", "<>_<>"},
    {"(.*%b||)j(%S*)", "<>_<>"},

    --- superscript
    {"(.*%w+)k(%S*)", "<>^<>"},
    {"(.*%b())k(%S*)", "<>^<>"},
    {"(.*%b[])k(%S*)", "<>^<>"},
    {"(.*%b{})k(%S*)", "<>^<>"},
    {"(.*%b||)k(%S*)", "<>^<>"},

    -- auto subscript
    {"(.*%a+)(%d)", "<>_<>"},
    {"(.*%b())(%d)", "<>_<>"},
    {"(.*%b[])(%d)", "<>_<>"},
    {"(.*%b{})(%d)", "<>_<>"},
    {"(.*%b||)(%d)", "<>_<>"},
}

for _, val in pairs(script_trigs) do
    table.insert(snippets, ssnip(val[1], val[2], { cap(1), cap(2) }, math))
end

return {

    ssnip("(%a+)(%d)%s", "$<>_<>$ ", { cap(1), cap(2) }, not_math),
    ssnip("(%a+)%d(%d)%s", "$<>^<>$ ", { cap(1), cap(2) }, not_math),

    -- postfix --
    ssnip("(.*)%^([^{][%w\\%^%b{}]+)%s", "<>^{<>}", { cap(1), cap(2) }, math, 100),
    ssnip("(.*)_([^{][%w\\_{}%b{}]+)%s", "<>_{<>}", { cap(1), cap(2) }, math, 100),
    ssnip("(.*)%^([^{][%w\\%^%b{}]+)(%_.)", "<>^{<>}<>", { cap(1), cap(2), cap(3) }, math, 100),
    ssnip("(.*)_([^{][%w\\_{}%b{}]+)(%^.)", "<>_{<>}<>", { cap(1), cap(2), cap(3) }, math, 100),

    table.unpack(snippets),
}
