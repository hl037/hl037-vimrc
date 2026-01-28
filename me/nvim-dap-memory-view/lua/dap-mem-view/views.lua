
local periodic_cb = require'dap-mem-view.periodic_cb'.periodic_cb

local M = require'dap-mem-view.core'



---@class LiveView
---@field buf number
local LiveView = {}
LiveView.__index = LiveView

function LiveView:new()
  local instance = setmetatable({}, self)
  return instance
end

---@param buf number|nil
function LiveView:show(buf)
  if buf == nil then
    vim.api.nvim_command("enew")
    self.buf = vim.api.nvim_get_current_buf()
  else
    self.buf = buf
  end
  vim.bo[self.buf].buftype = "nofile"
  vim.bo[self.buf].bufhidden = "wipe"
  vim.bo[self.buf].swapfile = false
  vim.api.nvim_buf_set_name(self.buf, self:name())
  periodic_cb(self.buf, function() self:refresh() end, 3000)
end

---@abstract
function LiveView:name()
  error("name not implemented")
end

---@abstract
function LiveView:refresh()
  error("name not implemented")
end

---@param lines string[]
function LiveView:set_lines(lines)
  vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, lines)
end




---@class MemView: LiveView
---@field address_expr string
---@field address number
---@field size number
---@field config table
local MemView = setmetatable({}, { __index = LiveView })
MemView.__index = MemView

function MemView:new(address_expr, address, size, config)
   ---@class Memview
  local instance = LiveView.new(self)
  instance.address_expr = address_expr
  instance.address = address
  instance.size = size
  instance.config = config
  return instance
end

function MemView:name()
  return string.format("Memory @ 0x%X", self.address)
end

function MemView:refresh()
  M.read_memory(self.address, self.size, function(bytes)
    -- Build hexdump lines
    local lines = M.format_bytes(self.address, self.address_expr, bytes, self.config)
    -- Create scratch buffer
    self:set_lines(lines)
  end)
end




---@class RegisterView: LiveView
---@field view_name string
---@field header string[]
---@field value_header string[]
---@field fields {name: string, size: number}[] | false
---@field values (string|false)[]
---@field empty_line string
---@field size number
local RegisterView = setmetatable({}, { __index = LiveView })
RegisterView.__index = RegisterView

---@param fields {name: string, size: number}[] | false
---@param values string[] | false
---@param name string | false
function RegisterView:new(fields, values, name)
   ---@class RegisterView
  local instance = LiveView.new(self)
  instance.fields = fields
  instance.values = values or {}
  instance:make_header()
  if name == nil then
    name = "Register view"
  end
  instance.view_name = name
  return instance
end

---@param name string
---@param size number
function RegisterView.field(name, size)
  return {
    name = name,
    size = size,
  }
end

function RegisterView:make_header()
  -- Calculate value max length
  local value_max_len = 0
  for _, value in ipairs(self.values) do
    if value ~= false then
      value_max_len = math.max(value_max_len, #value)
    end
  end

  header_indent = string.rep(" ", value_max_len + 1)


  -- Calculate total size
  self.size = 0
  for _, field in ipairs(self.fields) do
    if field then
      self.size = self.size + field.size
    end
  end
  
  -- Find max name length for header height
  local max_len = 0
  for _, field in ipairs(self.fields) do
    if field then
      max_len = math.max(max_len, #field.name)
    end
  end
  
  -- Build header lines
  self.header = {}
  for row = 1, max_len do
    local line = ""
    
    for i, field in ipairs(self.fields) do
      if field == false then
        line = line .. "| "
      else
        -- Extract characters for this row
        local offset = max_len - #field.name
        if row <= offset then
          line = line .. string.rep(" ", field.size + 1)
        else
          line = line .. field.name:sub(row - offset, row - offset)
          if field.size > 1 then
            line = line .. string.rep(".", field.size - 1)
          end
          line = line .. " "
        end
      end
    end
    
    table.insert(self.header, header_indent .. line)
  end

  -- construct separator line
  self.empty_line = string.rep(" ",value_max_len + 1 + #self.header[1])

  -- construct value headers
  self.value_header = {}
  for _, value in ipairs(self.values) do
    if value == false then
      table.insert(self.value_header, false)
    else
      table.insert(self.value_header, string.rep(" ", value_max_len - #value) .. value .. " ")
    end
  end
end

function RegisterView:format_value(value)
  if value == nil then
    return ""
  end
  local result = ""
  local bit_pos = self.size - 1
  local is_first = true
  
  for _, field in ipairs(self.fields) do
    if field == false then
      result = result .. "  "
    else
      if not is_first then
        result = result .. " "
      end
      
      -- Extract bits for this field
      for i = 1, field.size do
        local bit = bit.band(bit.rshift(value, bit_pos), 1)
        result = result .. tostring(bit)
        bit_pos = bit_pos - 1
      end
      
      is_first = false
    end
  end
  
  return result
end

function RegisterView:refresh()
  local session = require("dap").session()
  if session == nil then
    print("NULL SESSION...")
    return
  end
  --flush
  session.capabilities = vim.deepcopy(session.capabilities)
  local frame = session.current_frame
  if not frame then
    print("NULL frame")
    return
  end
  
  local evaluated = {}
  local current_value = 1
  local _self = self
  local evaluator = M.get_evaluator(session.config and session.config.type)
  
  
  local function after()
  
    lines = {}
    for _, h  in ipairs(self.header) do
      table.insert(lines, h)
    end
    for i, v in ipairs(evaluated) do
      if v ~= false then
        if self.value_header[i] == nil then
          vim.notify("TTT VAL HEADER nil: i="..i.." header:"..vim.inspect(self.value.header), vim.log.levels.ERROR)
        end
        table.insert(lines, self.value_header[i] .. self:format_value(v))
      else
        if self.value_header[i] ~= false then 
          table.insert(lines, self.value_header[i])
        else
          table.insert(lines, self.empty_line)
        end
      end
    end
    self:set_lines(lines)
  end
  
  
  local function continue_evaluate_value(res)
    if res == nil then
      res = false
    end
    table.insert(evaluated, res)
    current_value = current_value + 1
    if current_value > #_self.values then
      after()
      return
    end
    while _self.values[current_value] == false do
      table.insert(evaluated, false)
      current_value = current_value + 1
      if current_value > #_self.values then
        after()
        return
      end
    end
    
    M.evaluate_number({expr=_self.values[current_value], evaluator=evaluator, cb=continue_evaluate_value, frameId=frame.id})
  end
  
  if #_self.values == 0 then
    after()
    return
  end
  
  while _self.values[current_value] == false do
    table.insert(evaluated, false)
    current_value = current_value + 1
    if current_value > #_self.values then
      after()
      return
    end
  end

  
  M.evaluate_number({expr=_self.values[current_value], evaluator=evaluator, cb=continue_evaluate_value, frameId=frame.id})
end

function RegisterView:name()
  return self.view_name
end


return {LiveView=LiveView, MemView=MemView, RegisterView=RegisterView}

