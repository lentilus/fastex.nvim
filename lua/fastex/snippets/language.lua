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

    snip("kp ", "K\"orper ", {}, not_math),
    snip("bl ", "beliebig ", {}, not_math),
    snip("vr ", "Vektorraum ", {}, not_math),
    snip("mg ", "Menge ", {}, not_math),
    snip("gp ", "Gruppe ", {}, not_math),
    snip("ug ", "Untergruppe ", {}, not_math),
    snip("pt ", "Punkt ", {}, not_math),
    snip("uvr ", "Untervektorraum ", {}, not_math),
    snip("inj ", "injektiv ", {}, not_math),
    snip("sur ", "surjektiv ", {}, not_math),
    snip("bij ", "bijektiv ", {}, not_math),
    snip("fun ", "Funktion ", {}, not_math),
    snip("abb ", "Abbildung ", {}, not_math),
    snip("iso ", "Isomorphismus ", {}, not_math),
    snip("endo ", "Endomrophismus ", {}, not_math),
    snip("homo ", "Homomorphismus ", {}, not_math),
    snip("home ", "Hom\"oomorphismus ", {}, not_math),
}
