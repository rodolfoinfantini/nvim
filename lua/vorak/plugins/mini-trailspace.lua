return {
    'echasnovski/mini.trailspace',
    event = { "BufReadPre", "BufNewFile" },
    version = false,
    config = function()
        require('mini.trailspace').setup()
        vim.cmd("command! -nargs=0 Trim :lua MiniTrailspace.trim()")
    end
}
