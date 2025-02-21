local M = {}

function M.open_notes()
    local buf = vim.api.nvim_create_buf(false, true)

    local width = 120
    local height = 40
    local opts = {
        relative = "editor",
        width = width,
        height = height,
        col = math.floor((vim.o.columns - width) / 2),
        row = math.floor((vim.o.lines - height) / 2),
        style = "minimal",
        border = "rounded",
    }

    -- floating window
    local win = vim.api.nvim_open_win(buf, true, opts)

    -- set buffer options
    local note_file = vim.fn.expand("$HOME") .. "/.nvim_notes.md"
    vim.api.nvim_buf_set_name(buf, note_file)
    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

    -- Load the existing notes file (if it exists)
    if vim.fn.filereadable(note_file) == 1 then
        local lines = vim.fn.readfile(note_file)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    end


    local function save_and_close()
        local new_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false) -- Get all lines from buffer
        vim.fn.writefile(new_lines, note_file)                          -- Save to file
        vim.api.nvim_buf_delete(buf, { force = true })                  -- Close buffer
    end

    -- close window on Esc
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>lua require('notes').save_and_close()<CR>",
        { noremap = true, silent = true })
end

return M
