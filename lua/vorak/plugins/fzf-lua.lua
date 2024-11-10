return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("fzf-lua").setup({})

    vim.keymap.set("n", "<leader>ff", "<cmd>lua require('fzf-lua').files()<cr>", {silent = true})
    vim.keymap.set("n", "<leader>fb", "<cmd>lua require('fzf-lua').buffers()<cr>", {silent = true})
    vim.keymap.set("n", "<leader>fj", "<cmd>lua require('fzf-lua').live_grep()<cr>", {silent = true})
  end
}
