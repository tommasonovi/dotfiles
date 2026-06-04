-- Copy the commit hash under the cursor (file-history panel) into normal
-- registers and a global, bypassing the system clipboard entirely. The "+"
-- clipboard provider is unreliable over SSH / devcontainers (no DISPLAY),
-- which makes the built-in copy_hash + <C-r>+ paste flow fail silently.
local function copy_hash_local()
    local ok, lib = pcall(require, "diffview.lib")
    if not ok then return end
    local view = lib.get_current_view()
    if not (view and view.panel and view.panel.get_item_at_cursor) then return end
    local item = view.panel:get_item_at_cursor()
    if item and item.commit then
        local hash = item.commit.hash
        vim.fn.setreg('"', hash) -- unnamed register -> paste with <C-r>"
        vim.fn.setreg("h", hash) -- named register h  -> paste with <C-r>h
        vim.g.diffview_last_hash = hash
        vim.notify("Copied " .. hash:sub(1, 8) .. " (reg \" / h, and <leader>dr default)")
    end
end

return {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    keys = {
        { "<leader>dv", "<cmd>DiffviewOpen<CR>",         desc = "Diffview: open" },
        { "<leader>dV", "<cmd>DiffviewOpen main<CR>",    desc = "Diffview: vs main" },
        {
            "<leader>dr",
            function()
                local default = vim.g.diffview_last_hash
                    and (vim.g.diffview_last_hash:sub(1, 12) .. "..HEAD")
                    or ""
                local rev = vim.fn.input("Diffview range (e.g. HEAD~2..HEAD): ", default)
                if rev ~= "" then
                    vim.cmd("DiffviewOpen " .. rev)
                end
            end,
            desc = "Diffview: open revision range",
        },
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
                file_history_panel = {
                    { "n", "Y", copy_hash_local, { desc = "Copy commit hash (register \" / h, bypass clipboard)" } },
                },
            },
        })
    end,
}
