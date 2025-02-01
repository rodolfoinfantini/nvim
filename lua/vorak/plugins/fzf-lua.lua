return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        {
            "<leader>ff",
            "<cmd>lua require('fzf-lua').files()<cr>",
        },
        {
            "<leader>fb",
            "<cmd>lua require('fzf-lua').buffers()<cr>",
        },
        {
            "<leader>fj",
            "<cmd>lua require('fzf-lua').live_grep()<cr>",
        }
    },
    config = function()
        require("fzf-lua").setup({})
    end
}
