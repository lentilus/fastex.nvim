local ls = require("luasnip")
local i = ls.insert_node
local helper = require("fastex.luasnip_helpers")
local first_word = helper.begin_snip
local snip = helper.std_snip
local math = helper.math
local not_math = helper.not_math
local ri = helper.ri
local line_begin = require("luasnip.extras.expand_conditions").line_begin

local d = ls.dynamic_node

local get_visual = function(args, parent)
    if (#parent.snippet.env.LS_SELECT_RAW > 0) then
        return ls.snippet_node(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
    else -- If LS_SELECT_RAW is empty, return a blank insert node
        return ls.snippet_node(nil, i(1))
    end
end

local envs = {
    {"cc", "cases", math},
    {"ali", "*align", not_math},
    {"qq", "question", not_math},
    {"fla", "flashcard", not_math},
}

local amsthm = {
    {"tem", "theorem", not_math},
    {"pro", "proof", not_math},
    {"axi", "axiom", not_math},
    {"cor", "corrolary", not_math},
    {"lem", "lemma", not_math},
    {"def", "definition", not_math},
    {"exa", "example", not_math},
}

local amsthmstr = [[
\begin{%s}[<>]
    <>
\end{%s}
]]

local envstr = [[
\begin{%s}
    <>
\end{%s}
]]

local env_snippets = {}
for key, val in pairs(envs) do
    local envsnip = first_word( val[1], string.format(envstr, val[2], val[2]), {d(1, get_visual)}, val[3])
    table.insert(env_snippets, envsnip)
end

for key, val in pairs(amsthm) do
    local envsnip = first_word( val[1], string.format(amsthmstr, val[2], val[2]), {i(1),d(2, get_visual)}, val[3])
    table.insert(env_snippets, envsnip)
end

return {
    first_word("ss", "\\section{<>}", { i(1) }, not_math),
    first_word("sus", "\\subsection{<>}", { i(1) }, line_begin),
    first_word("suus", "\\subsubsection{<>}", { i(1) }, line_begin),

    snip("ll", " $<>$ ", { i(1, "math") }, not_math),
    snip("tx", "\\text{ <> } ", { i(1) }, math),

    first_word("dm", [[
    \[
        <>
    .\]
    ]], { i(1) }, not_math),

    snip("beg", [[
    \begin{<>}
        <>
    \end{<>}
    ]], { i(1), i(2), ri(1) }, nil),

    table.unpack(env_snippets),
}
