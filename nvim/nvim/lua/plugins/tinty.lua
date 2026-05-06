return
{
    "tinted-theming/tinted-nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("tinted-nvim").setup({
            default_scheme = "base16-everforest-dark-hard",
            apply_scheme_on_startup = true,
            compile = false, -- was true
            capabilities = {
                terminal_colors = true,
                truecolor = true,
                undercurl = false
            },
            highlights = {
                integrations = {},
                overrides = function(_)
                    local function gen_links(mappings)
                        local result = {}
                        for capture, target in pairs(mappings) do
                            result[capture] = { link = target }
                        end
                        return result
                    end
                    return gen_links({
                        ["@variable.python"] = "Identifier",
                        ["@variable.member.python"] = "Identifier",
                        ["@lsp.type.property.rust"] = "Identifier",
                        ["@lsp.type.parameter.rust"] = "Identifier",
                        ["@lsp.type.builtinType.rust"] = "Special",
                        ["@type.builtin"] = "Special",
                        ["@lsp.type.variable.rust"] = "Identifier",
                        ["@lsp.type.typeAlias.rust"] = "Typedef",
                        ["@lsp.mod.mutable.rust"] = "@markup.link.url",
                    })
                end,
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
