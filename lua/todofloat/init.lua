local M = {}

-- [[ Expand path vars ]]
local function expand_path(path)
  if path:sub(1, 1) == '~' then
    return os.getenv 'HOME' .. path:sub(2)
  end
  return path
end

-- [[ Window centering func ]]
local function center_in(outer, inner)
  return (outer - inner) / 2
end

-- [[ Popup window defaults ]]
local function win_config()
  local width = math.min(math.floor(vim.o.columns * 0.8), 64)
  local height = math.floor(vim.o.lines * 0.8)

  return {
    relative = 'editor',
    width = width,
    height = height,
    col = center_in(vim.o.columns, width),
    row = center_in(vim.o.lines, height),
    border = 'single',
  }
end

-- [[ Generate buffer for todo file ]]
local function open_floating_file(target_file)
  local expanded_path = expand_path(target_file)

  if vim.fn.filereadable(expanded_path) == 0 then
    vim.notify('todo file does not exist at directory: ' .. expanded_path, vim.log.levels.ERROR)
  end

  local buf = vim.fn.bufnr(expanded_path, true)

  if buf == -1 then
    buf = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_buf_set_name(buf, expanded_path)
  end

  vim.bo[buf].swapfile = false -- Disable swapfile in case multiple instances are open

  local win = vim.api.nvim_open_win(buf, true, win_config())

  -- [[ Close popup with q ]]
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '', {
    noremap = true,
    silent = true,
    callback = function()
      if vim.api.nvim_get_option_value('modified', { buf = buf }) then
        vim.notify('save your changes bb', vim.log.levels.WARN)
      else
        vim.api.nvim_win_close(0, true)
      end
    end,
  })
end

-- [[ Setup user config ]]
local function setup_user_commands(opts)
  local target_file = opts.target_file or 'todo.md'
  vim.api.nvim_create_user_command('Td', function()
    -- vim.notify 'opening floating window...'
    open_floating_file(target_file)
  end, {})
end

-- [[ Stage & export module ]]
M.setup = function(opts)
  setup_user_commands(opts)
end

return M
