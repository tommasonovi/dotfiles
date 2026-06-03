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
        local actions = require("diffview.actions")
        require("diffview").setup({
            view = {
                merge_tool = {
                    layout = "diff3_mixed",
                    disable_diagnostics = true,
                },
            },
            keymaps = {
                file_panel = {
                    { "n", "u", actions.toggle_stage_entry, { desc = "Stage/unstage file (toggle)" } },
                    { "n", "r", actions.restore_entry,      { desc = "Restore file (discard changes)" } },
                },
            },
        })
    end,
}
