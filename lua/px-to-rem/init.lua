local U = require("px-to-rem.utils")
local M = {}

M.config = {
	rem = 16,
}

function M.px_to_rem()
	local node = U.get_valid_node()

	-- stylua: ignore
	if not node then return end

	local format = U.get_format(node)

	-- stylua: ignore
	if format ~= 'px' then return end

	local old_val = U.get_value(node)
	local new_val = old_val / M.config.rem

	U.update_node(node, new_val .. "rem")
end

function M.rem_to_px()
	local node = U.get_valid_node()

	-- stylua: ignore
	if not node then return end

	local format = U.get_format(node)

	-- stylua: ignore
	if format ~= 'rem' then return end

	local old_val = U.get_value(node)
	local new_val = old_val * M.config.rem

	U.update_node(node, new_val .. "px")
end

function M.toggle_px_rem()
	local node = U.get_valid_node()

  -- stylua: ignore
  if not node then return end

	local format = U.get_format(node)

	if format == "px" then
		M.px_to_rem()
	elseif format == "rem" then
		M.rem_to_px()
	end
end

function M.setup(config)
	M.config = vim.tbl_extend("force", M.config, config)

	vim.api.nvim_create_user_command("TogglePxRem", M.toggle_px_rem, {})
	vim.api.nvim_create_user_command("PxToRem", M.px_to_rem, {})
	vim.api.nvim_create_user_command("RemToPx", M.rem_to_px, {})
end

return M
