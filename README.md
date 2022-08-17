# Unito

This plugin is inspired by [PX to REM](https://marketplace.visualstudio.com/items?itemName=sainoba.px-to-rem), I miss this feature when I use neovim

## Why?

When you work in CSS there are cases where you want to use the "rem" unit for more accessibility UI,
but transforming "px" units to "rem" could be confusing, this plugin tries to make these conversions easier

## Requirements

- Neovim 0.7.0 or later
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) plugin

## Commands

- `:PxToRem` - convert cursor value from px to rem
- `:RemToPx` - convert cursor value from px to rem
- `:TogglePxRem` - toggle between px and rem values

## Mappings

You can map using predefined commands like this

```lua
vim.keymap.set('n', '<leader>px', '<Cmd>PxToRem<CR>')
vim.keymap.set('n', '<leader>pr', '<Cmd>RemToPx<CR>')
vim.keymap.set('n', '<leader>pt', '<Cmd>TogglePxRem<CR>')
```

Or if you prefer use Lua functions

```lua
local unito = require('unito')

vim.keymap.set('n', '<leader>px', unito.px_to_rem)
vim.keymap.set('n', '<leader>px', unito.rem_to_px)
vim.keymap.set('n', '<leader>px', unito.toggle_px_rem)
```

## Configuration

Example with the default config, you don't need to call if you use the default config

```lua
require('unito').setup({
  rem = 16, -- rem value used to convertions
  max_decimals = 4, -- max decimal for floating values
})
```

## License

Licensed under the [MIT](./LICENSE) license.
