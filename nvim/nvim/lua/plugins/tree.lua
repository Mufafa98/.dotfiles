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
                filesystem_watchers = {
                    enable = true,
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
            -- auto-close if nvim-tree is the last window
            vim.api.nvim_create_autocmd("BufEnter", {
                callback = function()
                    if vim.fn.winnr("$") == 1 and vim.bo.filetype == "NvimTree" then
                        vim.cmd("quit")
                    end
                end,
            })
        end,
    },
}
