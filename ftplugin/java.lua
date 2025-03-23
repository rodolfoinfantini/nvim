local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = '/home/rodolfo/.jdtls-data/' .. project_name

vim.api.nvim_create_user_command('OrganizeAllImports', function()
    vim.cmd('n **/*.java')
    vim.cmd("bufdo execute \"lua require('jdtls').organize_imports()\" | write")
end, {})

require('jdtls').start_or_attach({
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    cmd = {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-javaagent:/home/rodolfo/.local/share/nvim/mason/packages/jdtls/lombok.jar',
        '-Xmx4g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar',
        '/home/rodolfo/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar',
        '-configuration', '/home/rodolfo/.local/share/nvim/mason/packages/jdtls/config_linux',
        '-data', workspace_dir
    },
    root_dir = vim.fs.dirname(vim.fs.find({ 'pom.xml', 'mvnw', 'gradlew', 'build.xml', '.git' },
        { upward = true })[1]),
    settings = {
        java = {
            signatureHelp = { enabled = true },
            eclipse = {
                downloadSources = true,
            },
            maven = {
                downloadSources = true,
            },
            implementationsCodeLens = {
                enabled = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            references = {
                includeDecompiledSources = true,
            },
            inlayHints = {
                parameterNames = {
                    enabled = "all", -- literals, all, none
                },
            },
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
        }
    },
    on_attach = function(client, bufnr)
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
    end,
    -- init_options = {
    --     bundles = {
    --         vim.fn.glob(
    --             "/home/rodolfo/Downloads/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-0.53.1.jar",
    --             true)
    --     },
    -- },
})
