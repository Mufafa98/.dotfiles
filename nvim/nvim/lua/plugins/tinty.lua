return
{
    "tinted-theming/tinted-nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("tinted-nvim").setup({
            default_scheme = "base16-everforest-dark-hard",
            apply_scheme_on_startup = true,
            compile = true,
            capabilities = {
                terminal_colors = true,
                truecolor = true,
                undercurl = false
            },
            highlights = {
                integrations = {},
                overrides = function(_) return {} end,
                use_lazy_specs = true
            },
            schemes = {},
            styles = {
                comments = { italic = true },
                functions = {},
                keywords = {},
                types = {},
                variables = {}
            },
            ui = {
                dim_inactive = false,
                transparent = false
            },
            selector = {
                watch = true,
                env = "",
                path = "",
                enabled = true,
                mode = "cmd",
                cmd = "tinty current",
            },
        })
    end,
}
