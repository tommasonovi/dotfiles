return {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = function()
        local gs = require("gitsigns")
        gs.setup({ current_line_blame = true })

        local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { desc = desc })
        end

        map("n", "]h", function() gs.nav_hunk("next") end, "Next hunk")
        map("n", "[h", function() gs.nav_hunk("prev") end, "Prev hunk")

        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk (restore from index)")
        map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage selection")
        map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset selection")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")

        map("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>", "Toggle git blame")
        map("n", "<leader>gB", function() gs.blame_line({ full = true }) end, "Blame popup (full commit)")
    end,
}
