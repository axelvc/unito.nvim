local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

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

function M.get_format(node)
	return vim.treesitter.get_node_text(node:child(0), 0)
end

function M.get_value(node)
	local format = M.get_format(node)

	return vim.treesitter.get_node_text(node, 0):match("(%d*%.?%d*)" .. format)
end

function M.update_node(node, str)
	local rs, cs, re, ce = node:range()
	vim.api.nvim_buf_set_text(0, rs, cs, re, ce, { str })
end

return M
