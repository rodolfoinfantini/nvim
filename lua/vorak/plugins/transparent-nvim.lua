return {
    "xiyaowong/transparent.nvim",
    priority = 998,
    config = function()
        require("transparent").setup({
            groups = {
                'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
                'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
                'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
                'SignColumn', 'CursorLineNr', 'EndOfBuffer',
            },
            extra_groups = {
                "NormalFloat",
                "NvimTreeNormal",
                "NvimTreeEndOfBuffer",
                "OilDir",
            },
            exclude_groups = {
                'CocSymbolLine',
                'CocSymbolLineSeparator',
                'CocSymbolLineEllipsis',
            },
        })
    end
}
