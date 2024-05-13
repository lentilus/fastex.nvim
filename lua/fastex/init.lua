local M = {}

M.setup = function()
    local autosnippets = {}
    local sources = {
        "math",
        "greek",
        "language",
        "mathbb",
        "regex",
        "document",
        "matrix",
        -- "subscript"
    }

    for _, s in ipairs(sources) do
        vim.list_extend(
            autosnippets,
            require(("fastex.snippets.%s"):format(s))
        )
    end
    require("luasnip").add_snippets("tex", autosnippets)

    vim.api.nvim_create_autocmd("User", {
        pattern = "LuasnipPreExpand",
        callback = function()
            vim.api.nvim_feedkeys(vim.api.nvim_eval('"\\<c-G>u"') , "i", true)
            -- print("expanding")
        end
    })
end

return M
