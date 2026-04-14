return {
    { "junegunn/fzf" },
    {
        "junegunn/fzf.vim",
        dependencies = { "junegunn/fzf" },
        keys = {
            { "<leader>ff", function()
                vim.fn["fzf#vim#files"]("", { options = "--bind ctrl-v:paste" }, 0)
            end, desc = "Find files" },
            { "<leader>fg", "<cmd>Rg<CR>",      desc = "Grep" },
            { "<leader>fb", "<cmd>Buffers<CR>",  desc = "Buffers" },
            { "<leader>fh", "<cmd>History<CR>",  desc = "History" },
            { "<leader>fl", "<cmd>BLines<CR>",   desc = "Buffer lines" },
        },
    },
}
