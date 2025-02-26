local M = {}

function M.open_notes()
    local notes_file = vim.fn.expand("$HOME") .. "/notes.md"

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

    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
    vim.api.nvim_buf_set_option(buf, "buftype", "")

    local width = 80
    local height = 20

    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        width = width,
        height = height,
        style = 'minimal',
        border = 'single',
    })

    vim.api.nvim_buf_set_option(buf, 'number', true)
    vim.api.nvim_buf_set_option(buf, 'relativenumber', true)

    -- focus on floating window
    vim.api.nvim_set_current_win(win)
end

return M
