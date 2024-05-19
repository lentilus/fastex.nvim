-- @ - advanced group (expands to multiple base group based triggers)
-- # - base group

-- Example: prefix # mid #suffix $
-- 1. match suffix
-- 2. match # (base group)
-- 3. match mid
-- 4. match # (base group)
-- 5. match prefix
--
-- exit at any mismatch

local M = {}

local get_patterns = require("fastex.group_patterns").get_patterns
local patterns = get_patterns()

local simple_groups = {
    "\\%a+%s?%b{}%s?%b{}", -- \frac{}{}
    "\\%a+%s?%b{}",        -- \bar{}
    "\\%a+",               -- \pi
    "[%a%d]+",
    "%a+",
    "%b<>", "%b||", "%b()", "%b[]",
    "%."
}

local delimiters = {
    { "\\left%S",    "\\right%S" },
    { "\\langle",    "\\rangle" },
    { "\\begin%b{}", "\\end%b{}" },
    { "\\{",         "\\}" },
    { "\\|",         "\\|" },
}

local function split_trigger(trigger)
    local index, pats = {}, {}
    local last_ind = 1
    for i in trigger:gmatch "()[#@]" do
        table.insert(index, i)
    end

    for _, v in ipairs(index) do
        local pattern = string.sub(trigger, last_ind, v - 1) or nil
        if #pattern > 0 then
            table.insert(pats, pattern)
        end
        table.insert(pats, string.sub(trigger, v, v))
        last_ind = v + 1
    end
    if last_ind <= #trigger then
        table.insert(pats, string.sub(trigger, last_ind, #trigger))
    end
    return pats
end

local function match_base_group(line)
    local matches = {}
    local captures = {}
    for i = 1, #simple_groups do
        matches = { line:find("(" .. simple_groups[i] .. ")%s?$") }
        if #matches > 0 then
            break
        end
    end
    if #matches == 0 then
        return nil
    end
    local from = matches[1]
    local match = line:sub(from, #line)
    local remainder = line:sub(1, matches[1] - 1)
    for i = 3, #matches do
        captures[i - 2] = matches[i]
    end
    return match, captures, remainder
end
local function match_delim(line)
    local matches = {}
    local del
    for i = 1, #delimiters do
        matches = { line:find("(" .. delimiters[i][2] .. ")%s?$") }
        if #matches > 0 then
            del = i
            break
        end
    end
    if #matches == 0 then
        return nil
    end
    local remainder = line:sub(1, matches[1] - 1)
    local counter = 1
    local match

    -- future me should rewrite this logic....
    -- cause it sucks a little
    while counter ~= 0 do
        local right = ".*(" .. delimiters[del][2] .. ".-)$"
        local left = ".*(" .. delimiters[del][1] .. ".-)$"

        local rmatches = { remainder:find(right) }
        local lmatches = { remainder:find(left) }

        local r = -1
        local l = -1
        if rmatches[3] ~= nil then
            r = #remainder - #rmatches[3]
        end
        if lmatches[3] ~= nil then
            l = #remainder - #lmatches[3]
        end

        if r > l then
            counter = counter + 1
            remainder = remainder:sub(1, r)
            match = line:sub(r + 1, #line)
        else
            counter = counter - 1
            remainder = remainder:sub(1, l)
            match = line:sub(l + 1, #line)
        end

        if r == -1 and l == -1 then
            return nil
        end
    end
    -- print("counter ".. counter)
    return match, { match }, remainder
end

local function match_sub(line, trig)
    -- print("sub", line, trig)
    local captures = {}
    local match = ""
    local remainder = ""

    -- match complex math
    if trig == "@" then
        for _, p in ipairs(patterns) do
            local sub_patterns = split_trigger(p)
            local sline = line
            for i = 0, #sub_patterns - 1 do
                local sp = sub_patterns[#sub_patterns - i]
                local ma, _, re = match_sub(sline, sp)
                if ma == nil then
                    match = ""
                    remainder = ""
                    break
                end
                match = ma .. match
                sline = re
                remainder = re
            end
            -- print("pattern", p, " remainder ", sline, " |", match)
            if match ~= "" then
                return match, { match }, remainder
            end
        end
        return nil
    elseif trig == "#" then
        local ma, ca, re = match_delim(line)
        if ma ~= nil then
            return ma, ca, re
        end
        return match_base_group(line)
    end

    -- ordinary match
    local matches = { line:find(trig .. "$") }
    if #matches == 0 then
        return nil
    end
    match = line:sub(matches[1], #line)
    remainder = line:sub(1, matches[1] - 1)
    for i = 3, #matches do
        captures[i - 1] = matches[i]
    end
    return match, captures, remainder
end


local matcher = function(line, trigger)
    local tex_command = { line:find("\\%a*$") }
    if #tex_command > 0 then
        return nil
    end

    local final_match = ""
    local final_captures = {}
    local split_patterns = split_trigger(trigger)
    local selection = vim.b.LUASNIP_TM_SELECT

    if selection ~= nil then
        for i = 1, #split_patterns do
            if split_patterns[i] == "#" or split_patterns[i] == "@" then
                split_patterns[i] = "#selection"
                break
            end
        end
    end

    for i = 1, #split_patterns do
        local pattern = split_patterns[#split_patterns - i + 1]
        if pattern ~= "#selection" then
            local match, captures, remainder = match_sub(line, pattern)
            if match == nil then
                return nil
            end
            for j = 1, #captures do
                table.insert(final_captures, captures[j])
            end
            final_match = match .. final_match
            line = remainder
        end
    end

    table.insert(final_captures, selection)
    return final_match, final_captures
end

M.get_engine = function()
    return matcher
end

-- a, b, c = matcher("hallo ballo_i^{ab}", "hallo @")
-- print("final match ", a)


return M
