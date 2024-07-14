local M = {}

M.snippets = {
    "math",
    "greek",
    "language",
    "mathbb",
    "regex",
    "document",
    "matrix",
    "subscript",
    "texflash"
}

M.group_patterns = {
    "\\%a+%s?%b{}%s?%b{}", -- \frac{}{}
    "\\%a+%s?%b{}",        -- \bar{}
    "\\%a+",               -- \pi
    "[%a%d]+",
    -- "%a+_%a",
    -- "%a+%^%a",
    "%a+",
    "%b<>", "%b||", "%b()", "%b[]",
}

M.delimiter_patterns = {
    { "\\left%S",    "\\right%S" },
    { "\\langle",    "\\rangle" },
    { "\\begin%b{}", "\\end%b{}" },
    { "\\{.",        "\\}" },
    { "\\|.",        "\\|" },
}

M.break_undo_sequence = true

return M
