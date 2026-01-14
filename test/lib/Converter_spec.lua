local Converter = require("unito.lib.Converter")
local C = require("unito.config")

describe("lib.Converter", function()
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
	end)

	after_each(function()
		C.options = original_options
	end)

	describe("new", function()
		it("should create a converter with input/output/handler", function()
			local conv = Converter:new({
				input = "px",
				output = "rem",
				handler = function(val) return val / 16 end,
			})

			assert.are.equal("px", conv.input)
			assert.are.equal("rem", conv.output)
			assert.is_function(conv.handler)
		end)
	end)

	describe("convert", function()
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
		end)

		after_each(function()
			if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
				vim.api.nvim_buf_delete(bufnr, { force = true })
			end
		end)

		it("should convert px to rem", function()
			local ts = require("unito.lib.treesitter")
			local conv = Converter:new({
				input = "px",
				output = "rem",
				handler = function(val) return val / C.options.rem end,
			})

			vim.api.nvim_win_set_cursor(0, { 2, 11 })
			local node = ts.get_valid_node()
			if node then
				local result = conv:convert(node)
				assert.are.equal(6.25, result)
			end
		end)

		it("should respect max_decimals setting", function()
			local ts = require("unito.lib.treesitter")
			C.options.max_decimals = 2

			-- Create buffer with 15px (15/16 = 0.9375)
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
				"body {",
				"    width: 15px;",
				"}",
			})
			vim.treesitter.start(bufnr, "css")

			local conv = Converter:new({
				input = "px",
				output = "rem",
				handler = function(val) return val / C.options.rem end,
			})

			vim.api.nvim_win_set_cursor(0, { 2, 11 })
			local node = ts.get_valid_node()
			if node then
				local result = conv:convert(node)
				assert.are.equal(0.93, result)
			end
		end)
	end)
end)
