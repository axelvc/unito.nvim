local C = require("unito.config")
local preview = require("unito.features.preview")
local sustitution = require("unito.features.sustitution")

local M = {}

---Toggle between px and rem at cursor
function M.toggle()
	sustitution.replace()
end

---Toggle preview autocmd on/off
function M.toggle_preview()
	C.options.virtual_text.enabled = not C.options.virtual_text.enabled

	if C.options.virtual_text.enabled then
		preview.start()
	else
		preview.stop()
	end
end

---Setup the plugin
---@param options ConfigOptions?
function M.setup(options)
	C.options = vim.tbl_extend("force", C.options, options or {}) --[[@as table]]

	if C.options.virtual_text.enabled then
		preview.start()
	end
end

return M
