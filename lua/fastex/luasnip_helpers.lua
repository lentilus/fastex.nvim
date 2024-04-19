local M = {}

local ls = require("luasnip")
local s = ls.snippet
local ins = ls.insert_node
local sn = ls.snippet_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta

M.math = function() return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1 end
function M.not_math() return not M.math() end

function M.get_visual(args, parent)
    if (#parent.snippet.env.LS_SELECT_RAW > 0) then
        return sn(nil, ins(1, parent.snippet.env.LS_SELECT_RAW))
    else -- If LS_SELECT_RAW is empty, return a blank insert node
        return sn(nil, ins(1))
    end
end

function M.ri(insert_node_id)
    return f(function(args) return args[1][1] end, insert_node_id)
end

local function std_matcher(line_to_cursor, trigger)
    local tex_command = { line_to_cursor:find("\\%a*$") }
    if #tex_command > 0 then
        return nil
    end

    -- capture actual match
    local find_res = { line_to_cursor:find(trigger .. "$") }
    if #find_res > 0 then
        local captures = {}
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

local function begin_matcher(line_to_cursor, trigger)
    local find_res = { line_to_cursor:find("^%s*" .. trigger) }

    if #find_res > 0 then
        local captures = {}
        local from = find_res[1]
        local match = line_to_cursor:sub(from, #line_to_cursor)
        for i = 3, #find_res do
            captures[i - 2] = find_res[i]
        end
        return match, captures
    else
        return nil
    end
end

function M.std_snip(trig, exp, insert, cond)
    return s({ trig = trig, regTrig = true,
    trigEngine = function() return std_matcher end,
    wordtrig = false,
    snippetType = "autosnippet" },
        fmta(exp, {
            unpack(insert)
        }),
        { condition = cond }
    )
end

function M.begin_snip(trig, exp, insert, cond)
    return s({ trig = trig,
    regTrig = true,
    trigEngine = function() return begin_matcher end,
    wordtrig = false,
    snippetType = "autosnippet" },
        fmta(exp, {
            unpack(insert)
        }),
        { condition = cond }
    )
end

return M
