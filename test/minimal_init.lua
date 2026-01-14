-- Minimal init for running tests
-- Usage: nvim --headless -u test/minimal_init.lua -c "PlenaryBustedDirectory test/ {minimal_init = 'test/minimal_init.lua'}"

local plenary_path = vim.fn.stdpath("data") .. "/lazy/plenary.nvim"
local treesitter_path = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter"

-- Try lazy.nvim paths first, then packer
if vim.fn.isdirectory(plenary_path) == 0 then
	plenary_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/plenary.nvim"
end
if vim.fn.isdirectory(treesitter_path) == 0 then
	treesitter_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/nvim-treesitter"
end

vim.opt.rtp:append(".")
vim.opt.rtp:append(plenary_path)
vim.opt.rtp:append(treesitter_path)

vim.cmd("runtime plugin/plenary.vim")

-- Ensure CSS parser is available for treesitter tests
vim.treesitter.language.add("css")
