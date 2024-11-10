-- Resize buffer easier
vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", {
        desc = "Resize buffer to the left",
    })
vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", {
        desc = "Resize buffer to the right",
    })
vim.keymap.set("n", "<Up>", ":resize -2<CR>", {
        desc = "Resize buffer to the top",
    })
vim.keymap.set("n", "<Down>", ":resize +2<CR>", {
        desc = "Resize buffer to the bottom",
    })
-- Better movement between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Go to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Go to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Go to the bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Go to the top window" })



vim.keymap.set("n", "<leader>o", "o<Esc>k")
vim.keymap.set("n", "th", ":split<CR>")
vim.keymap.set("n", "tv", ":vsplit<CR>")

vim.keymap.set("n", "<leader>n", ":bnext<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "y", "ygv<Esc>")

vim.keymap.set("x", "<leader>p", "\"_dP")
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>i", "gg=G<C-o>")

vim.keymap.set("v", "<", "<gv", { desc = "Dedent current selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent current selection" })
