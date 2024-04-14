local helper = require("fastex.luasnip_helpers")
local ls = require("luasnip")
local i = ls.insert_node
local snip = helper.std_snip
local math = helper.math
local d = ls.dynamic_node
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local f = ls.function_node
local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt

-- generating function
local mat = function(_, sp)
    local rows = tonumber(sp.captures[1])
    local cols = tonumber(sp.captures[2])
    local nodes = {}
    local ins_indx = 1
    for j = 1, rows do
        if j == 1 then
            table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1, "1")))
        else
            table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1, " ")))
        end
        ins_indx = ins_indx + 1
        for k = 2, cols do
            table.insert(nodes, t(" & "))
            if j == k then
                table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1, "1")))
            else
                table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1, " ")))
            end
            ins_indx = ins_indx + 1
        end
        table.insert(nodes, t({ " \\\\", "" }))
    end
    -- fix last node.
    nodes[#nodes] = t(" \\\\")
    return sn(nil, nodes)
end

local lmat = function(_, sp)
    local rows = tonumber(sp.captures[1])
    local cols = tonumber(sp.captures[2])
    local nodes = {}
    local ins_indx = 1
    for j = 1, rows do
        if j == rows then
            print("j: " .. j)
            for k=1, cols+1 do
                if k == cols then
                    table.insert(nodes, t(" \\ddots & "))
                else
                    table.insert(nodes, t(" \\vdots & "))
                end
            end
            table.insert(nodes, t({ " \\\\", "" }))
        end
        if j == 1 then
            table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1, "1")))
        else
            table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1, "0")))
        end
        ins_indx = ins_indx + 1
        for k = 2, cols do
            print("k: " ..k)
            table.insert(nodes, t("       & "))
            if k == cols then
                table.insert(nodes, t(" \\dots  & "))
            end
            if j == k then
                table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1, "1")))
            else
                table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1, "0")))
            end
            ins_indx = ins_indx + 1
        end
        table.insert(nodes, t({ " \\\\", "" }))
    end
    -- fix last node.
    print("fixing last node")
    nodes[#nodes] = t(" \\\\")
    return sn(nil, nodes)
end

return {
    snip("(%d)(%d)ma",[[
        \begin{pmatrix}
        <>
        \end{pmatrix}]], {
        d(1,mat),
        }, math),
    snip("(%d)(%d)lma",[[
        \begin{pmatrix}
        <>
        \end{pmatrix}]], {
        d(1,lmat),
        }, math),
    }

