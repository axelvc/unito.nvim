local C = require("unito.config")
local ts = require("unito.lib.treesitter")
local sustitution = require("unito.features.sustitution")

local M = {}

M.preview_augroup = vim.api.nvim_create_augroup("UnitoPxRemPreview", { clear = true })
M.ns_id = vim.api.nvim_create_namespace("unito_virtual_text")

---Show preview virtual text for a node
---@param node TSNode
---@param text string
function M.show(node, text)
	local row, _, _, col = node:range()
	local virt_text = string.format(" %s%s", C.options.virtual_text.prefix, text)

	vim.api.nvim_buf_set_extmark(0, M.ns_id, row, col, {
		virt_text = { { virt_text, C.options.virtual_text.hl_group } },
		virt_text_pos = "inline",
		hl_mode = "combine",
	})
end

---Clear all virtual text in a buffer
---@param bufnr number
function M.clear(bufnr)
	vim.api.nvim_buf_clear_namespace(bufnr or 0, M.ns_id, 0, -1)
end

---Start previewing virtual text
function M.start()
	vim.api.nvim_create_autocmd("CursorMoved", {
		group = M.preview_augroup,
		callback = function()
			M.clear(0)

			local node = ts.get_valid_node()
			if not node then return end

			local unit = ts.get_unit(node)
			if not sustitution.is_valid_unit(unit) then return end

			local converter = sustitution.converters[unit]

			local new_val = converter:convert(node)
			if not new_val then return end

			M.show(node, new_val .. converter.output)
		end,
	})
end

---Stop previewing virtual text
function M.stop()
	vim.api.nvim_clear_autocmds({ group = M.preview_augroup })
	M.clear(0)
end

return M
