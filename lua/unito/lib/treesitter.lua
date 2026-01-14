local M = {}

---Get the valid CSS value node at cursor position
---@return TSNode?
function M.get_valid_node()
	local node = vim.treesitter.get_node()
	if not node then return end

	if node:type() == "unit" then
		return node:parent()
	end

	if node:type() == "integer_value" or node:type() == "float_value" then
		return node
	end
end

---Get the unit string from a CSS value node
---@param node TSNode
---@return string
function M.get_unit(node)
	local child = node:child(0)
	if not child then return '' end
	return vim.treesitter.get_node_text(child, 0)
end

---Get the numeric value from a CSS value node
---@param node TSNode
---@return string
function M.get_value(node)
	local unit = M.get_unit(node)
	return vim.treesitter.get_node_text(node, 0):match("(%d*%.?%d*)" .. unit)
end

function M.replace_node_text(node, text)
	local rs, cs, re, ce = node:range()
	vim.api.nvim_buf_set_text(0, rs, cs, re, ce, { text })
end

return M
