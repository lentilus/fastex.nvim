local helper = require("fastex.luasnip_helpers")
local snip = helper.std_snip
local math = helper.math

return {
    snip("fa", "\\forall ", {}, math),
    snip("ex", "\\exists ", {}, math),
    snip("in", "\\in ", {}, math),
    snip("ni", "\\not\\in ", {}, math),
}
