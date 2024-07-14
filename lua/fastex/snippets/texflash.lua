local helper = require("fastex.luasnip_helpers")
local ls = require("luasnip")
local i = ls.insert_node
local start = helper.begin_snip
local f = ls.function_node
local not_math = helper.not_math

-- to generate random ids for flashcards
local function rstring(n)
    local s = ""
    for _ = 1, n do
        local index = math.random(97, 97 + 25 + 10)
        local relative = index - 25 - 97
        if relative > 0 then
            s = s .. string.char(47 + relative)
        else
            s = s .. string.char(index)
        end
    end
    return s
end

local function zettel()
    local filename = vim.fn.expand("%:p")
    local zettelstr = vim.fn.systemlist({ "/home/lentilus/git/xettelkasten-core/src/xettelkasten", "path", "-p", filename })
    [1]
    return zettelstr:gsub("_", " ")
end

return {
    start("fla", "\\begin{flashcard}[<>]{<>}\n<>\n\\end{flashcard}", {
        f(function(_, _) return rstring(8) end),
        f(function(_, _) return zettel() end),
        i(1)
    }, not_math),
}
