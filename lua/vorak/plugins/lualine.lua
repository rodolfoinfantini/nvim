return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
        "ryanoasis/vim-devicons",
        'stevearc/oil.nvim',
    },
    config = function()
        local function oil_location()
            return require('oil').get_current_dir() or ''
        end
        local function folder_icon()
            if require('oil').get_current_dir() == nil then
                return ''
            end
            return ""
        end

        require('lualine').setup {
            options = {
                icons_enabled = true,
                theme = 'tokyonight',
                -- theme = 'catppuccin',
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                disabled_filetypes = {
                    "dapui_watches", "dapui_breakpoints",
                    "dapui_scopes", "dapui_console",
                    "dapui_stacks", "dap-repl"
                },
                ignore_focus = {
                    "dapui_watches", "dapui_breakpoints",
                    "dapui_scopes", "dapui_console",
                    "dapui_stacks", "dap-repl"
                },
                always_divide_middle = true,
                globalstatus = false,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                }
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                lualine_c = { 'filename' },
                lualine_x = { 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { 'filename' },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            winbar = {
                lualine_a = {
                    {
                        '%{%get(b:, "coc_symbol_line", "")%}',
                        color = 'none',
                    },
                },
                lualine_b = { folder_icon },
                lualine_c = { oil_location },
                lualine_x = {},
                lualine_y = {},
                lualine_z = {}
            },
            inactive_winbar = {
            },
            extensions = {}
        }
    end
}
