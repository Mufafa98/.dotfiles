local js_ts = { "prettierd", "prettier", stop_after_first = true }

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = js_ts,
        javascriptreact = js_ts,
        typescript = js_ts,
        typescriptreact = js_ts,
        rust = { "rustfmt" },
      },
      -- Set default options
      default_format_opts = {
        lsp_format = "fallback",
      },
      -- Customize formatters
      formatters = {
        black = {
          prepend_args = { "--line-length", "120" },
        },
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      vim.keymap.set("n", "<leader>f", function() require("conform").format() end)
    end,
  },
}
