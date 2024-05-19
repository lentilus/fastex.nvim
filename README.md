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

FasTex adds this hook by default but you can disable it by setting the `break_undo_sequence` to `false` in the setup.

### traversing tabstops / insert nodes

By default all snippets add a tabstop at the end of the expanded snippet.
This is very usefull for traversing your code.
When expanding snippets inside the inser nodes of other snippets it happens, that tabstops from two snippets overlap.
This can be annoying because when you call the normal `ls.jump(1)` your cursor position does not change.
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

This pseudo-code as we have not defined `my_engine` and `not_math` yet.
In theory it could be used to put standalone characters in math mode, so we can type the much shorter `x ` instead of `\$x\$ `.
> In `my_engine` we could make sure not to match `I` and `a` as they are used in "normal" language.

## Custom Trigger Engine

When writing *Tex, we have a lot of context that we can use to determine if an autosnippet should expand, and how it should expand.
This is where writing a custom trigger engine for Luasnip comes into play.

### Default
To get an idea of what a trigger engine does, take a look at the following example. It implements the behaviour of the default engine.

```lua
local function default_matcher(line_to_cursor, trigger)
    local find_res = { line_to_cursor:find(trigger .. "$") }
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
```
Our custom matcher must return the part of the line that matched, as well as all captures.

### don't expand behind backslashes

In LaTex we do not want to expand autosnippets if the word under cursor starts with a backslash.
To achieve that we can just perform a check befor the actual matching to see if the last word starts with a backlash.
If so we abort the match and return `nil`.

```lua
local function latex_matcher(line_to_cursor, trigger)
    local tex_command = { line_to_cursor:find("\\%a*$") }
    if #tex_command > 0 then
        return nil
    end
    local find_res = { line_to_cursor:find(trigger .. "$") }
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
```

### Intro

The goal: Suppose we have a snippet that adds angle bracket around the last expression before the cursor. More concretely

Lets say the current line looks like this
```latex
$ foo + bar - \pi _$
```
And let `_` be the cursor position

We want to be able to press `ag` in order to add angle brackets. So

```latex
$ foo + bar - \pi ag_$
```
should turn into
```latex
$ foo + bar - \langle \pi \rangle_$
```

Now suppose we want to do this not just for `\pi`, but also for `\frac{}{}`, `(2 + i)`, `|x-y|` and so on.

FasTex provides a snippet factory that covers exactly that. I introduce `#` as a special character to match expressions that I call math groups.

```lua
mgsnip("#ag", "\\langle <>\\rangle", { cap(1) }, math)
```

the following sections go into detail about how the matcher behind the `mgsnip` (**m**ath **g**roup **snip**pet) works.

### simple math groups
I devide this section into two parts. I will first talk about groups that are matched via a single `lua pattern` and then about delimiter based matching. To make following along easier, I recommend you get familiar with the basics of lua pattern matching.

I will only sketch the algorithm but please feel free to look at the actual implemtation for the details.
To illustrate the working of the simple group matcher, lets look at the trigger `#%s?%*%s?#%s`.
Suppose the state of our editor is the following
```latex
$ 3 * \frac{\pi}{2} _
```
The matcher now has to determine if our trigger matches or not.

This first step in the matching process is to split the trigger into multiple parts like so:
```lua
subtriggers = { "#", "%s?%*%s?", "#", "%s"}
```

We now start matching the subtriggers against our line from right to left.

1. We match `%s`, so we move the head of our matcher like so:
`$ 3 * \frac{\pi}{2}`|` `

2. the we look at the next subtrigger: `#`. This indicates that we are trying to match a simple math group. Now things get interesting:

The following table contains patterns corresponding to simple math groups. The table is ordered by decending priority.

```lua
local simple_groups = {
    "\\%a+%s?%b{}%s?%b{}", -- \frac{}{}
    "\\%a+%s?%b{}",        -- \bar{}
    "\\%a+",               -- \pi
    "[%a%d]+",
    "%a+",
    "%b<>", "%b||", "%b()", "%b[]",
    "%."
}
```

2. 1. we look at the first pattern: `\\%a+%s?%b{}%s?%b{}`. It matches so we move the head acordingly:

`$ 3 * `|`\frac{\pi}{2} `

3. Now we look at the next subtrigger:

### advanced math groups

