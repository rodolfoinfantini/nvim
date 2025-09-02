return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        automatic_enable = {
            exclude = {
                "jdtls",
                "roslyn"
            }
        }
    },
    dependencies = {
        "mason-org/mason.nvim",
        "neovim/nvim-lspconfig",
    },
}
