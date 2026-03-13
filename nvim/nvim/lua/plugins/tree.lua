return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup({
                git = {
                    enable = true,
                    ignore = false
                },
                renderer = {
                    icons = {
                        glyphs = {
                            git = {
                                unstaged = "M",
                                untracked = "?",
                            }
                        }
                    }
                },
                diagnostics = {
                    enable = true,
                    icons = {
                        error = "E",
                        warning = "W",
                    }
                }
            })
            -- open nvim-tree automatically
            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    require("nvim-tree.api").tree.open()
                end,
            })
        end,
    },
}
