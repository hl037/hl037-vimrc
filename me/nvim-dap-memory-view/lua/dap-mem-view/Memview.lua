
local periodic_cb = require'dap-mem-view.periodic_cb'.periodic_cb

local M = require'dap-mem-view'

---@class Memview
---@field address_expr string
---@field address number
---@field size number
---@field config table
---@field buf number
local Memview = {}
Memview.__index = Memview

function Memview:new(address_expr, address, size, config)
  local instance = setmetatable({}, self)
  instance.address_expr = address_expr
  instance.address = address
  instance.size = size
  instance.config = config
  return instance
end

function Memview:show()
  vim.api.nvim_command("enew")
  self.buf = vim.api.nvim_get_current_buf()
  vim.bo[self.buf].buftype = "nofile"
  vim.bo[self.buf].bufhidden = "wipe"
  vim.bo[self.buf].swapfile = false
  vim.api.nvim_buf_set_name(self.buf, string.format("Memory @ 0x%X", self.address))
  periodic_cb(self.buf, function() self:refresh() end, 1000)
end

function Memview:refresh()
  M.read_memory(self.address, self.size, function(bytes)
    -- Build hexdump lines
    local lines = M.format_bytes(self.address, self.address_expr, bytes, self.config)
    -- Create scratch buffer
    vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, lines)
  end)
end

return Memview
