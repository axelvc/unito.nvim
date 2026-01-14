local sustitution = require("unito.features.sustitution")
local C = require("unito.config")

describe("features.sustitution", function()
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
			"    height: 10rem;",
			"    margin: 16px;",
			"}",
		}
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
		vim.treesitter.start(bufnr, "css")
		-- Force treesitter to parse
		vim.treesitter.get_parser(bufnr, "css"):parse()
	end)

	after_each(function()
		C.options = original_options
		if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
			vim.api.nvim_buf_delete(bufnr, { force = true })
		end
	end)

	describe("converters", function()
		it("should have px converter", function()
			assert.is_not_nil(sustitution.converters.px)
			assert.are.equal("px", sustitution.converters.px.input)
			assert.are.equal("rem", sustitution.converters.px.output)
		end)

		it("should have rem converter", function()
			assert.is_not_nil(sustitution.converters.rem)
			assert.are.equal("rem", sustitution.converters.rem.input)
			assert.are.equal("px", sustitution.converters.rem.output)
		end)
	end)

	describe("is_valid_unit", function()
		it("should return true for px", function()
			assert.is_true(sustitution.is_valid_unit("px"))
		end)

		it("should return true for rem", function()
			assert.is_true(sustitution.is_valid_unit("rem"))
		end)

		it("should return false for other units", function()
			assert.is_false(sustitution.is_valid_unit("em"))
			assert.is_false(sustitution.is_valid_unit("%"))
			assert.is_false(sustitution.is_valid_unit("vh"))
		end)
	end)

	describe("replace", function()
		it("should convert px to rem in buffer", function()
			-- "    width: 100px;" - cursor on "100" (col 11-13) or "px" (col 14-15)
			vim.api.nvim_win_set_cursor(0, { 2, 11 })
			sustitution.replace()
			local line = vim.api.nvim_buf_get_lines(bufnr, 1, 2, false)[1]
			assert.is_truthy(line:match("6%.25rem"))
		end)

		it("should convert rem to px in buffer", function()
			-- "    height: 10rem;" - cursor on "10" (col 12-13) or "rem" (col 14-16)
			vim.api.nvim_win_set_cursor(0, { 3, 12 })
			sustitution.replace()
			local line = vim.api.nvim_buf_get_lines(bufnr, 2, 3, false)[1]
			assert.is_truthy(line:match("160px"))
		end)

		it("should convert 16px to 1rem", function()
			-- "    margin: 16px;" - cursor on "16" (col 12-13) or "px" (col 14-15)
			vim.api.nvim_win_set_cursor(0, { 4, 12 })
			sustitution.replace()
			local line = vim.api.nvim_buf_get_lines(bufnr, 3, 4, false)[1]
			assert.is_truthy(line:match("1rem"))
		end)
	end)

	describe("with custom rem value", function()
		it("should use custom rem base", function()
			C.options.rem = 10

			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
				"body {",
				"    width: 100px;",
				"}",
			})
			vim.treesitter.get_parser(bufnr, "css"):parse()

			-- "    width: 100px;" - cursor on "100"
			vim.api.nvim_win_set_cursor(0, { 2, 11 })
			sustitution.replace()
			local line = vim.api.nvim_buf_get_lines(bufnr, 1, 2, false)[1]
			assert.is_truthy(line:match("10rem"))
		end)
	end)
end)
