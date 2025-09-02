return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'hrsh7th/nvim-cmp',
    },
    lazy = false,
    config = function()
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
                vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                vim.keymap.set({ 'n', 'v' }, '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

                vim.lsp.codelens.refresh()
                vim.lsp.inlay_hint.enable()

                for _, client in ipairs(vim.lsp.buf_get_clients()) do
                    if client.name ~= 'GitHub Copilot' then
                        require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
                    end
                end

                vim.api.nvim_create_autocmd('CursorHold', {
                    pattern = '<buffer>',
                    callback = function()
                        for _, client in ipairs(vim.lsp.buf_get_clients()) do
                            if client.server_capabilities.documentHighlightProvider then
                                vim.lsp.buf.document_highlight()
                                break
                            end
                        end
                    end,
                })

                vim.api.nvim_create_autocmd('CursorHoldI', {
                    pattern = '<buffer>',
                    callback = function()
                        for _, client in ipairs(vim.lsp.buf_get_clients()) do
                            if client.server_capabilities.documentHighlightProvider then
                                vim.lsp.buf.document_highlight()
                                break
                            end
                        end
                    end,
                })

                vim.api.nvim_create_autocmd('CursorMoved', {
                    pattern = '<buffer>',
                    callback = function()
                        for _, client in ipairs(vim.lsp.buf_get_clients()) do
                            if client.server_capabilities.documentHighlightProvider then
                                vim.lsp.buf.clear_references()
                                break
                            end
                        end
                    end,
                })
            end,
        })

        vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function()
                local jdtls_client = vim.lsp.get_clients({ name = "jdtls" })
                if #jdtls_client > 0 then
                    require('jdtls').organize_imports()
                    vim.cmd('sleep 100m')
                end

                vim.lsp.buf.format()

                vim.lsp.codelens.refresh()
            end,
        })

        local handles = {}
        vim.api.nvim_create_autocmd("User", {
            pattern = "RoslynRestoreProgress",
            callback = function(ev)
                local token = ev.data.params[1]
                local handle = handles[token]
                if handle then
                    handle:report({
                        title = ev.data.params[2].state,
                        message = ev.data.params[2].message,
                    })
                else
                    handles[token] = require("fidget.progress").handle.create({
                        title = ev.data.params[2].state,
                        message = ev.data.params[2].message,
                        lsp_client = {
                            name = "roslyn",
                        },
                    })
                end
            end,
        })

        vim.api.nvim_create_autocmd("User", {
            pattern = "RoslynRestoreResult",
            callback = function(ev)
                local handle = handles[ev.data.token]
                handles[ev.data.token] = nil

                if handle then
                    handle.message = ev.data.err and ev.data.err.message or "Restore completed"
                    handle:finish()
                end
            end,
        })

        vim.api.nvim_create_autocmd({ "InsertLeave" }, {
            pattern = "*",
            callback = function()
                local clients = vim.lsp.get_clients({ name = "roslyn" })
                if not clients or #clients == 0 then
                    return
                end

                local client = clients[1]
                local client_id = client.id
                local buffers = vim.lsp.get_buffers_by_client_id(client_id)
                for _, buf in ipairs(buffers) do
                    local params = { textDocument = vim.lsp.util.make_text_document_params(buf) }
                    client:request("textDocument/diagnostic", params, nil, buf)
                end
            end,
        })
    end,
}
