local M = {}


M.setup = function()
    local autosnippets = {}
    local sources = {
        "greek",
        "junctions",
        "language",
        "mappings",
        "mathbb",
        "operations",
        "quantors",
        "regex",
        "relations",
        "sets",
        "document",
    }

    for _, s in ipairs(sources) do
        vim.list_extend(
            autosnippets,
            require(("fastex.snippets.%s"):format(s))
        )
    end
    require("luasnip").add_snippets("tex", autosnippets)
end

return M
