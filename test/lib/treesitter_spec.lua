local ts = require("unito.lib.treesitter")

describe("lib.treesitter", function()
	describe("with CSS buffer", function()
		local bufnr

		before_each(function()
			bufnr = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_set_current_buf(bufnr)
			vim.bo[bufnr].filetype = "css"

			local lines = {
				"body {",
				"    width: 100px;",
				"    height: 10rem;",
				"}",
			}
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
			vim.treesitter.start(bufnr, "css")
			vim.treesitter.get_parser(bufnr, "css"):parse()
		end)

		after_each(function()
			if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
				vim.api.nvim_buf_delete(bufnr, { force = true })
			end
		end)

		describe("get_valid_node", function()
			it("should return nil when cursor is not on a value", function()
				vim.api.nvim_win_set_cursor(0, { 1, 0 })
				local node = ts.get_valid_node()
				assert.is_nil(node)
			end)

			it("should return node when cursor is on px value", function()
				vim.api.nvim_win_set_cursor(0, { 2, 11 })
				local node = ts.get_valid_node()
				assert.is_not_nil(node)
			end)
		end)

		describe("get_unit", function()
			it("should get unit from value node", function()
				vim.api.nvim_win_set_cursor(0, { 2, 13 })
				local node = ts.get_valid_node()
				if node then
					local unit = ts.get_unit(node)
					assert.are.equal("px", unit)
				end
			end)
		end)

		describe("get_value", function()
			it("should get numeric value from node", function()
				vim.api.nvim_win_set_cursor(0, { 2, 13 })
				local node = ts.get_valid_node()
				if node then
					local value = ts.get_value(node)
					assert.are.equal("100", value)
				end
			end)
		end)

		describe("replace_node_text", function()
			it("should update node text in buffer", function()
				vim.api.nvim_win_set_cursor(0, { 2, 13 })
				local node = ts.get_valid_node()
				if node then
					ts.replace_node_text(node, "6.25rem")
					local line = vim.api.nvim_buf_get_lines(bufnr, 1, 2, false)[1]
					assert.is_truthy(line:match("6.25rem"))
				end
			end)
		end)
	end)
end)
