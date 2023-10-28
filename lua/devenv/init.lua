local devenv_command = "devenv"

function ReverseTable(tbl)
    local reversed = {}
    local len = #tbl
    for i = len, 1, -1 do
        table.insert(reversed, tbl[i])
    end
    return reversed
end

function GetBufferPathsFromIDs(buffer_ids)
    local buffer_paths = {}
    for _, buf_id in ipairs(buffer_ids) do
        local buf_path = vim.api.nvim_buf_get_name(buf_id)
        if buf_path ~= '' then
            table.insert(buffer_paths, buf_path)
        end
    end
    return buffer_paths
end

function OpenBufferPathsInDevenv(buffer_paths)
    local cmd_args = table.concat(buffer_paths, " ")
    local cmd = string.format('%s /edit %s', devenv_command, cmd_args)
    os.execute(cmd)
end

function OpenReversedBufferPaths()
    local buffer_ids = require('nvchad.tabufline').bufilter()
    local buffer_paths = GetBufferPathsFromIDs(buffer_ids)
    local reversed_paths = ReverseTable(buffer_paths)
    OpenBufferPathsInDevenv(reversed_paths)
end

function OpenCurrentBufferInDevenv()
    local current_buf_id = vim.fn.bufnr('%') -- Lấy ID của buffer hiện tại
    local buf_path = vim.api.nvim_buf_get_name(current_buf_id)
    if buf_path ~= '' then
        local cmd = string.format('%s /edit "%s"', devenv_command, buf_path)
        os.execute(cmd)
    end
end

return {
    StartDevEnv = OpenReversedBufferPaths,
    OpenCurrentBufferDevEnv = OpenCurrentBufferInDevenv
}
