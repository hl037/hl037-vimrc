-- DAP RPC Server for Neovim
-- Exposes DAP functionality via RPC to external Rust client

local M = {}

-- Check if DAP is available
local function check_dap()
  local ok, dap = pcall(require, 'dap')
  if not ok then
    error('nvim-dap is not installed')
  end
  return dap
end

-- Check if session is active
local function check_session(dap)
  local session = dap.session()
  if not session then
    error('No active DAP session')
  end
  return session
end

-- Get list of objectfiles from current debug session
function M.get_objectfiles()
  local dap = check_dap()
  local session = check_session(dap)
  
  -- Method 1: Try modules request
  local ok, result = pcall(function()
    return session:request('modules', {})
  end)
  
  if ok and result and type(result) == 'table' then
    vim.notify('modules result: ' .. vim.inspect(result), vim.log.levels.DEBUG)
    if result.modules then
      local files = {}
      for _, module in ipairs(result.modules) do
        if module.path then
          table.insert(files, module.path)
        elseif module.name then
          table.insert(files, module.name)
        end
      end
      if #files > 0 then
        return files
      end
    end
  else
    vim.notify('modules request failed: ' .. tostring(result), vim.log.levels.DEBUG)
  end
  
  -- Method 2: Try evaluate with GDB command
  ok, result = pcall(function()
    return session:request('evaluate', {
      expression = 'info files',
      context = 'repl'
    })
  end)
  
  if ok and result and type(result) == 'table' and result.result then
    vim.notify('info files result: ' .. result.result, vim.log.levels.DEBUG)
    -- Parse output to extract file paths
    local files = {}
    for line in result.result:gmatch('[^\r\n]+') do
      -- Look for file paths (lines containing .so, .elf, or executable paths)
      local path = line:match('`([^`]+)`') or line:match('"([^"]+)"')
      if path and (path:match('%.so') or path:match('%.elf') or path:match('/')) then
        table.insert(files, path)
      end
    end
    if #files > 0 then
      return files
    end
  else
    vim.notify('info files failed: ' .. tostring(result), vim.log.levels.DEBUG)
  end
  
  -- Method 3: Try loadedSources request
  ok, result = pcall(function()
    return session:request('loadedSources', {})
  end)
  
  if ok and result and type(result) == 'table' and result.sources then
    vim.notify('loadedSources result: ' .. vim.inspect(result), vim.log.levels.DEBUG)
    local files = {}
    for _, source in ipairs(result.sources) do
      if source.path then
        table.insert(files, source.path)
      end
    end
    if #files > 0 then
      return files
    end
  else
    vim.notify('loadedSources failed: ' .. tostring(result), vim.log.levels.DEBUG)
  end
  
  vim.notify('get_objectfiles: no method succeeded', vim.log.levels.WARN)
  return {}
end

-- Set breakpoint at given address
function M.set_breakpoint(addr)
  local dap = check_dap()
  local session = check_session(dap)
  
  -- Check if running, pause if needed
  local status = session.stopped_thread_id
  local was_running = (status == nil)
  
  if was_running then
    -- Pause execution before setting breakpoint
    local ok_pause = pcall(function()
      session:request('pause', { threadId = 0 })
    end)
    
    if not ok_pause then
      -- If pause fails, try anyway
    end
    
    -- Small delay to let pause take effect
    vim.wait(100)
  end
  
  -- Set instruction breakpoint directly via DAP
  local ok, result = pcall(function()
    return session:request('setInstructionBreakpoints', {
      breakpoints = {
        { instructionReference = string.format('0x%x', addr) }
      }
    })
  end)
  
  if not ok then
    error('Failed to set breakpoint: ' .. tostring(result))
  end
  
  if result and type(result) == 'table' and result.breakpoints and result.breakpoints[1] then
    return result.breakpoints[1].id or addr
  end
  
  return addr
end

-- Resume execution
function M.resume()
  local dap = check_dap()
  local session = dap.session()
  
  if not session then
    return true
  end
  
  local ok, err = pcall(function()
    dap.continue()
  end)
  
  if not ok then
    error('Failed to resume: ' .. tostring(err))
  end
  
  return true
end

-- Read memory from target
function M.read_memory(addr, len)
  local dap = check_dap()
  local session = check_session(dap)
  
  local ok, result = pcall(function()
    return session:request('readMemory', {
      memoryReference = string.format('0x%x', addr),
      count = len
    })
  end)
  
  if not ok then
    error('Failed to read memory: ' .. tostring(result))
  end
  
  if not result or type(result) ~= 'table' or not result.data then
    error('No data returned from readMemory')
  end
  
  -- Decode base64 and convert to byte array
  local decoded = vim.base64.decode(result.data)
  local bytes = {}
  for i = 1, #decoded do
    table.insert(bytes, string.byte(decoded, i))
  end
  
  return bytes
end

-- Format value using debugger's type system
function M.try_format_value(bytes, ty_name, temp_addr)
  local ok_dap, dap = pcall(require, 'dap')
  if not ok_dap then
    return nil
  end
  
  local session = dap.session()
  if not session then
    return nil
  end
  
  -- Write bytes to memory at temp_addr if provided
  if temp_addr then
    local base64_data = vim.base64.encode(string.char(table.unpack(bytes)))
    local ok_write, write_result = pcall(function()
      return session:request('writeMemory', {
        memoryReference = string.format('0x%x', temp_addr),
        data = base64_data
      })
    end)
    
    if not ok_write or not write_result or type(write_result) ~= 'table' then
      return nil
    end
  end
  
  -- Try to evaluate/cast the memory as the given type
  local addr_to_use = temp_addr or 0
  local expr = string.format('*((%s*)0x%x)', ty_name, addr_to_use)
  
  local ok_eval, result = pcall(function()
    return session:request('evaluate', {
      expression = expr,
      context = 'watch',
      frameId = session.current_frame and session.current_frame.id
    })
  end)
  
  if ok_eval and result and type(result) == 'table' and result.result then
    return result.result
  end
  
  return nil
end

-- Alternative format using GDB expressions
function M.try_format_value_gdb(bytes, ty_name)
  local ok_dap, dap = pcall(require, 'dap')
  if not ok_dap then
    return nil
  end
  
  local session = dap.session()
  if not session then
    return nil
  end
  
  -- Create hex bytes array for GDB
  local hex_bytes = {}
  for _, byte in ipairs(bytes) do
    table.insert(hex_bytes, string.format('0x%02x', byte))
  end
  
  -- Try GDB aggregate initialization
  local expr = string.format('(%s){%s}', ty_name, table.concat(hex_bytes, ', '))
  
  local ok_eval, result = pcall(function()
    return session:request('evaluate', {
      expression = expr,
      context = 'watch'
    })
  end)
  
  if ok_eval and result and type(result) == 'table' and result.result then
    return result.result
  end
  
  return nil
end

-- Setup function to call from init.lua
function M.setup()
  _G.dap_rpc = M
  vim.notify('DAP RPC Server initialized', vim.log.levels.INFO)
end

return M
