# TODO_FLOAT

Plugin tutorial by _Coding with Sphere_
<https://www.youtube.com/watch?v=7Kzv3wUHtyU>

## Setup

### With Lazy

```Lua
return {
  'chip0tle/todofloat-nvim',
  config = function()
    require('todofloat').setup { target_file = '~/Documents/md-notes/personal/todo_notes/todo.md' }
  end,
}
```

### Manual

_Put in init.lua:_

```Lua
local todo_float = require 'todofloat'
todo_float.setup {
  target_file = '~/Documents/md-notes/personal/todo_notes/todo.md',
}
vim.keymap.set('n', '<leader>td', ':Td<CR>', { silent = true })
```
