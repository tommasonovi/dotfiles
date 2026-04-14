return {
    { "junegunn/fzf" },
    {
        "junegunn/fzf.vim",
        dependencies = { "junegunn/fzf" },
        keys = {
            { "<leader>ff", "<cmd>Files<CR>",   desc = "Find files" },
            { "<leader>fF", function()
                local query = vim.fn.getreg('"')
                vim.fn["fzf#vim#files"]("", { options = "--query=" .. query }, 0)
            end, desc = "Find files (from yank)" },
            { "<leader>fg", "<cmd>Rg<CR>",      desc = "Grep" },
            { "<leader>fb", "<cmd>Buffers<CR>",  desc = "Buffers" },
            { "<leader>fh", "<cmd>History<CR>",  desc = "History" },
            { "<leader>fl", "<cmd>BLines<CR>",   desc = "Buffer lines" },
        },
    },
}
