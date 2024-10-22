local M = {}

local get_patterns = require("fastex.group_patterns").get_patterns

M.get_engine = function(group_patterns, delimiter_patterns)
    local simple_groups = get_patterns()
    local delimiters = {}
    local function subtrigs(trigger)
        local ind = {}
        for i in trigger:gmatch "()#" do
            table.insert(ind, i)
        end

        local patterns = {}
        local last_ind = 1

        for i = 1, #ind do
            local pat = string.sub(trigger, last_ind, ind[i] - 1) or nil
            if #pat > 0 then
                table.insert(patterns, pat)
            end
            table.insert(patterns, "#")
            last_ind = ind[i] + 1
        end

        local pat = string.sub(trigger, last_ind, #trigger) or nil
        if #pat > 0 then
            table.insert(patterns, pat)
        end
        return patterns
    end


    local function match_group(line)
        local matches = {}
        for i = 1, #simple_groups do
            matches = { line:find("(" .. simple_groups[i] .. ")%s?$") }
            if #matches > 0 then
                break
            end
        end
        if #matches == 0 then
            return nil
        end
        local captures = {}
        local from = matches[1]
        local match = line:sub(from, #line)
        local remainder = line:sub(1, matches[1] - 1)

        -- collect capture-groups.
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
            -- print("remainder " ..remainder)

            if r == -1 and l == -1 then
                return nil
            end
        end
        -- print("counter ".. counter)
        return match, { match }, remainder
    end

    local function match_sub(line, trig)
        local captures = {}
        if trig == "#" then
            local match = ""
            local remainder = ""
            match, captures, remainder = match_delim(line)
            if match == nil then
                return match_group(line)
            end
            return match, captures, remainder
        end
        local matches = { line:find(trig .. "$") }
        if #matches == 0 then
            return nil
        end
        local match = line:sub(matches[1], #line)
        local remainder = line:sub(1, matches[1] - 1)
        for i = 3, #matches do
            captures[i - 1] = matches[i]
        end
        return match, captures, remainder
    end

    local matcher = function(line, trigger)
        local tex_command = { line:find("\\%a*$") }
        if #tex_command > 0 then
            -- print("not expanding")
            return nil
        end

        local final_match = ""
        local final_captures = {}
        local patterns = subtrigs(trigger)
        local selection = vim.b.LUASNIP_TM_SELECT

        if selection ~= nil then
            for i = 1, #patterns do
                if patterns[i] == "#" then
                    patterns[i] = "#selection"
                    break
                end
            end
        end

        for i = 1, #patterns do
            local pattern = patterns[#patterns - i + 1]
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
                -- print("final " .. remainder .. " |" .. final_match)
            end
        end

        table.insert(final_captures, selection)
        return final_match, final_captures
    end
    return matcher
end

return M
