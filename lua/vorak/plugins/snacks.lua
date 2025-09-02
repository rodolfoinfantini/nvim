return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        bigfile = { enabled = true },
        indent = { enabled = true },
        picker = {
            enabled = true,
            ui_select = true
        },
        notifier = { enabled = true },
        lazygit = { enabled = true },
        scope = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        quickfile = { enabled = true },
        input = { enabled = true },
    },
    keys = {
        -- Picker
        { "<leader>ff", function() Snacks.picker.files() end,                 desc = "Smart Find Files" },
        { "<leader>,",  function() Snacks.picker.buffers() end,               desc = "Buffers" },
        { "<leader>fj", function() Snacks.picker.grep() end,                  desc = "Grep" },
        { "<leader>:",  function() Snacks.picker.command_history() end,       desc = "Command History" },
        { "<leader>n",  function() Snacks.picker.notifications() end,         desc = "Notification History" },

        -- Lazygit
        { "<leader>gg", function() Snacks.lazygit() end,                      desc = "Lazygit" },

        -- LSP
        { "gd",         function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition" },
        { "gD",         function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration" },
        { "gr",         function() Snacks.picker.lsp_references() end,        nowait = true,                  desc = "References" },
        { "gi",         function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation" },
        { "gy",         function() Snacks.picker.lsp_type_definitions() end,  desc = "Goto T[y]pe Definition" },
        { "<leader>ss", function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
        { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    }
}
