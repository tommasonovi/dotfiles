return {
    { "junegunn/fzf" },
    {
        "junegunn/fzf.vim",
        init = function()
            -- ctrl-v pastes from system clipboard inside the fzf prompt
            local existing = vim.env.FZF_DEFAULT_OPTS or ""
            vim.env.FZF_DEFAULT_OPTS = existing .. " --bind ctrl-v:paste"
        end,
        keys = {
            { "<leader>ff", "<cmd>Files<CR>",   desc = "Find files" },
            { "<leader>fg", "<cmd>Rg<CR>",      desc = "Grep" },
            { "<leader>fb", "<cmd>Buffers<CR>",  desc = "Buffers" },
            { "<leader>fh", "<cmd>History<CR>",  desc = "History" },
            { "<leader>fl", "<cmd>BLines<CR>",   desc = "Buffer lines" },
        },
    },
}
