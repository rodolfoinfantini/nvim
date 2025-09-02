return {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    lazy = false,
    opts = {},
    keys = {
        {
            "<leader>rr",
            function() require("refactoring").select_refactor() end,
            desc = "Select refactor",
            mode = "v",
        }
    }
}
