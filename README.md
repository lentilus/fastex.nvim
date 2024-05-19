# FasTeX

This project expands on the work of Gilles Castel and ejmastnak.
FasTex speed up typesetting in *Tex in nvim with LuaSnip and vimtex.

- a powerful and customizable snippet engine for *Tex specifically.
- usefull LuaSnip utilities
- tons of predefined auto-snippets

## before we start

I would recommend you get familiar with LuaSnip and nvim in general before reading along. It is helpfull to have some basic understanding of Lua as well, as most code snippets will be in Lua.

As most of my work is based on Gilles Castel and ejmastnak I would recommend you read their blogs first.

## Lets fix some inconviniences

### undo snippet expansion

You will probably want to use auto-snippets almost exclusively because of their speed advantage while typing.
As so you will find yourself in situations where you would like to undo the snippet expansion - pressing u though may undo your entire insert, which is not what you usually want.
LuaSnip features the option to define pre-expansion hooks for all snippets.
We can use this to start a new entry in the undotree before expanding our snippet.
Thus pressing u after a snippets expansion only undoes the expansion itself.

```lua
vim.api.nvim_create_autocmd("User", {
    pattern = "LuasnipPreExpand",
    callback = function()
        vim.api.nvim_feedkeys(vim.api.nvim_eval('"\\<c-G>u"'), "i", true)
    end
})
```

FasTex adds this hook by default but you can disable it by setting the 'break_undo_sequence' to 'false' in the setup.

### traversing tabstops / insert nodes

By default all snippets add a tabstop at the end of the expanded snippet.
This is very usefull for traversing your code.
When expanding snippets inside the inser nodes of other snippets it happens, that tabstops from two snippets overlap.
This can be annoying because when you call the normal 'ls.jump(1)' your cursor position does not change.
To mitigate this, I wrote the below function so you dont have to jump more than once to get to the next "interesting" insert.

```lua
local ls = require("luasnip")
smart_jump = function(length, x, y, tries)
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
        vim.schedule(function() smart_jump(length, x, y, tries) end)
    end
end
```

As you can see the approach is very naiv: we jump until our cursor position has changed.

The smart jump is exposed via

```lua
require("fastex").smart_jump
```

### Factories

When it comes to defining snippets LuaSnip is very powerful - This is great, but makes some snippet defintions a little verbose.
to get rid of some of the boilerplate I define some functions in Lua.


```lua
local ls = require("luasnip")
local fmta = require("luasnip.extras.fmt").fmta
local f = ls.function_node
local s = ls.snippet

local function snip_factory(matcher, type)
    type = type or "autosnippet"
    return function(trig, exp, insert, cond, priority)
        priority = priority or 1000
        return s({
                trig = trig,
                regTrig = true,
                trigEngine = function() return matcher end,
                wordtrig = false,
                priority = priority,
                snippetType = type
            },
            fmta(exp, {
                unpack(insert)
            }),
            { condition = cond }
        )
    end
end

local function cap(i)
    return f(function(_, snip) return snip.captures[i] end)
end

local function ri(insert_node_id)
    return f(function(args) return args[1][1] end, insert_node_id)
end
```

Using these we can define a snippet like so

```lua
local my_snip = snip_factory(my_engine)

-- actual snippet defintion
my_snip("(%w)(%s)", "$<>$<>", { cap(1), cap(2) }, not_math)
```

This pseudo-code as we have not defined 'my_engine' and 'not_math' yet.
In theory it could be used to put standalone characters in math mode, so we can type the much shorter "x " instead of "$x$ ".
> In 'my_engine' we could make sure not to match "I" and "a" as they are used in "normal" language.

## Custom Trigger Engine

When writing *Tex, we have a lot of context that we can use to determine if an autosnippet should expand, and how it should expand.
This is where writing a custom trigger engine for Luasnip comes into play.

### Default
To get an idea of what a trigger engine does, take a look at the following example. It implements the behaviour of the default engine.


### don't expand behind backslashes

### simple math groups

### advanced math groups
