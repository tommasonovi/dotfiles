return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
    },
    cmd = "Neogit",
    keys = {
        { "<leader>gs", "<cmd>Neogit<CR>",                 desc = "Neogit: status" },
        { "<leader>gc", "<cmd>Neogit commit<CR>",          desc = "Neogit: commit" },
        { "<leader>gp", "<cmd>Neogit push<CR>",            desc = "Neogit: push" },
        { "<leader>gP", "<cmd>Neogit pull<CR>",            desc = "Neogit: pull" },
        { "<leader>gl", "<cmd>Neogit log<CR>",             desc = "Neogit: log" },
    },
    config = function()
        require("neogit").setup({
            integrations = {
                diffview = true,
            },
            graph_style = "unicode",
        })
    end,
}
