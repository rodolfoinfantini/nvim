return {
    "neoclide/coc.nvim",
    branch = "master",
    build = "yarn install --frozen-lockfile",
    config = function()
        local cmd = vim.api.nvim_command

        vim.g.coc_global_extensions = {
            'coc-css',
            'coc-cssmodules',
            'coc-diagnostic',
            'coc-dictionary',
            'coc-docker',
            'coc-emmet',
            'coc-eslint',
            'coc-go',
            'coc-highlight',
            'coc-html',
            'coc-java',
            'coc-json',
            'coc-lua',
            'coc-prettier',
            'coc-pyright',
            'coc-tsserver',
            'coc-pairs',
            'coc-tabnine',
            'coc-rust-analyzer',
            'coc-symbol-line',
            'coc-cspell-dicts',
            'coc-spell-checker',
            'coc-clangd',
            'coc-db',
            'coc-sumneko-lua'
        }

        function _G.check_back_space()
            local col = vim.fn.col('.') - 1
            if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                return true
            else
                return false
            end
        end

        function _G.show_docs()
            local cw = vim.fn.expand('<cword>')
            if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
                cmd('h ' .. cw)
            elseif vim.api.nvim_eval('coc#rpc#ready()') then
                vim.fn.CocActionAsync('doHover')
            else
                cmd('!' .. vim.o.keywordprg .. ' ' .. cw)
            end
        end

        vim.cmd([[
        inoremap <silent><expr> <TAB>
          \ coc#pum#visible() ? coc#pum#next(1) :
          \ CheckBackspace() ? "\<Tab>" :
          \ coc#refresh()
        inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

        inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

        function! CheckBackspace() abort
          let col = col('.') - 1
          return !col || getline('.')[col - 1]  =~# '\s'
        endfunction

        inoremap <silent><expr> <c-space> coc#refresh()
        ]])

        vim.keymap.set("n", "K", '<CMD>lua _G.show_docs()<CR>', { silent = true })
        vim.keymap.set("n", "[g", '<Plug>(coc-diagnostic-prev)', { noremap = false })
        vim.keymap.set("n", "]g", '<Plug>(coc-diagnostic-next)', { noremap = false })

        vim.keymap.set("n", "gd", '<Plug>(coc-definition)', { noremap = false })
        vim.keymap.set("n", "gy", '<Plug>(coc-type-definition)', { noremap = false })
        vim.keymap.set("n", "gi", '<Plug>(coc-implementation)', { noremap = false })
        vim.keymap.set("n", "gr", '<Plug>(coc-references)', { noremap = false })
        vim.keymap.set("n", "<F2>", '<Plug>(coc-rename)', { noremap = false })
        vim.keymap.set("n", "<leader>rn", '<Plug>(coc-rename)', { noremap = false })

        vim.keymap.set("x", "<leader>f", '<Plug>(coc-format-selected)', { noremap = false })
        vim.keymap.set("n", "<leader>f", '<Plug>(coc-format-selected)', { noremap = false })

        vim.keymap.set("v", "<leader>a", '<Plug>(coc-codeaction-selected)')
        vim.keymap.set("n", "<leader>a", '<Plug>(coc-codeaction)')
        vim.keymap.set("n", "<leader>qf", '<Plug>(coc-fix-current)', { noremap = false })

        vim.cmd([[
            autocmd CursorHold * silent call CocActionAsync('highlight')
            autocmd BufWritePre *.js :silent call CocAction('runCommand', 'prettier.formatFile')
            autocmd BufWritePre *.ts :silent call CocAction('runCommand', 'prettier.formatFile')
            autocmd BufWritePre *.css :silent call CocAction('runCommand', 'prettier.formatFile')
            autocmd BufWritePre *.html :silent call CocAction('runCommand', 'prettier.formatFile')
            autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
            augroup mygroup
            autocmd!
            autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
            autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
            autocmd FileType html let b:coc_pairs_disabled = ['<']
            augroup end
            command! -nargs=0 Format :call CocAction('format')

            command! -nargs=? Fold :call     CocAction('fold', <f-args>)

            command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

            command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')

            set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
    ]])
    end
}
