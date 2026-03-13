return {

    {
        "https://github.com/junegunn/fzf.vim",
        dependencies = {
            "https://github.com/junegunn/fzf",
        },
        keys = {
            { "<Leader><Leader>", "<Cmd>Files<CR>",   desc = "Find files" },
            { "<Leader>,",        "<Cmd>Buffers<CR>", desc = "Find buffers" },
            { "<Leader>/",        "<Cmd>Rg<CR>",      desc = "Search project" },
        },
    },
    {
        "https://github.com/windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup()
        end,
    },
    {
        "https://github.com/numToStr/Comment.nvim",
        event = "VeryLazy",
        config = function()
            require("Comment").setup()
        end,
    },
    {
        "https://github.com/tpope/vim-sleuth",
        event = { "BufReadPost", "BufNewFile" },
    },
}
