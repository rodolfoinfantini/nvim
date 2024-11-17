return {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("cyberdream").setup({
            -- Enable transparent background
            transparent = true,

            -- Enable italics comments
            italic_comments = true,

            -- Modern borderless telescope theme - also applies to fzf-lua
            borderless_telescope = true,
        })
    end
}
