return {
    "morhetz/gruvbox",
    priority = 1000,
    config = function()
        vim.g.gruvbox_transparent_bg = 1
        vim.g.gruvbox_contrast_dark = "hard"
        vim.g.gruvbox_bold = 1
        vim.cmd.colorscheme("gruvbox")
        vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
    end,
}
