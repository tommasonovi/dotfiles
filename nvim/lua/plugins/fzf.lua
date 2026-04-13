return {
    { "junegunn/fzf" },
    {
        "junegunn/fzf.vim",
        keys = {
            { "<leader>ff", "<cmd>Files<CR>",   desc = "Find files" },
            { "<leader>fg", "<cmd>Rg<CR>",      desc = "Grep" },
            { "<leader>fb", "<cmd>Buffers<CR>",  desc = "Buffers" },
            { "<leader>fh", "<cmd>History<CR>",  desc = "History" },
            { "<leader>fl", "<cmd>BLines<CR>",   desc = "Buffer lines" },
        },
    },
}
