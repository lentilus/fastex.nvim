local M = {}

local dopts = require("fastex.options")
local ls = require("luasnip")

M.setup = function(opts)
    -- use opts or subsitute defaults if nil
    opts = opts or {}
    opts.group_patterns = opts.group_patterns or dopts.group_patterns
    opts.delimiter_patterns = opts.delimiter_patterns or dopts.delimiter_patterns
    opts.break_undo_sequence = opts.break_undo_sequence or dopts.break_undo_sequence
    opts.snippets = opts.snippets or dopts.snippets

    M.math_group_engine = require("fastex.mathpattern_engine").get_engine(
        opts.group_patterns,
        opts.delimiter_patterns
    )

    -- include snippets
    local autosnippets = {}
    for _, s in ipairs(opts.snippets) do
        vim.list_extend(
            autosnippets,
            require(("fastex.snippets.%s"):format(s))
        )
    end
    require("luasnip").add_snippets("tex", autosnippets)

    -- autocommand for breaking undo sequences
    -- > We can undo snippets expansion with u
    if opts.break_undo_sequence then
        vim.api.nvim_create_autocmd("User", {
            pattern = "LuasnipPreExpand",
            callback = function()
                vim.api.nvim_feedkeys(vim.api.nvim_eval('"\\<c-G>u"'), "i", true)
            end
        })
    end
end

-- we jump until we moved or run out of tabstops
M.smart_jump = function(length, x, y, tries)
    local x2, y2 = unpack(vim.api.nvim_win_get_cursor(0))
    if tries == nil then
        tries = 0
    elseif tries > 10 then
        return
    end

    if x == nil or y == nil then
        x, y = x2, y2
    end

    if x == x2 and y == y2 then
        ls.jump(length)
        tries = tries + 1
        vim.schedule(function() M.smart_jump(length, x, y, tries) end)
    end
end

return M
