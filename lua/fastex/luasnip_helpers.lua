local M = {}

local ls = require("luasnip")
local s = ls.snippet
local ins = ls.insert_node
local sn = ls.snippet_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta
M.insert = ls.insert_node

M.line_begin = require("luasnip.extras.expand_conditions").line_begin

M.math = function()
    return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
end

function M.not_math()
    return not M.math()
end

function M.get_visual(args, parent)
    if (#parent.snippet.env.LS_SELECT_RAW > 0) then
        return sn(nil, ins(1, parent.snippet.env.LS_SELECT_RAW))
    else -- If LS_SELECT_RAW is empty, return a blank insert node
        return sn(nil, ins(1))
    end
end

-- Repeat Insernode text
-- @param insert_node_id The id of the insert node to repeat (the first line from)
function M.ri(insert_node_id)
    return f(function(args) return args[1][1] end, insert_node_id)
end

function M.line_start(trig, exp, insert, cond)
    return s({
            trig = "^([^\\]*)" .. trig,
            regTrig = true,
            wordtrig = false,
            snippetType = "autosnippet"
        },
        fmta("<>" .. exp, {
            f(function(_, snip) return snip.captures[1] end),
            unpack(insert) }),
        { condition = cond }
    )
end

local no_backslash = "(.*%A[^\\]*)"
function M.line_running(trig, exp, insert, cond)
    return s({
            trig = no_backslash .. trig,
            regTrig = true,
            wordtrig = false,
            snippetType = "autosnippet"
        },
        fmta("<>" .. exp, {
            f(function(_, snip) return snip.captures[1] end),
            unpack(insert)
        }),
        { condition = cond }
    )
end

function M.first_word(trig, exp, insert, cond)
    return s({
            trig = "^%s*" .. trig,
            regTrig = true,
            wordtrig = false,
            snippetType = "autosnippet"
        },
        fmta(exp, {
            unpack(insert)
        }),
        { condition = cond }
    )
end

local function std_matcher(line_to_cursor, trigger)
    -- look for match which ends at the cursor.
    -- put all results into a list, there might be many capture-groups.
    local find_res = { line_to_cursor:find(trigger .. "$") }
    local check_against = { line_to_cursor:find("\\%a*" .. trigger .. "$") }

    -- check if \command was technically terminated like \command{foo}
    local control = { line_to_cursor:find("\\%a*" .. "$") }

    if #check_against > 0 and #control > 0 then
        return nil
    end

    print()

    if #find_res > 0 then
        print(#control)
        -- if there is a match, determine matching string, and the
        -- capture-groups.
        local captures = {}
        -- find_res[1] is `from`, find_res[2] is `to` (which we already know
        -- anyway).
        local from = find_res[1]
        local match = line_to_cursor:sub(from, #line_to_cursor)
        -- collect capture-groups.
        for i = 3, #find_res do
            captures[i - 2] = find_res[i]
        end
        return match, captures
    else
        return nil
    end
end

local function std_engine(trigger)
    -- don't do any special work here, can't precompile lua-pattern.
    return std_matcher
end

local function begin_matcher(line_to_cursor, trigger)
    -- look for match which ends at the cursor.
    -- put all results into a list, there might be many capture-groups.
    local find_res = { line_to_cursor:find("^%s*" .. trigger) }

    if #find_res > 0 then
        -- if there is a match, determine matching string, and the
        -- capture-groups.
        local captures = {}
        -- find_res[1] is `from`, find_res[2] is `to` (which we already know
        -- anyway).
        local from = find_res[1]
        local match = line_to_cursor:sub(from, #line_to_cursor)
        -- collect capture-groups.
        for i = 3, #find_res do
            captures[i - 2] = find_res[i]
        end
        return match, captures
    else
        return nil
    end
end

local function begin_engine(trigger)
    -- don't do any special work here, can't precompile lua-pattern.
    return begin_matcher
end

function M.std_snip(trig, exp, insert, cond)
    return s({ trig = trig, regTrig = true, trigEngine = std_engine, wordtrig = false, snippetType = "autosnippet" },
        fmta(exp, {
            unpack(insert)
        }),
        { condition = cond }
    )
end

function M.begin_snip(trig, exp, insert, cond)
    return s({ trig = trig, regTrig = true, trigEngine = begin_engine, wordtrig = false, snippetType = "autosnippet" },
        fmta(exp, {
            unpack(insert)
        }),
        { condition = cond }
    )
end

return M
