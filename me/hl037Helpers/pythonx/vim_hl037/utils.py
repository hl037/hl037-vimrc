import vim

def getVisualRange():
  buf = vim.current.buffer
  (lnum1, col1) = buf.mark('<')
  (lnum2, col2) = buf.mark('>')
  lines = vim.eval('getline({}, {})'.format(lnum1, lnum2))
  if len(lines) == 1:
    lines[0] = lines[0][col1:col2 + 1]
  else:
    lines[0] = lines[0][col1:]
    lines[-1] = lines[-1][:col2 + 1]
  return "\n".join(lines)

def insert(txt):
  line, col = vim.current.window.cursor
  vim.current.line = vim.current.line[:col] + txt + vim.current.line[col:]
  
