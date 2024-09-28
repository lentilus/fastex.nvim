local ls = require("luasnip")
local helper = require("fastex.luasnip_helpers")
local snip = helper.std_snip
local math = helper.math
local not_math = helper.not_math
local get_visual = helper.get_visual
local mgsnip = helper.mgroup_snip
local bsnip = helper.bsnip
local cap = helper.cap
local i = ls.insert_node
local d = ls.dynamic_node

local snippets = {}

local postdelim = {
	{ "iv", "", "^{-1}" },
	{ "vi", "\\frac{1}{", "}" },
	{ "rb", "(", ")" },
	{ "sq", "[", "]" },
	{ "abs", "|", "|" },
	{ "ht", "\\hat{", "}" },
	{ "br", "\\bar{", "}" },
	{ "ul", "\\underline{", "}" },
	{ "dt", "\\dot{", "}" },
	{ "ci", "\\mathring{", "}" },
	{ "cc", "", "^C" },
	{ "vv", "\\vec{", "}" },
	{ "td", "\\tilde{", "}" },
	{ "nr", "\\norm{", "}" },
	{ "rt", "\\sqrt{", "}" },
	{ "ag", "\\langle ", "\\rangle" },
	{ "lr", "\\left(", "\\right)" },
	{ "sl", "\\", "" },
}

for _, val in pairs(postdelim) do
	table.insert(snippets, mgsnip("@" .. val[1], val[2] .. "<>" .. val[3], { cap(1) }, math))
end

return {
	-- tuple stuff --
	mgsnip("@,?%s?@tt", "(<>,<>)", { cap(2), cap(1) }, math),
	mgsnip("@,?%s?@dd", "d(<>,<>)", { cap(2), cap(1) }, math),
	mgsnip("@,?%s?@sa", "\\langle <>,<>\\rangle", { cap(2), cap(1) }, math),
	mgsnip("@ cili", "kilian mag <>", { cap(1) }, math),

	-- fractions --
	snip("ff", "\\frac{<>}{<>}", { d(1, get_visual), i(2) }, math),
	mgsnip("@/%s", "\\frac{<>}{<>}", { cap(1), i(1) }, math),
	mgsnip("@/@%s", "\\frac{<>}{<>}", { cap(2), cap(1) }, math),
	mgsnip("@//%s", "\\faktor{<>}{<>}", { cap(1), i(1) }, math),
	mgsnip("@%s?//@%s%s+", "\\faktor{<>}{<>}", { cap(2), cap(1) }, math, 100),

	-- annotation --
	mgsnip("#sr", "\\stackrel{<>}{<>}", { i(1), cap(1) }, math),
	mgsnip("#ub", "\\underbrace{<>}_\\tx{<>}", { cap(1), i(1) }, math),

	snip("bb", "(<>)", { i(1) }, math), -- fast brackets
	snip("([b-zB-HJ-Z])(%s)", "$<>$<>", { cap(1), cap(2) }, not_math), -- vars in text
	-- snip("(%a_?%w?)se", "(<>)", { cap(1) }, math), -- series -- obsolete because of rb
	snip("ma%s+(%S+)%s+", "\\from <>\\to ", { cap(1) }, math), -- map
	mgsnip("(.-)%s?of%s?@%s", "<>(<>)", { cap(2), cap(1) }, math), -- f of x
	mgsnip("be%s?@%s", "B_{\\varepsilon}(<>)", { cap(1) }, math), -- epsiolon ball
	mgsnip("con%s@%s", "\\constrain{<>}", { cap(1) }, math), -- epsiolon ball
	mgsnip("(.*)pt%s?@%s@%s", "<>\\frac{\\partial <>}{\\partial <>}", { cap(3), cap(2), cap(1) }, math), -- df/dx
	snip("(.*)%s?dif%s?(%S+)%s+", "<>^{(<>)}", { cap(1), cap(2) }, math), -- derivative
	mgsnip("(.*)@%s?til(%w)", "<> <>_1,\\dots,<>_<>", { cap(3), cap(2), cap(2), cap(1) }, math, 1000), -- 1,...,n

	unpack(snippets),
}
