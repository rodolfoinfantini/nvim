return {
    -- "rodolfoinfantini/fzf-spring.nvim",
    dir = '~/dev/lua/fzf-spring.nvim',
    dependencies = { "ibhagwan/fzf-lua" },
    config = function()
        local fzf_spring = require("fzf-spring")
        fzf_spring.setup()
        vim.keymap.set("n", "<leader>fs", fzf_spring.pick_spring, { silent = true })
        -- vim.keymap.set("n", "<leader>fs", fzf_spring.pick_get_mapping, { silent = true })
        -- vim.keymap.set("n", "<leader>fs", fzf_spring.pick_post_mapping, { silent = true })
        -- vim.keymap.set("n", "<leader>fs", fzf_spring.pick_put_mapping, { silent = true })
        -- vim.keymap.set("n", "<leader>fs", fzf_spring.pick_delete_mapping, { silent = true })
        -- vim.keymap.set("n", "<leader>fs", fzf_spring.pick_patch_mapping, { silent = true })
    end
}
