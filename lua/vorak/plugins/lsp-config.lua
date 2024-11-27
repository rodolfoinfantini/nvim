return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
        -- 'zbirenbaum/copilot.lua',
        -- 'zbirenbaum/copilot-cmp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'onsails/lspkind.nvim',
        'SmiteshP/nvim-navic',
        'hrsh7th/cmp-nvim-lsp-signature-help',
    },
    config = function()
        local navic = require("nvim-navic")
        navic.setup {
            icons = {
                File = ' ',
                Module = ' ',
                Namespace = ' ',
                Package = ' ',
                Class = ' ',
                Method = ' ',
                Property = ' ',
                Field = ' ',
                Constructor = ' ',
                Enum = ' ',
                Interface = ' ',
                Function = ' ',
                Variable = ' ',
                Constant = ' ',
                String = ' ',
                Number = ' ',
                Boolean = ' ',
                Array = ' ',
                Object = ' ',
                Key = ' ',
                Null = ' ',
                EnumMember = ' ',
                Struct = ' ',
                Event = ' ',
                Operator = ' ',
                TypeParameter = ' '
            },
            lsp = {
                auto_attach = false,
                preference = nil,
            },
            highlight = true,
            separator = " > ",
            depth_limit = 0,
            depth_limit_indicator = "..",
            safe_output = true,
            lazy_update_context = false,
            click = false,
            format_text = function(text)
                return text
            end,
        }
        local on_attach = function(client, bufnr)
            if client.server_capabilities.documentSymbolProvider then
                navic.attach(client, bufnr)
            end

            vim.api.nvim_create_autocmd('CursorHold', {
                pattern = '<buffer>',
                callback = function()
                    if client.server_capabilities.documentHighlightProvider then
                        vim.lsp.buf.document_highlight()
                    end
                end,
            })

            vim.api.nvim_create_autocmd('CursorHoldI', {
                pattern = '<buffer>',
                callback = function()
                    if client.server_capabilities.documentHighlightProvider then
                        vim.lsp.buf.document_highlight()
                    end
                end,
            })

            vim.api.nvim_create_autocmd('CursorMoved', {
                pattern = '<buffer>',
                callback = function()
                    if client.server_capabilities.documentHighlightProvider then
                        vim.lsp.buf.clear_references()
                    end
                end,
            })
        end

        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        require('mason').setup({})
        require('mason-lspconfig').setup({
            handlers = {
                function(server_name)
                    require('lspconfig')[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach
                    })
                end,
            },
        })

        vim.api.nvim_create_autocmd('LspAttach', {
            desc = 'LSP actions',
            callback = function(event)
                local opts = { buffer = event.buf, silent = true }

                vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
                vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                vim.keymap.set('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

                vim.lsp.codelens.refresh()
                vim.lsp.inlay_hint.enable()
            end,
        })

        vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function()
                local lsp = vim.lsp.get_clients()[1].name
                if lsp == 'jdtls' then
                    require('jdtls').organize_imports()
                    vim.cmd('sleep 100m')
                end

                vim.lsp.buf.format()
            end,
        })

        -- vim.api.nvim_create_autocmd("BufWritePre", {
        -- pattern = "*.java",
        -- callback = function()
        -- require('jdtls').organize_imports()
        -- end,
        -- })

        -- require('copilot').setup({
        -- suggestion = { enabled = false },
        -- panel = { enabled = false },
        -- })
        -- require('copilot_cmp').setup()

        local kind_icons = {
            Text = ' ',
            Method = ' ',
            Function = ' ',
            Constructor = ' ',
            Field = ' ',
            Variable = ' ',
            Class = ' ',
            Interface = ' ',
            Module = ' ',
            Property = ' ',
            Unit = ' ',
            Value = ' ',
            Enum = ' ',
            Keyword = ' ',
            Snippet = ' ',
            Color = ' ',
            File = ' ',
            Reference = ' ',
            Folder = ' ',
            EnumMember = ' ',
            Constant = ' ',
            Struct = ' ',
            Event = ' ',
            Operator = ' ',
            TypeParameter = ' ',
            -- Copilot = ' ',
            Path = ' ',
        }

        local cmp = require('cmp')
        cmp.setup({
            view = { docs = { auto_open = true } },
            completion = {
                completeopt = 'menu,menuone,noinsert',
            },
            performance = {
                debounce = 0,
                throttle = 0,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            sources = {
                { name = 'nvim_lsp_signature_help' },
                { name = 'nvim_lsp' },
                { name = 'buffer' },
                { name = 'path' },
            },
            mapping = cmp.mapping.preset.insert({
                ['<CR>'] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                }),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.close(),
                ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                ['<C-u>'] = cmp.mapping.scroll_docs(4),
            }),
            formatting = {
                format = function(entry, vim_item)
                    -- Kind icons
                    vim_item.kind = string.format(' %s%s', kind_icons[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind
                    -- Source
                    vim_item.menu = ({
                        buffer = "[Buffer]",
                        nvim_lsp = "[LSP]",
                        luasnip = "[LuaSnip]",
                        nvim_lua = "[Lua]",
                        latex_symbols = "[LaTeX]",
                        -- copilot = "[Copilot]",
                        path = "[Path]",
                    })[entry.source.name]
                    return vim_item
                end
            },
        })
    end,
}
