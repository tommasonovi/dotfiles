return {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    keys = {
        { "<leader>dv", "<cmd>DiffviewOpen<CR>",         desc = "Diffview: open" },
        { "<leader>dV", "<cmd>DiffviewOpen main<CR>",    desc = "Diffview: vs main" },
        { "<leader>dh", "<cmd>DiffviewFileHistory<CR>",  desc = "Diffview: branch history" },
        { "<leader>df", "<cmd>DiffviewFileHistory %<CR>", desc = "Diffview: current file history" },
        { "<leader>dq", "<cmd>DiffviewClose<CR>",        desc = "Diffview: close" },
    },
    config = function()
        require("diffview").setup({
            view = {
                merge_tool = {
                    layout = "diff3_mixed",
                    disable_diagnostics = true,
                },
            },
        })
    end,
}
