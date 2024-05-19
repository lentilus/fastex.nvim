local M = {}

local stages = {}
stages[1] = { "%d", "" }
stages[2] = { "#" }
stages[3] = {
    "%s?%^%b{}_%b{}",
    "%s?_%b{}%^%b{}",

    "%s?%^%._%b{}",
    "%s?_.%^%b{}",

    "%s?%^%b{}_.",
    "%s?_%b{}%^.",

    "%s?%^._.",
    "%s?_.%^.",

    "%s?%^%b{}",
    "%s?_%b{}",

    "%s?%^.",
    "%s?_.",

    "",
}
stages[4] = { "%b()", "" }
stages[5] = { "%s?" }

-- @ - advanced group (expands to multiple base group based triggers)
-- # - base group

-- prefix # mid #suffix $
-- 1. match suffix
-- 2. match # (base group)
-- 3. match mid
-- 4. match # (base group)
-- 5. match prefix
--
-- exit at any mismatch

local function apply_stage(base, next_stage)
    local new_base = {}
    for i = 1, #base do
        for j = 1, #next_stage do
            table.insert(new_base, next_stage[j] .. base[i])
        end
    end
    return new_base
end

M.get_patterns = function()
    local base = { "" }
    for i = 0, #stages - 1 do
        local stage = #stages - i

        base = apply_stage(base, stages[stage])
    end

    return base
end

-- local p = M.get_patterns()
-- for _, pa in ipairs(p) do
--     print(pa)
-- end

return M
