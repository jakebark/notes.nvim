local M = {}

function M.open_notes()
    -- Create a buffer
    local buf = vim.api.nvim_create_buf(false, true)

    -- Define floating window dimensions
    local width = 80
    local height = 20
    local opts = {
        relative = "editor",
        width = width,
        height = height,
        col = math.floor((vim.o.columns - width) / 2),
        row = math.floor((vim.o.lines - height) / 2),
        style = "minimal",
        border = "rounded",
    }

    -- Open the floating window
    local win = vim.api.nvim_open_win(buf, true, opts)

    -- Set buffer options
    local note_file = vim.fn.expand("$HOME") .. "/.nvim_notes.md"
    vim.api.nvim_buf_set_name(buf, note_file)
    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

    -- Load the existing notes file (if it exists)
    if vim.fn.filereadable(note_file) == 1 then
        local lines = vim.fn.readfile(note_file)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    end

    -- Set keymap to close window on Esc
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>bd!<CR>", { noremap = true, silent = true })
end

return M
