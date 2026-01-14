-- Simple path matcher:
--  - relative: ./foo, ../foo, foo/bar
--  - absolute: /usr/bin
local PATH_PATTERN = "[%w%-%._/]+"
local M = {}

local function find_path_at_cursor(line, col)
    local best
    local best_dist = math.huge

    for s, path, e in line:gmatch("()(" .. PATH_PATTERN .. ")()") do
        local start_col = s - 1
        local end_col = e - 2

        -- Cursor inside the match
        if col >= start_col and col <= end_col then
            return path
        end

        local dist = math.min(
            math.abs(col - start_col),
            math.abs(col - end_col)
        )

        if dist < best_dist then
            best_dist = dist
            best = path
        end
    end

    return best
end

function M.open_path_under_cursor()
    local buf = 0
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]

    if not line then
        return
    end

    local path = find_path_at_cursor(line, col)
    if not path then
        vim.notify("No path found on line", vim.log.levels.INFO)
        return
    end

    -- Expand ~ and make absolute relative to cwd
    path = vim.fn.expand(path)
    if not vim.loop.fs_stat(path) then
        vim.notify("Path does not exist: " .. path, vim.log.levels.WARN)
        return
    end

    local stat = vim.loop.fs_stat(path)
    if stat.type == "file" then
        vim.cmd("edit " .. vim.fn.fnameescape(path))
    elseif stat.type == "directory" then
        -- Use whatever :Ex is mapped to
        vim.cmd("Ex " .. vim.fn.fnameescape(path))
    end
end

return M
