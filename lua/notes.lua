local M = {}

function M.open_notes()
    local notes_file = vim.fn.expand("$HOME") .. "/notes.md"

    if not vim.fn.filereadable(notes_file) then
        vim.fn.writefile({}, notes_file)
    end

    -- look for existing buffer first
    local buf = nil
    for _, b in ipairs(vim.api.nvim_list_bufs()) do -- cycle through existing buffers
        if vim.api.nvim_buf_get_name(b) == notes_file then
            buf = b
            if vim.fn.filereadable(notes_file .. ".swp") == 1 then
                vim.notify("Swap file detected! Another instance may be editing this file.", vim.log.levels.WARN)
            else
                vim.api.nvim_buf_call(buf, function()
                    vim.cmd('silent! checktime')
                    if not vim.api.nvim_buf_get_option(buf, "modified") then
                        vim.cmd('silent! edit ' .. vim.fn.fnameescape(notes_file))
                    end
                end)
            end
            break
        end
    end

    if not buf then
        buf = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_buf_set_name(buf, notes_file)

        vim.api.nvim_buf_call(buf, function()
            if vim.fn.filereadable(notes_file .. ".swp") == 1 then
                vim.notify("Swap file detected! Opening in read-only mode.", vim.log.levels.WARN)
                vim.cmd('silent! view ' .. vim.fn.fnameescape(notes_file)) -- open read-only
            else
                vim.cmd('silent! edit ' .. vim.fn.fnameescape(notes_file)) -- open normally
            end
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
