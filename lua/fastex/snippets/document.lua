local helper = require("fastex.luasnip_helpers")
local ls = require("luasnip")
local i = ls.insert_node
local snip = helper.std_snip
local math = helper.math
local not_math = helper.not_math
local ri = helper.ri
local d = ls.dynamic_node

local get_visual = function(_, parent)
    if (#parent.snippet.env.LS_SELECT_RAW > 0) then
        return ls.snippet_node(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
    else -- If LS_SELECT_RAW is empty, return a blank insert node
        return ls.snippet_node(nil, i(1))
    end
end

local envs = {
    {"cc", "cases", math},
    {"ali", "align*", not_math},
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
for _, val in pairs(envs) do
    local envsnip = snip( val[1], string.format(envstr, val[2], val[2]), {d(1, get_visual)}, val[3])
    table.insert(env_snippets, envsnip)
end

for _, val in pairs(amsthm) do
    local envsnip = snip( val[1], string.format(amsthmstr, val[2], val[2]), {i(1),d(2, get_visual)}, val[3])
    table.insert(env_snippets, envsnip)
end

return {
    snip("ss", "\\section{<>}", { i(1) }, not_math),
    snip("sus", "\\subsection{<>}", { i(1) }, not_math),
    snip("suus", "\\subsubsection{<>}", { i(1) }, not_math),

    snip("ll", " $<>$ ", { i(1, "math") }, not_math),
    snip("tx", "\\tx{ <> } ", { i(1) }, math),

    snip("dm", [[
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
