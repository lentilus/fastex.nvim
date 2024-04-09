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

-- local get_visual = function(args, parent)
--   if (#parent.snippet.env.LS_SELECT_RAW > 0) then
--     return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
--   else  -- If LS_SELECT_RAW is empty, return a blank insert node
--     return sn(nil, i(1))
--   end
-- end

-- only matches lines that end with a word without "\"
-- local no_backslash = "(.*%s[^\\]*)"

return {
    -- alpha
	s({trig = "'a", snippetType = "autosnippet"},
    fmta([[\alpha ]], {}), {condition=math}),

	s({trig = "'a", snippetType = "autosnippet"},
    fmta([[$\alpha$ ]], {}), {condition=not_math}),

    -- beta
	s({trig = "'b", snippetType = "autosnippet"},
    fmta([[\beta ]], {}), {condition=math}),

	s({trig = "'b", snippetType = "autosnippet"},
    fmta([[$\beta$ ]], {}), {condition=not_math}),

    -- tau
	s({trig = "'t", snippetType = "autosnippet"},
    fmta([[\tau ]], {}), {condition=math}),

	s({trig = "'t", snippetType = "autosnippet"},
    fmta([[$\tau$ ]], {}), {condition=not_math}),

    -- gamma
	s({trig = "'g", snippetType = "autosnippet"},
    fmta([[\gamma ]], {}), {condition=math}),

	s({trig = "'G", snippetType = "autosnippet"},
    fmta([[\Gamma ]], {}), {condition=math}),

	s({trig = "'g", snippetType = "autosnippet"},
    fmta([[$\gamma$ ]], {}), {condition=not_math}),

	s({trig = "'G", snippetType = "autosnippet"},
    fmta([[$\gamma$ ]], {}), {condition=not_math}),

    -- delta
	s({trig = "'d", snippetType = "autosnippet"},
    fmta([[\delta ]], {}), {condition=math}),

	s({trig = "'D", snippetType = "autosnippet"},
    fmta([[\Delta ]], {}), {condition=math}),

	s({trig = "'d", snippetType = "autosnippet"},
    fmta([[$\delta$ ]], {}), {condition=not_math}),

	s({trig = "'D", snippetType = "autosnippet"},
    fmta([[$\Delta$ ]], {}), {condition=not_math}),

    -- epsilon
	s({trig = "'e", snippetType = "autosnippet"},
    fmta([[\varepsilon ]], {}), {condition=math}),

	s({trig = "'e", snippetType = "autosnippet"},
    fmta([[$\varepsilon $]], {}), {condition=not_math}),

    -- zeta
	s({trig = "'z", snippetType = "autosnippet"},
    fmta([[\zeta ]], {}), {condition=math}),

	s({trig = "'z", snippetType = "autosnippet"},
    fmta([[$\zeta $]], {}), {condition=not_math}),

    -- eta
	s({trig = "'n", snippetType = "autosnippet"},
    fmta([[\eta ]], {}), {condition=math}),

	s({trig = "'n", snippetType = "autosnippet"},
    fmta([[$\eta $]], {}), {condition=not_math}),

    -- eta
	s({trig = "'m", snippetType = "autosnippet"},
    fmta([[\mu ]], {}), {condition=math}),

	s({trig = "'m", snippetType = "autosnippet"},
    fmta([[$\mu $]], {}), {condition=not_math}),

    -- lambda
	s({trig = "'l", snippetType = "autosnippet"},
    fmta([[\lambda ]], {}), {condition=math}),

	s({trig = "'l", snippetType = "autosnippet"},
    fmta([[$\lambda $]], {}), {condition=not_math}),

    -- xi
	s({trig = "'x", snippetType = "autosnippet"},
    fmta([[\xi ]], {}), {condition=math}),

	s({trig = "'x", snippetType = "autosnippet"},
    fmta([[$\xi $]], {}), {condition=not_math}),

    -- pi
	s({trig = "pi", snippetType = "autosnippet"},
    fmta([[\pi ]], {}), {condition=math}),

	s({trig = "Pi", snippetType = "autosnippet"},
    fmta([[\Pi ]], {}), {condition=math}),

	s({trig = "'l", snippettype = "autosnippet"},
    fmta([[$\pi $]], {}), {condition=not_math}),

	s({trig = "Pi", snippetType = "autosnippet"},
    fmta([[$\Pi $]], {}), {condition=not_math}),
}
