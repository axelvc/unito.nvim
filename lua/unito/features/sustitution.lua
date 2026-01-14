local C = require("unito.config")
local Converter = require("unito.lib.converter")
local ts = require("unito.lib.treesitter")

local M = {}

M.converters = {
	px = Converter:new({
		input = "px",
		output = "rem",
		handler = function(val)
			return val / C.options.rem
		end
	}),
	rem = Converter:new({
		input = "rem",
		output = "px",
		handler = function(val)
			return val * C.options.rem
		end
	})
}

---Check if a unit is valid
---@param unit string
---@return boolean
function M.is_valid_unit(unit)
	return M.converters[unit] ~= nil
end

---Replace a node with a converted value
---@param unit string?
function M.replace(unit)
	local node = ts.get_valid_node()
	if not node then return end

	unit = unit or ts.get_unit(node)
	if not M.is_valid_unit(unit) then return end

	local converter = M.converters[unit]

	local new_val = converter:convert(node)
	if not new_val then return end

	ts.replace_node_text(node, new_val .. converter.output)
end

return M
