return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'hrsh7th/nvim-cmp',
    },
    lazy = false,
    config = function()
        local on_attach = function(client, bufnr)
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

        require('mason').setup({
            registries = {
                "github:mason-org/mason-registry",
                "github:Crashdummyy/mason-registry"
            },
        })

        local lsp = require "lspconfig"
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        require('mason-lspconfig').setup({
            handlers = {
                function(server_name)
                    if server_name == 'jdtls' then
                        return
                    end
                    lsp[server_name].setup({
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
                -- vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                -- vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                -- vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                -- vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                -- vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                -- vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                vim.keymap.set('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

                vim.lsp.codelens.refresh()
                vim.lsp.inlay_hint.enable()
            end,
        })

        vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function()
                local cur_lsp = vim.lsp.get_clients()[1].name
                if cur_lsp == 'jdtls' then
                    require('jdtls').organize_imports()
                    vim.cmd('sleep 100m')
                end

                vim.lsp.buf.format()

                vim.lsp.codelens.refresh()
            end,
        })
    end,
}
