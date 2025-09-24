local M = {}

-- default config
local config = {
    height = 20,
    width = 80,
    relative_numbers = true,                                -- false for absolute
    notes_file_path = vim.fn.expand("$HOME") .. "/notes.md" -- default notes file path
}

-- overide default config
function M.setup(user_config)
    user_config = user_config or {}
    config = vim.tbl_deep_extend("force", config, user_config)
end

function M.open_notes()
    local notes_file = config.notes_file_path

    if not vim.fn.filereadable(notes_file) then
        vim.fn.writefile({}, notes_file)
    end

    -- look for existing buffer first
    local buf = nil
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_name(b) == notes_file then
            buf = b
            vim.api.nvim_buf_call(buf, function()
                vim.cmd('edit')
            end)
            break
        end
    end

    if not buf then
        buf = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_buf_call(buf, function()
            vim.cmd('silent! edit ' .. vim.fn.fnameescape(notes_file)) -- silent! avoids E13 errors
        end)
    end

    vim.bo[buf].filetype = "markdown"
    vim.bo[buf].buftype = ""

    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        row = math.floor((vim.o.lines - config.height) / 2),
        col = math.floor((vim.o.columns - config.width) / 2),
        width = config.width,
        height = config.height,
        style = 'minimal',
        border = 'single',
    })

    if config.relative_numbers then
        vim.bo[buf].relativenumber = true
        vim.bo[buf].number = true
    else
        vim.bo[buf].number = true
        vim.bo[buf].relativenumber = false
    end

    -- focus on floating window
    vim.api.nvim_set_current_win(win)
end

return M
