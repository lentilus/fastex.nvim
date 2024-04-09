local ls = require("luasnip")
local s = ls.snippet
-- local sn = ls.snippet_node
-- local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
-- local d = ls.dynamic_node
-- local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
-- local rep = require("luasnip.extras").rep

local function math()
    return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
end

local function not_math()
    return not math()
end

-- only matches lines that end with a word without "\"
local no_backslash = "(.*%s[^\\]*)"

return {
    -- mathbb in math
    s({
            trig = no_backslash .. "(%A)(%a)mb",
            regTrig = true,
            wordtrig = false,
            snippetType = "autosnippet"
        },
        fmta([[
        <><>\mathbb{<>}
        ]], {
            f(function(_, snip) return snip.captures[1] end),
            f(function(_, snip) return snip.captures[2] end),
            f(function(_, snip) return snip.captures[3] end)
        }),
        { condition = math }
    ),

    -- mathbb in text
    s({
            trig = "(.*%A)(%a)mb",
            regTrig = true,
            wordtrig = false,
            snippetType = "autosnippet"
        },
        fmta([[
        <>$\mathbb{<>}$
        ]], {
            f(function(_, snip) return snip.captures[1] end),
            f(function(_, snip) return snip.captures[2] end),
        }),
        { condition = not_math }
    ),

    -- short mathbb
    s({ trig = "AA", snippetType = "autosnippet" },
        fmta([[\mathbb{A}]], {}), { condition = math }),

    s({ trig = "BB", snippetType = "autosnippet" },
        fmta([[\mathbb{B}]], {}), { condition = math }),

    s({ trig = "CC", snippetType = "autosnippet" },
        fmta([[\mathbb{C}]], {}), { condition = math }),

    s({ trig = "DD", snippetType = "autosnippet" },
        fmta([[\mathbb{D}]], {}), { condition = math }),

    s({ trig = "NN", snippetType = "autosnippet" },
        fmta([[\mathbb{N}]], {}), { condition = math }),

    s({ trig = "RR", snippetType = "autosnippet" },
        fmta([[\mathbb{R}]], {}), { condition = math }),

    s({ trig = "ZZ", snippetType = "autosnippet" },
        fmta([[\mathbb{Z}]], {}), { condition = math }),

    s({ trig = "QQ", snippetType = "autosnippet" },
        fmta([[\mathbb{Q}]], {}), { condition = math }),
}
