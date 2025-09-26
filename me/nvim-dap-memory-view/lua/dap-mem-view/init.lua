local bit = require("bit")
local dap = require("dap")


local M = {
  evaluators = require'dap-mem-view.evaluators',
}

-- Minimal base64 decoder (pure Lua, returns a raw string of bytes)

-- Pre-computed decode table for Base64 characters
local decode_table = {}

-- Initialize decode table with ASCII codes
for i = 65, 90 do decode_table[i] = i - 65 end          -- A-Z (0-25)
for i = 97, 122 do decode_table[i] = i - 71 end         -- a-z (26-51)  
for i = 48, 57 do decode_table[i] = i + 4 end           -- 0-9 (52-61)
decode_table[43] = 62  -- + character
decode_table[47] = 63  -- / character
decode_table[61] = 0   -- = padding character

-- Module table
local base64 = {}

-- Decodes a Base64 string and returns a table of characters
-- @param data: Base64 encoded string
-- @return: table containing decoded characters
local function base64_decode(data)
  local result = {}
  local len = #data
  local pos = 1
  local result_pos = 1

  while pos <= len do
    local a = decode_table[data:byte(pos)] or 0
    local b = decode_table[data:byte(pos+1)] or 0
    local c = decode_table[data:byte(pos+2)] or 0
    local d = decode_table[data:byte(pos+3)] or 0

    -- Combine 4 6-bit values into 24-bit number
    local n = bit.lshift(a, 18) + bit.lshift(b, 12) + bit.lshift(c, 6) + d

    -- Extract first byte
    result[result_pos] = bit.band(bit.rshift(n, 16), 255)
    result_pos = result_pos + 1

    -- Extract second byte if not padding
    if pos + 2 <= len and data:byte(pos+2) ~= 61 then
      result[result_pos] = bit.band(bit.rshift(n, 8), 255)
      result_pos = result_pos + 1
    end

    -- Extract third byte if not padding
    if pos + 3 <= len and data:byte(pos+3) ~= 61 then
      result[result_pos] = bit.band(n, 255)
      result_pos = result_pos + 1
    end

    pos = pos + 4
  end

  return result
end


--- Open a temporary buffer showing a hexdump of target memory
--- @param addr_expr string|number address expression or value
--- @param size_expr string|number size expression or value
--- @param config table { line_len = bytes per line, encoding = "ascii"|"utf8"|... }
function M.show_memory(addr_expr, size_expr, config)
  local session = require("dap").session()
  if session == nil then
    vim.notify("No Dap session active")
    return
  end

  local evaluator = M.get_evaluator(session.config and session.config.type)

  config = vim.tbl_extend("force", {
    line_len = 16,
    encoding = "ascii",
  }, config or {})

  M.evaluate_number({expr=addr_expr, evaluator=evaluator, cb=function(address)
    M.evaluate_number({expr=size_expr, evaluator=evaluator, cb=function(size)
      local buffer = require'dap-mem-view.Memview':new(addr_expr, address, size, config)
      buffer:show()
    end})
  end})
end


function M.read_memory(address, size, cb)
  local session = dap.session()
  if session == nil or session.stopped_thread_id == nil then
    return
  end
  session:request("readMemory", {
    -- memoryReference = string.format("0x%x", addr_expr),
    memoryReference = tostring(address),
    offset = 0,
    count = size,
  }, function(err, resp)
    if err then
      vim.notify("readMemory error: " .. err.message, vim.log.levels.ERROR)
      return
    end
    if not resp.data then
      vim.notify("No memory data returned", vim.log.levels.WARN)
      return
    end

    cb(base64_decode(resp.data))
  end)
end

function M.get_evaluator(type)
  local e = M.evaluators[type]
  if e == nil then
    return M.evaluators.default_evaluator
  end
  return {
    make_expression = e.make_expression or M.evaluators.default_evaluator.make_expression,
    parse_response = e.parse_response or M.evaluators.default_evaluator.parse_response,
  }
end

function M.get_current_session_evaluator()
  local session = require("dap").session()
  return M.get_evaluator(session and session.config and session.config.type)
end

function M.evaluate_number(args)
  local expr = args.expr
  local cb = args.cb
  local evaluator = args.evaluator or M.get_current_session_evaluator()
  if type(expr) == "number" then
    cb(expr)
  else
    local processed_expr = evaluator.make_expression(expr)
    local cmd = nil
    local req = nil
    local te = type(processed_expr)
    if te == 'number' then
      return cb(expr)
    elseif te == 'string' then
      cmd = "evaluate"
      req = {
        expression = processed_expr,
        context = "hover",
      }
    elseif te == 'table' then
      req = processed_expr
      cmd = req.command or 'evaluate'
      req.request = nil
    end

    dap.session():request(cmd, req, function(err, resp)
      if err then
        vim.notify("Evaluate error: " .. err.message, vim.log.levels.ERROR)
        return
      end
      local val = evaluator.parse_response(resp)
      if not val then
        vim.notify("Could not parse evaluate result: " .. vim.inspect(resp), vim.log.levels.ERROR)
        return
      end
      cb(val)
    end)
  end
end

function M.format_bytes(address, addr_expr, raw, config)
  local line_length = config.line_length or 8
  local lines = {}

  -- entête
  table.insert(lines, string.format("Memory at [%s = 0x%06X]", addr_expr, address))

  local n = #raw
  local offset = 0

  while offset < n do
    local addr = address + offset

    -- line chunks
    local chunk = {}
    for i = 1, line_length do
      local b = raw[offset + i]
      if not b then break end
      table.insert(chunk, b)
    end

    -- format hex bytes
    local hex_bytes = {}
    for i = 1, #chunk do
        table.insert(hex_bytes, string.format("%02X", chunk[i]))
    end
    local hex_str = table.concat(hex_bytes, " ")

    -- padding
    local needed_len = line_length * 3 - 1
    if #hex_str < needed_len then
        hex_str = hex_str .. string.rep(" ", needed_len - #hex_str)
    end

    -- ascii text
    local ascii_chars = {}
    for i = 1, #chunk do
      local c = chunk[i]
      if c >= 32 and c <= 126 then
        table.insert(ascii_chars, string.char(c))
      else
        table.insert(ascii_chars, ".")
      end
    end
    local ascii_str = table.concat(ascii_chars)

    local line = string.format(
      "+0x%06X (+%08d)  [0x%06X]  |  %s  |  %s",
      offset, offset, addr,
      hex_str,
      ascii_str
    )

    table.insert(lines, line)

    offset = offset + line_length
  end
  return lines
end


return M
