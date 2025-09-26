
local M = {}

M.default_evaluator = {
  make_expression = function(expr)
    return expr
  end,
  parse_response = function(res)
    return tonumber(res.result)
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


