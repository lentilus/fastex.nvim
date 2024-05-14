local helper = require("fastex.luasnip_helpers")
local math = helper.math
local mgsnip = helper.mgroup_snip
local cap = helper.cap

return {
    -- subscript
    mgsnip("#j", "<>_", { cap(1) }, math),
    mgsnip("#k", "<>^", { cap(1) }, math),
    mgsnip("#(%d)", "<>_<>", { cap(2),cap(1) }, math, 100),

    -- hinder autofix
    -- mgsnip("(.*[%^_]{)", "<>", { cap(1) }, math),
    -- mgsnip("(.*[%^_][%a%d]%s?%s?)", "<>", { cap(1) }, math),

    -- autofix
    -- mgsnip("(.*)_%s?#%s", "<>_{<>}", { cap(2), cap(1) }, math, 100),
    -- mgsnip("(.*)%^%s?#%s", "<>_{<>}", { cap(2), cap(1) }, math, 100),
}
