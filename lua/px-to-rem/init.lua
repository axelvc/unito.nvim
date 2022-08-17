local U = require("px-to-rem.utils")
local C = require("px-to-rem.config")
local M = {}

M.px_to_rem = U.make_converter({
	required_unit = "px",
	handler = function(old_val)
		local new_val = old_val / C.options.rem

		return new_val, "rem"
	end,
})

M.rem_to_px = U.make_converter({
	required_unit = "rem",
	handler = function(old_val)
		local new_val = old_val * C.options.rem

		return new_val, "px"
	end,
})

function M.toggle_px_rem()
	local node = U.get_valid_node()

  -- stylua: ignore
  if not node then return end

	local unit = U.get_unit(node)

	if unit == "px" then
		M.px_to_rem()
	elseif unit == "rem" then
		M.rem_to_px()
	end
end

---@param options ConfigOptions | nil
function M.setup(options)
	C.options = vim.tbl_extend("force", C.options, options or {}) --[[@as table]]
end

return M
