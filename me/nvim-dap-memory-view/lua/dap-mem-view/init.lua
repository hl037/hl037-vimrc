
local M = {}

local views = require'dap-mem-view.views'
local core = require'dap-mem-view.core'

for k, v in pairs(views) do
  M[k] = v
end

for k, v in pairs(core) do
  M[k] = v
end

return M
