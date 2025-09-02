return {
    {
        'echasnovski/mini.trailspace',
        event = { "BufReadPre", "BufNewFile" },
        version = false,
        config = function()
            require('mini.trailspace').setup()
            vim.cmd("command! -nargs=0 Trim :lua MiniTrailspace.trim()")
        end
    },
    {
        'echasnovski/mini.statusline',
        opts = {},
        lazy = false,
    },
    {
        'echasnovski/mini.splitjoin',
        event = { "BufReadPre", "BufNewFile" },
        opts = {},
    },
    {
        'echasnovski/mini.pairs',
        event = { "BufReadPre", "BufNewFile" },
        opts = {},
    },
    {
        'echasnovski/mini.icons',
        opt = {},
        lazy = false,
    },
    {
        'echasnovski/mini.extra',
        event = { "BufReadPre", "BufNewFile" },
        opts = {}
    },
    {
        'echasnovski/mini.comment',
        event = { "BufReadPre", "BufNewFile" },
        opts = {},
    },
}
