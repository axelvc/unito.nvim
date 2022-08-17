local ts_utils = require("nvim-treesitter.ts_utils")
local C = require("px-to-rem.config")

local M = {}

function M.round(n, decimals)
	if decimals == 0 then
		return math.floor(n + 0.5)
	else
		local power = 10 ^ decimals
		return math.floor(n * power) / power
	end
end

---@class ConverterData table
---@field required_unit string
---@field handler function

---@param data ConverterData
function M.make_converter(data)
	return function()
		local node = M.get_valid_node()

		-- stylua: ignore
		if not node then return end

		local unit = M.get_unit(node)

		-- stylua: ignore
		if unit ~= data.required_unit then return end

		local old_val = M.get_value(node)
		local new_val, unit = data.handler(old_val)

		new_val = M.round(new_val, C.options.max_decimals)

		M.update_node(node, new_val .. unit)
	end
end

function M.get_valid_node()
	local node = ts_utils.get_node_at_cursor()

  -- stylua: ignore
	if not node then return end

	if node:type() == "unit" then
		return node:parent()
	end

	if node:type() == "integer_value" or node:type() == "float_value" then
		return node
	end
end

---@param node userdata tsnode
---@return string
function M.get_unit(node)
	return vim.treesitter.get_node_text(node:child(0), 0)
end

---@param node userdata tsnode
---@return string
function M.get_value(node)
	local unit = M.get_unit(node)

	return vim.treesitter.get_node_text(node, 0):match("(%d*%.?%d*)" .. unit)
end

---@param node userdata tsnode
---@param str string
function M.update_node(node, str)
	local rs, cs, re, ce = node:range()
	vim.api.nvim_buf_set_text(0, rs, cs, re, ce, { str })
end

return M
