local helper = require("fastex.luasnip_helpers")
local ls = require("luasnip")
local i = ls.insert_node
local snip = helper.std_snip
local math = helper.math
local not_math = helper.not_math
local f = ls.function_node

local letters = {
    { "a", "alpha" }, { "A", "Alpha" },
    { "b", "beta" }, { "B", "Beta" },
    { "c", "chi" }, { "C", "Chi" },
    { "d", "delta" }, { "D", "Delta" },
    { "e", "varepsilon" }, { "E", "Epsilon" },
    { "g", "gamma" }, { "G", "Gamma" },
    { "h", "phi" }, { "H", "Phi" },
    { "i", "iotta" }, { "I", "Iotta" },
    { "j", "theta" }, { "J", "Theta" },
    { "k", "kappa" }, { "K", "Kappa" },
    { "l", "lambda" }, { "L", "Lambda" },
    { "m", "mu" }, { "M", "Mu" },
    { "n", "nu" }, { "N", "Nu" },
    { "o", "omega" }, { "O", "Omega" },
    { "p", "pi" }, { "P", "Pi" },
    { "q", "eta" }, { "Q", "Eta" },
    { "r", "rho" }, { "R", "Rho" },
    { "s", "sigma" }, { "S", "Sigma" },
    { "t", "tau" }, { "T", "Tau" },
    { "x", "xi" }, { "X", "xi" },
    { "z", "zeta" }, { "Z", "Zeta" },
}

local greek_snippets = {}

for _, val in pairs(letters) do
    local math_snip = snip("(.*);" .. val[1], "<>\\" .. val[2], {
        f(function(_, sp) return sp.captures[1] end),
    }, math)
    local text_snip = snip(";" .. val[1], "$\\" .. val[2] .. "$ ", {}, not_math)
    table.insert(greek_snippets, math_snip)
    table.insert(greek_snippets, text_snip)
end

return {
    unpack(greek_snippets)
}
