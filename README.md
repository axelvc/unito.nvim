# Unito

This plugin is inspired by [PX to REM](https://marketplace.visualstudio.com/items?itemName=sainoba.px-to-rem), I miss this feature when I use Neovim

## Why?

When you work in CSS there are cases where you want to use the "rem" unit for more accessibility UI,
but transforming "px" units to "rem" could be confusing, this plugin tries to make these conversions easier

## Requirements

- Neovim 0.9.0 or later
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) plugin installed and configured for CSS files

## Usage

### Installation

Install the plugin with your preferred package manager:

```lua
-- lazy.nvim
{
  'axelvc/unito.nvim',
  config = true,
  lazy = true,
}
```

### Mappings

```lua
local unito = require('unito')

vim.keymap.set('n', '<leader>px', function() require('unito').toggle() end) -- toggle between px and rem
vim.keymap.set('n', '<leader>pp', function() require('unito').toggle_preview() end) -- virtual inline preview of opposite value
```

## Configuration

Example with the default config, you don't need to call if you use the default config

```lua
require('unito').setup({
  rem = 16, -- rem value used for conversions
  max_decimals = 4, -- max decimals for floating values
  virtual_text = {
    enabled = true, -- show inline preview when cursor is on a value
    prefix = "-> ", -- prefix for virtual text
    hl_group = "Comment", -- highlight group for virtual text
  },
})
```

## Development

### Running Tests

This plugin uses [plenary.nvim](https://github.com/nvim-plenary/plenary.nvim) for testing.

```bash
make test
```

## License

Licensed under the [MIT](./LICENSE) license.
