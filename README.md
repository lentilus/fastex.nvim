# FasTeX

This project expands on the work of Gilles Castel and ejmastnak.
FasTex speed up typesetting in *Tex in nvim with LuaSnip and vimtex.

- a powerful and customizable snippet engine for *Tex specifically.
- useful LuaSnip utilities
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
This is very useful for traversing your code.
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

This is just pseudo-code to illustrate the idea. We have not defined `my_engine` and `not_math` yet.
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

We want to define snippets that are able to manipulate coherent mathematical expressions in a smart way. What do I mean by that?
Lets look at an example:
Suppose we have a snippet that adds angle bracket around the last expression before the cursor.
More concretely: Lets say the current line looks like this

```latex
$ foo + bar - \pi _$
```
And let `_` be the cursor position

We want to define a snippet, so that we can type `ag` in order to add angle brackets around the last expression in this case `pi`. So

```latex
$ foo + bar - \pi ag_$
```
should turn into
```latex
$ foo + bar - \langle \pi \rangle_$
```

Notice, that we do not want to include `foo + bar` in our angle brackets, as `pi` is an atomic expression of its own. In essence we want to capture mathematical expressions, where we can be certain that they are meant to be treated as one object.
This include all kinds of expressions such as:
- `x`
- `ab`
- `f(2x)`
- `\pi`
- `\frac{foo}{bar}^2`
- `\Mat(n \times n; \K)_{i,j}`

Having snippets that can operate on such objects is really powerful. Suppose we can define very general snippets like this one:

```lua
-- an actual snippet in my colllection
-- mgsnip : math group snippet
mgsnip("@,?%s?@sa", "\\langle <>,<>\\rangle", { cap(2), cap(1) }, math)
```

Where `@` is a placeholder for an abitrary mathematical expression.
Then this snippet would allow us to write the dotproduct from two expression very easily in a post-fix style.
If you had not already - I hope you are now getting an idea of how powerful such snippets are, as they allow much more involved handling of expressions than basic regex-trigger snippets.

From now on I will call the mathematical expressions denoted by `@` "groups".
We want to treat groups atomic in the way that they are the largest group that does not make sence splitting further.
(Not stricly mathematically speaking but in terms of content.)

Defining a snippet with said functionality requires the snippet logic to litely take LaTex's syntax into account.

In FasTex I implemented such logic in the from of a custom trigger engine.
The following sections will go into detail about its logic and the ideas behind it.

### simple math groups
Lets first look at simple math groups, denoted by a `#` in the trigger.
These will lie the foundation for working with more complex groups `@`.

There are two ways we can define a simple group.
Either via delimiters that mark the boundaries of the said group or via a lua-pattern that matches the group entirely.
For the following sections a basic understanding of pattern matching in lua is valuable.

#### pattern based math matching

I will only sketch the algorithm but please feel free to look at the actual implemtation for the details.
To illustrate the working of the simple group matcher, lets look at the following trigger:
```lua
trigger = "#%s?%*%s?#%s"
```
Suppose the line we are editing is:
```latex
$ 3 * \frac{\pi}{2} _
```
The matcher now has to determine if our trigger matches or not.

This first step in the matching process is to split the trigger into multiple parts. We want to treat special characters like `#` sperately so we split the string accordingly.
```lua
subtriggers = { "#", "%s?%*%s?", "#", "%s"}
```

We now start matching the subtriggers against our line from right to left.

1. The first subtrigger `%s` matches, so we move the head of our matcher to the left like so:
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
We look at the first pattern: `\\%a+%s?%b{}%s?%b{}`. It matches so we move the head accordingly:
`$ 3 * `|`\frac{\pi}{2} `

3. Now we look at the next subtrigger: `s?%*%s?`. It matches so we move the head accordingly:
`$ 3`|` * \frac{\pi}{2} `

4. The last subtrigger is `#`: We hit a math group again. We try to match patterns from the table in decending priority, as soon as we hit a match, we submit it:

   1. `\\%a+%s?%b{}%s?%b{}` -> no match
   2. `\\%a+%s?%b{}` -> no match
   3. `\\%a+` -> no match
   4. `[%a%d]+` -> **match** -> we move the head accordingly: `$ `|`3 * \frac{\pi}{2} `

All subtriggers matched -> The whole trigger matched -> we return `3 * \frac{\pi}{2} ` as the match.

> We just matched two very different mathematical expressions using a very sane trigger.

With such a trigger engine we can define powerful snippets that make manipulating latex so much nicer!

But there is more:

#### Delimiter based math matching

We now look at a delimiter based matching approach in order to capture expressions like
`\left( ... \right)`, `\rangle ... \langle`, `\begin{...} ... \end{...}`

### advanced math groups

There are cases where simple patterns and delimiter patterns arent versitile enough:

## Predefined Snippets

## My personal configuration

I recommend something like the following configuration with lazy:

```lua
{
    dir = "~/git/fastex.nvim",
    ft = { "latex", "tex" },
    dependencies = {
        {
            "lervag/vimtex",
            init = function()
                -- your vimtex config could go here
            end,
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

        -- FasTeX
        local ft = require("fastex")
        ft.setup()
        vim.keymap.set({ "n", "i", "s" }, "<M-j>", function() ft.smart_jump(1) end)
        vim.keymap.set({ "n", "i", "s" }, "<M-k>", function() ft.smart_jump(-1) end)
    end
}
```
