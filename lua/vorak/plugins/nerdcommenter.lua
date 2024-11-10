return {
    "preservim/nerdcommenter",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        vim.g.NERDCreateDefaultMappings = 1
        vim.g.NERDSpaceDelims = 1
    end
}
