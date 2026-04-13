return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("noice").setup({
            cmdline = {
                view = "cmdline_popup",
                format = {
                    cmdline = { icon = ":" },
                    search_down = { icon = "/" },
                    search_up = { icon = "?" },
                },
            },
            messages = { enabled = true },
            popupmenu = { enabled = true },
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
        })
    end,
}
