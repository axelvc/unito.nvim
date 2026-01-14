local C = require("unito.config")
local ts = require("unito.lib.treesitter")

---Truncate a number to a certain number of decimals
---@param n number
---@param decimals number
---@return number
local function truncate(n, decimals)
  if decimals == 0 then
    return math.floor(n + 0.5)
  else
    local power = 10 ^ decimals
    return math.floor(n * power) / power
  end
end

---@class Converter
---@field input string
---@field output string
---@field handler function
local M = {}

---@param data Converter
---@return Converter
function M:new(data)
  local o = {}
  setmetatable(o, M)
  self.__index = self

  o.input = data.input
  o.output = data.output
  o.handler = data.handler

  return o
end

---Convert a node to the output unit
---@param node TSNode
---@return number?
function M:convert(node)
  local old_val = ts.get_value(node)
  local new_val = self.handler(old_val)
  new_val = truncate(new_val, C.options.max_decimals)
  return new_val
end

return M
