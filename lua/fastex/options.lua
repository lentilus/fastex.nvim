local M = {}

M.snippets = {
    "math",
    "greek",
    "language",
    "mathbb",
    "regex",
    "document",
    "matrix",
    "subscript"
}

M.group_patterns = {
    "\\%a+%s?%b{}%s?%b{}", -- things like \frac{}{} \stackrel{}{} etc
    "\\%a+%s?%b{}",        -- simpler commands like \pi
    "%b<>",
    "%b||",
    "%b()",
    "%b[]",
    "\\%a+",
    "[%a%d]+",
    "%a+_%a",
    "%a+%^%a",
    "%a+",
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
