return {
    'mfussenegger/nvim-dap',
    dependencies = {
        "theHamsta/nvim-dap-virtual-text",
        "neovim/nvim-lspconfig",
        "igorlfs/nvim-dap-view",
        "jay-babu/mason-nvim-dap.nvim",
    },
    keys = {
        { "<leader>d",  "",                                                            desc = "+debug",                 mode = { "n", "v" } },
        -- { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
        { "<leader>b",  function() require("dap").toggle_breakpoint() end,             desc = "Toggle Breakpoint" },
        { "<F9>",       function() require("dap").continue() end,                      desc = "Run/Continue" },
        { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
        { "<leader>dC", function() require("dap").run_to_cursor() end,                 desc = "Run to Cursor" },
        { "<leader>dg", function() require("dap").goto_() end,                         desc = "Go to Line (No Execute)" },
        { "<F7>",       function() require("dap").step_into() end,                     desc = "Step Into" },
        { "<leader>dj", function() require("dap").down() end,                          desc = "Down" },
        { "<leader>dk", function() require("dap").up() end,                            desc = "Up" },
        { "<leader>dl", function() require("dap").run_last() end,                      desc = "Run Last" },
        { "S-<F8>",     function() require("dap").step_out() end,                      desc = "Step Out" },
        { "<F8>",       function() require("dap").step_over() end,                     desc = "Step Over" },
        { "<leader>dp", function() require("dap").pause() end,                         desc = "Pause" },
        { "<leader>dr", function() require("dap").repl.toggle() end,                   desc = "Toggle REPL" },
        { "<leader>ds", function() require("dap").session() end,                       desc = "Session" },
        { "<F10>",      function() require("dap").terminate() end,                     desc = "Terminate" },
        { "<leader>dw", function() require("dap.ui.widgets").hover() end,              desc = "Widgets" },
    },
    config = function()
        vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

        local dap = require("dap")
        dap.adapters.coreclr = function(cb, config)
            print('Building project')
            vim.fn.system('dotnet build -c Debug')
            print('Build done')
            -- if config.preLaunchTask then vim.fn.system(config.preLaunchTask) end
            local adapter = {
                type = "executable",
                command = "netcoredbg",
                args = { '--interpreter=vscode' }
            }
            cb(adapter)
        end

        dap.configurations.cs = {
            {
                type = "coreclr",
                name = "launch - netcoredbg",
                request = "launch",
                env = "ASPNETCORE_ENVIRONMENT=Development",
                args = {
                    "/p:EnvironmentName=Development",
                    "--environment=Development",
                },
                program = function()
                    return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
                end,
            },
        }

        require("nvim-dap-virtual-text").setup({
            automatic_installation = true,
            handlers = {
                function(config)
                    require("mason-nvim-dap").default_setup(config)
                end,
            },
        })

        local dapview = require("dap-view")
        dapview.setup({
            auto_toggle = true,
            winbar = {
                sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
            },
            switchbuf = "usetab",
        })

        vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#1f1d2e", bg = "#f6c177" })
        vim.fn.sign_define("DapStopped", {
            text = "->",
            texthl = "DapStopped",
            linehl = "DapStopped",
            numhl = "DapStopped",
        })
    end
}
