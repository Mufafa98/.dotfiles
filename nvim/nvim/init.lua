require("core.options")
require("core.keymaps")
require("plugins")

-- Create a command :ShowCaptures
vim.api.nvim_create_user_command('ShowCaptures', function()
    local captures = vim.treesitter.get_captures_at_cursor()
    print(vim.inspect(captures))
end, {})


vim.api.nvim_create_user_command('SemanticToken', function()
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1 -- 0‑based line
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local tokens = vim.lsp.semantic_tokens.get_at_pos(line, col)
    print(vim.inspect(tokens))
end, {})

vim.api.nvim_create_user_command('FindHighlightByColor', function(opts)
    local target_color = opts.args:gsub('%s', ''):lower()
    if not target_color:match('^#%x%x%x%x%x%x$') then
        vim.notify("Usage: :FindHighlightByColor #RRGGBB", vim.log.levels.ERROR)
        return
    end

    local groups = vim.api.nvim_get_hl(0, {})
    local lines = {}
    local hl_data = {}

    for group, info in pairs(groups) do
        local fg_hex = info.fg and string.format("#%06x", info.fg) or nil
        if fg_hex == target_color then
            local idx = #lines
            table.insert(lines, string.format(" %-30s [ PREVIEW ]", group))
            table.insert(hl_data, { group = group, line = idx })
        end
    end

    if #lines == 0 then
        vim.notify("No groups found for " .. target_color, vim.log.levels.WARN)
        return
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Window configuration
    local width = 60
    local height = math.min(#lines, 20)
    vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        col = (vim.o.columns - width) / 2,
        row = (vim.o.lines - height) / 2,
        style = 'minimal',
        border = 'rounded',
        title = " Highlights for " .. target_color,
        title_pos = "center"
    })

    -- The modern way: nvim_buf_set_extmark
    local ns = vim.api.nvim_create_namespace("HlSearch")
    for _, data in ipairs(hl_data) do
        vim.api.nvim_buf_set_extmark(buf, ns, data.line, 32, {
            end_col = 43,
            hl_group = data.group,
        })
    end

    vim.keymap.set('n', 'q', '<cmd>q<cr>', { buffer = buf })
    vim.keymap.set('n', '<Esc>', '<cmd>q<cr>', { buffer = buf })
end, { nargs = 1 })
