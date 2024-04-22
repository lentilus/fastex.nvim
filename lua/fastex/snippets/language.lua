local helper = require("fastex.luasnip_helpers")
local snip = helper.std_snip
local math = helper.math
local not_math = helper.not_math

return {
    snip("sd", "\\tx{s.d.} ", {}, math),
    snip("mit", "\\tx{mit} ", {}, math),
    snip("also", "\\tx{also} ", {}, math),
    snip("wobei", "\\tx{wobei} ", {}, math),
    snip("wenn", "\\tx{ wenn} ", {}, math),
    snip("fl", "\\tx{falls} ", {}, math),
    snip("aber", "\\tx{falls} ", {}, math),

    snip("kp", "K\"orper ", {}, not_math),
    snip("vr", "K\"orper ", {}, not_math),
    snip("mg", "K\"orper ", {}, not_math),
    snip("gp", "K\"orper ", {}, not_math),
    snip("ug", "K\"orper ", {}, not_math),
    snip("pt", "K\"orper ", {}, not_math),
    snip("uvr", "K\"orper ", {}, not_math),
    snip("inj", "K\"orper ", {}, not_math),
    snip("sur", "K\"orper ", {}, not_math),
    snip("bij", "K\"orper ", {}, not_math),
    snip("fun", "K\"orper ", {}, not_math),
    snip("abb", "K\"orper ", {}, not_math),
    snip("iso", "K\"orper ", {}, not_math),
    snip("end", "K\"orper ", {}, not_math),
    snip("homo", "K\"orper ", {}, not_math),
    snip("home", "K\"orper ", {}, not_math),
}
