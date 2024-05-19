local helper = require("fastex.luasnip_helpers")
local math = helper.math
local mgsnip = helper.mgroup_snip
local cap = helper.cap

return {
    -- subscript
    mgsnip("@j", "<>_", { cap(1) }, math, 200),
    mgsnip("@k", "<>^", { cap(1) }, math, 200),

    -- hinder autofix
    mgsnip("(.*[%^_]{)", "<>", { cap(1) }, math, 201),
    mgsnip("(.*[%^_][%a%d]%s?%s?)", "<>", { cap(1) }, math, 201),
    mgsnip("(%d+)", "<>", { cap(1) }, math, 201),

    -- remove space
    mgsnip("([^\\]*)%s%^(.*)", "<>^<>", { cap(1), cap(2) }, math, 202),
    mgsnip("([^\\]*)%s_(.*)", "<>_<>", { cap(1), cap(2) }, math, 202),

    -- autofix
    mgsnip("(.*)_%s?#%s", "<>_{<>}", { cap(2), cap(1) }, math, 100),
    mgsnip("(.*)%^%s?#%s", "<>^{<>}", { cap(2), cap(1) }, math, 100),
    mgsnip("#(%d)", "<>_<>", { cap(2), cap(1) }, math, 100),
}
