---@diagnostic disable: cast-local-type
return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter"
    },
    lazy = true,
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-java")({
                    ignore_wrapper = false
                })
            }
        })

        local function projectFolder()
            local path = vim.fn.expand("%:p:h")
            while path ~= "/" do
                if vim.fn.isdirectory(path .. "/src") == 1 then
                    return path
                end
                path = vim.fn.fnamemodify(path, ":h")
            end
            return nil
        end

        vim.keymap.set("n", "<leader>tt", function()
            vim.cmd("Neotest summary open")
            require("neotest").run.run()
        end, { noremap = true })
        vim.keymap.set("n", "<leader>T", function()
            vim.cmd("Neotest summary open")
            require("neotest").run.run(vim.fn.expand("%"))
        end, { noremap = true })
        vim.keymap.set("n", "<leader>ta", function()
            vim.cmd("Neotest summary open")
            local path = projectFolder()
            if path == nil then
                print("No test folder found")
                return
            end

            print("Running all tests in " .. path .. "/src")
            require("neotest").run.run(path .. "/src")
        end, { noremap = true })

        -- vim.keymap.set("n", "<leader>b", function()
        -- local path = projectFolder()
        -- if path == nil then
        -- print("No project folder found")
        -- return
        -- end
        -- vim.cmd("!cd " .. path .. " && mvn clean install -DskipTests && cd -")
        -- end)
    end
}
