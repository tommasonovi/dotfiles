return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = { enabled = false }, -- using copilot-cmp instead
                panel = { enabled = false },
                -- Standalone language-server binary: avoids the Node.js >= 22 requirement
                -- (devcontainer has no Node, host has 18).
                server = { type = "binary" },
            })
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        dependencies = { "zbirenbaum/copilot.lua" },
        config = function()
            require("copilot_cmp").setup()
        end,
    },
}
