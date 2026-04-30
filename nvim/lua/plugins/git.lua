return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup({
            current_line_blame = true,
        })
        vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle git blame" })
        vim.keymap.set("n", "<leader>gB", function() require("gitsigns").blame_line({ full = true }) end, { desc = "Blame popup (full commit)" })
    end,
}
