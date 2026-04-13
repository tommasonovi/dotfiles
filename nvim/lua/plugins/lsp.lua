return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "pyright", "ruff", "clangd" },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- LSP keymaps on attach
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = args.buf, desc = desc })
                    end
                    map("gd", vim.lsp.buf.definition, "Go to definition")
                    map("gr", vim.lsp.buf.references, "References")
                    map("gi", vim.lsp.buf.implementation, "Implementation")
                    map("K", vim.lsp.buf.hover, "Hover")
                    map("<leader>rn", vim.lsp.buf.rename, "Rename")
                    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
                    map("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
                    map("]d", vim.diagnostic.goto_next, "Next diagnostic")
                    map("<leader>f", function() vim.lsp.buf.format({ async = true }) end, "Format")
                end,
            })

            -- Server configs using vim.lsp.config (0.11+ API)
            vim.lsp.config("pyright", {
                capabilities = capabilities,
                settings = {
                    python = {
                        analysis = { typeCheckingMode = "basic" },
                    },
                },
            })

            vim.lsp.config("ruff", {
                capabilities = capabilities,
            })

            vim.lsp.config("clangd", {
                capabilities = capabilities,
                cmd = { "clangd", "--background-index", "--clang-tidy" },
            })

            vim.lsp.enable({ "pyright", "ruff", "clangd" })

            -- Format on save for Python and C/C++
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = { "*.py", "*.c", "*.cc", "*.cpp", "*.h", "*.hpp" },
                callback = function()
                    vim.lsp.buf.format({ async = false })
                end,
            })
        end,
    },
}
