local unito = require("unito")

if vim.g.loaded_unito then
	return
end

vim.g.loaded_px_to_rem = true
unito.setup()

vim.api.nvim_create_user_command("TogglePxRem", unito.toggle_px_rem, {})
vim.api.nvim_create_user_command("PxToRem", unito.px_to_rem, {})
vim.api.nvim_create_user_command("RemToPx", unito.rem_to_px, {})
