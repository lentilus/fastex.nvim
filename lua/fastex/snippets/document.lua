local helper = require("fastex.luasnip_helpers")
local ls = require("luasnip")
local i = ls.insert_node
local snip = helper.std_snip
local start = helper.begin_snip
local get_visual = helper.get_visual
local math = helper.math
local not_math = helper.not_math
local ri = helper.ri
local d = ls.dynamic_node

local envs = {
	{ "cc", "cases", math },
	{ "ali", "align*", not_math },
	{ "qq", "question", not_math },
	{ "enum", "enumerate", not_math },
	{ "item", "itemize", not_math },
}

local amsthm = {
	{ "tem", "theorem", not_math },
	{ "pro", "proof", not_math },
	{ "axi", "axiom", not_math },
	{ "cor", "corollary", not_math },
	{ "lem", "lemma", not_math },
	{ "def", "definition", not_math },
	{ "exa", "example", not_math },
	{ "rem", "remark", not_math },
}

local amsthmstr = "\\begin{%s}[<>]\n<>\n\\end{%s}"
local envstr = "\\begin{%s}\n<>\n\\end{%s}"

local env_snippets = {}
for _, val in pairs(envs) do
	local envsnip = start(val[1], string.format(envstr, val[2], val[2]), { d(1, get_visual) }, val[3])
	table.insert(env_snippets, envsnip)
end

for _, val in pairs(amsthm) do
	local envsnip = start(val[1], string.format(amsthmstr, val[2], val[2]), { i(1), d(2, get_visual) }, val[3])
	table.insert(env_snippets, envsnip)
end

return {
	start("ss", "\\section{<>}", { i(1) }, not_math),
	start("sus", "\\subsection{<>}", { i(1) }, not_math),
	start("suus", "\\subsubsection{<>}", { i(1) }, not_math),
	start("dm", "\\[\n<>\n.\\]", { i(1) }, not_math),
	start("beg", "\\begin{<>}\n<>\n\\end{<>}", { i(1), i(2), ri(1) }, nil),
	start("end", "\\end{<>}\n", { i(1) }, nil),
	start("pac", "\\usepackage{<>}\n", { i(1) }, not_math),
	snip("ll", " $<>$ ", { i(1, "math") }, not_math),
	snip("ip", " $\\implies$ ", {}, not_math),
	snip("tx", "\\tx{<>} ", { i(1) }, math),
	start("%-%-", "\\item ", {}, not_math),
	snip("%-%-", "\n\n\\item ", {}, not_math, 100),

	unpack(env_snippets),
}
