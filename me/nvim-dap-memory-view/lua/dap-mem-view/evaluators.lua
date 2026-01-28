
local M = {}

M.default_evaluator = {
  make_expression = function(expr)
    return expr
  end,
  parse_response = function(res)
    local success, result = pcall(function()
      return tonumber(res.result)
    end)
    if not success then
      return nil
    end
    return result
  end,
}

M.gdb = {
  make_expression = function(expr)
    return {
      context = 'repl',
      expression = 'printf "0x%x", ' .. expr,
    }
  end,
}


return M


