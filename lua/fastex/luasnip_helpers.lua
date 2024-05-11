local M = {}

local ls = require("luasnip")
local s = ls.snippet
local ins = ls.insert_node
local sn = ls.snippet_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta

M.math = function() return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1 end
M.not_math = function() return not M.math() end
M.selection = function() return require("luasnip.extras.conditions.show").has_selected_text() end

function M.get_visual(args, parent)
    if (#parent.snippet.env.LS_SELECT_RAW > 0) then
        return sn(nil, ins(1, parent.snippet.env.LS_SELECT_RAW))
    else -- If LS_SELECT_RAW is empty, return a blank insert node
        return sn(nil, ins(1))
    end
end

function M.cap(i)
    return f(function(_, snip) return snip.captures[i] end)
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

-- patterns are matched in this exact order
local groups = {
    "\\%a+%s?%b{}%s?%b{}", -- things like \frac{}{} \stackrel{}{} etc
    "\\%a+%s?%b{}", -- simpler commands like \pi
    "\\left%S.-\\right%S",
    "\\langle.-\\rangle",
    "\\{.-\\}",
    "%b<>",
    "%b||",
    "%b()",
    "%b[]",
    "%a+"
}

local function group_matcher(line_to_cursor, trigger)
    local tex_command = { line_to_cursor:find("\\%a*$") }
    if #tex_command > 0 then
        return nil
    end

    -- if this does not match, no need to check further
    local base = { line_to_cursor:find(trigger .. "$") }
    if #base == 0 then
        return nil
    end

    -- go by selection
    local selection = vim.b.LUASNIP_TM_SELECT
    if selection ~= nil then

        local captures = {}
        local from = base[1]
        local match = line_to_cursor:sub(from, #line_to_cursor)

        -- collect capture-groups.
        captures[1] = selection
        for i = 4, #base do
            captures[i - 2] = base[i]
        end
        return match, captures

    -- go by pattern matching
    else
        local matches = {}
        for _,i in pairs(groups) do
            matches = { line_to_cursor:find("("..i..")%s?".. trigger .. "$") }
            if #matches > 0 then
                break
            end
        end
        if #matches == 0 then
            return nil
        end
        local captures = {}
        local from = matches[1]
        local match = line_to_cursor:sub(from, #line_to_cursor)

        -- collect capture-groups.
        for i = 3, #matches do
            captures[i - 2] = matches[i]
        end
        return match, captures
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


-- encapsulates the boiler plate of snippet helpers
local function snip_factory(matcher, type)
    type = type or "autosnippet"
    return function(trig, exp, insert, cond, priority)
        priority = priority or 1000
        return s({ trig = trig, regTrig = true,
        trigEngine = function() return matcher end,
        wordtrig = false,
        priority = priority,
        snippetType =type },
            fmta(exp, {
                unpack(insert)
            }),
            { condition = cond }
        )
    end
end

M.std_snip = snip_factory(std_matcher)
M.begin_snip = snip_factory(begin_matcher)
M.group_snip = function(trig, exp, insert, cond, priority)
        priority = priority or 1000
        return s({ trig = trig, regTrig = true,
        trigEngine = function() return group_matcher end,
        wordtrig = false,
        priority = priority,
        snippetType = "autosnippet" },
            fmta(exp, {
                unpack(insert)
            }),
            { condition = cond }
        )
    end

return M
