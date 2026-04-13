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
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "pyright", "ruff", "clangd" },
            })

            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local on_attach = function(_, bufnr)
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
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
            end

            lspconfig.pyright.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    python = {
                        analysis = { typeCheckingMode = "basic" },
                    },
                },
            })

            lspconfig.ruff.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })

            lspconfig.clangd.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                cmd = { "clangd", "--background-index", "--clang-tidy" },
            })

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
