local ptr = require("px-to-rem")

if vim.g.loaded_px_to_rem then
	return
end

vim.g.loaded_px_to_rem = true
ptr.setup()

vim.api.nvim_create_user_command("TogglePxRem", ptr.toggle_px_rem, {})
vim.api.nvim_create_user_command("PxToRem", ptr.px_to_rem, {})
vim.api.nvim_create_user_command("RemToPx", ptr.rem_to_px, {})
