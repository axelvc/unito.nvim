local preview = require("unito.features.preview")
local C = require("unito.config")

describe("features.preview", function()
	local bufnr
	local original_options

	before_each(function()
		original_options = vim.deepcopy(C.options)
		C.options = {
			rem = 16,
			max_decimals = 4,
			virtual_text = {
				enabled = true,
				prefix = "-> ",
				hl_group = "Comment",
			},
		}

		bufnr = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_set_current_buf(bufnr)
		vim.bo[bufnr].filetype = "css"

		local lines = {
			"body {",
			"    width: 100px;",
			"}",
		}
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
		vim.treesitter.start(bufnr, "css")
	end)

	after_each(function()
		C.options = original_options
		preview.clear(bufnr)
		preview.stop()

		if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
			vim.api.nvim_buf_delete(bufnr, { force = true })
		end
	end)

	describe("ns_id", function()
		it("should have a valid namespace id", function()
			assert.is_number(preview.ns_id)
			assert.is_true(preview.ns_id > 0)
		end)
	end)

	describe("show", function()
		it("should add virtual text at node position", function()
			local ts = require("unito.lib.treesitter")
			vim.api.nvim_win_set_cursor(0, { 2, 13 })
			local node = ts.get_valid_node()

			if node then
				preview.show(node, "6.25rem")

				local extmarks = vim.api.nvim_buf_get_extmarks(
					bufnr,
					preview.ns_id,
					0,
					-1,
					{ details = true }
				)

				assert.are.equal(1, #extmarks)
			end
		end)

		it("should use configured prefix", function()
			local ts = require("unito.lib.treesitter")
			C.options.virtual_text.prefix = "=> "

			vim.api.nvim_win_set_cursor(0, { 2, 13 })
			local node = ts.get_valid_node()

			if node then
				preview.show(node, "6.25rem")

				local extmarks = vim.api.nvim_buf_get_extmarks(
					bufnr,
					preview.ns_id,
					0,
					-1,
					{ details = true }
				)

				local virt_text = extmarks[1][4].virt_text[1][1]
				assert.is_truthy(virt_text:match("=> 6.25rem"))
			end
		end)
	end)

	describe("clear", function()
		it("should remove all virtual text from buffer", function()
			local ts = require("unito.lib.treesitter")
			vim.api.nvim_win_set_cursor(0, { 2, 13 })
			local node = ts.get_valid_node()

			if node then
				preview.show(node, "test1")
				preview.show(node, "test2")

				local extmarks_before = vim.api.nvim_buf_get_extmarks(
					bufnr,
					preview.ns_id,
					0,
					-1,
					{}
				)
				assert.is_true(#extmarks_before > 0)

				preview.clear(bufnr)

				local extmarks_after = vim.api.nvim_buf_get_extmarks(
					bufnr,
					preview.ns_id,
					0,
					-1,
					{}
				)
				assert.are.equal(0, #extmarks_after)
			end
		end)
	end)

	describe("start/stop", function()
		it("should create autocmd when started", function()
			preview.start()
			local autocmds = vim.api.nvim_get_autocmds({
				group = preview.preview_augroup,
			})
			assert.is_true(#autocmds > 0)
		end)

		it("should remove autocmd when stopped", function()
			preview.start()
			preview.stop()
			local autocmds = vim.api.nvim_get_autocmds({
				group = preview.preview_augroup,
			})
			assert.are.equal(0, #autocmds)
		end)
	end)
end)
