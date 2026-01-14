local M = {}

---@class ConfigOptions
M.options = {
	rem = 16,
	max_decimals = 4,
	---@class ConfigOptions.VirtualText
	virtual_text = {
		enabled = true,
		prefix = "→ ", -- format for virtual text preview
		hl_group = "Comment", -- highlight group for virtual text
	},
}

return M
