# FasTeX

My personal config
````lua
return {
    dir="~/git/fastex.nvim",
    ft = { "latex", "tex" },
    event = "InsertEnter",
    dependencies = {
        {
            "lervag/vimtex",
            init = function()
                vim.g.tex_flavor = "latex"
                vim.g.vimtex_view_method = 'zathura_simple'
                vim.g.vimtex_compiler_method = 'latexmk'
            end
        },
        "L3MON4D3/LuaSnip",
    },
    config = function()
        -- LuaSnip
        local ls = require "luasnip"
        ls.config.set_config {
            history = true,
            updateevents = "TextChanged,TextChangedI",
            enable_autosnippets = true,
            store_selection_keys = "<Tab>"
        }
        vim.keymap.set({ "n", "i", "s" }, "<M-j>", function() ls.jump(1) end)
        vim.keymap.set({ "n", "i", "s" }, "<M-k>", function() ls.jump(-1) end)

        -- FasTeX
        require("fastex").setup()
    end
}
````
