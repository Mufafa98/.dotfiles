return {
    "https://github.com/VonHeikemen/lsp-zero.nvim",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
    },
    init = function()
        -- Reserve a space in the gutter
        -- This will avoid an annoying layout shift in the screen
        vim.opt.signcolumn = "yes"
    end,
    config = function()
        vim.diagnostic.config({
            update_in_insert = true,
        })
        local lsp_zero = require('lsp-zero')
        local cmp = require('cmp')

        lsp_zero.on_attach(function(_, bufnr)
            lsp_zero.default_keymaps({ buffer = bufnr })
            vim.keymap.set('n', 'gl', function()
                vim.diagnostic.open_float()
            end, { buffer = bufnr, desc = "Show diagnostic" })
        end)

        cmp.setup({
            sources = {
                { name = 'nvim_lsp' },
            },
            mapping = cmp.mapping.preset.insert({
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<C-Space>'] = cmp.mapping.complete(),
            }),
        })

        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = { "gopls", "rust_analyzer", "lua_ls" },
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup({})
                end,
                ["qmlls"] = function()
                    require("lspconfig").qmlls.setup({
                        cmd = { "qmlls", "-I", "/usr/lib/qt6/qml" }
                    })
                end,
            },
        })
    end,
}
