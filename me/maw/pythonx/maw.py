import vim

repo = {}

def mark(name):
  assert len(name) == 1
  repo[name] = {
    'tab' : vim.current.tabpage,
    'win' : vim.current.window,
    'buf' : vim.current.buffer,
  }
  vim.command(f'norm m{name}')

def goto(name):
  assert len(name) == 1
  pos = repo.get(name)
  if pos is None :
    return
  win = pos['win']
  tab = pos['tab']
  buf = pos['buf']
  if not win.valid or not tab.valid or (name.islower() and not buf.valid):
    del repo[name]
    return
  vim.current.tabpage = tab
  vim.current.window = win
  if name.islower() :
    vim.current.buffer = buf
  vim.command(f'norm `{name}')

def registerMap(prefixMark, prefixGoto):
  for r in (chr(n) for l in (range(ord('a'), ord('z')+1), range(ord('A'), ord('Z')+1)) for n in l) :
    vim.command(f'nmap <silent> {prefixMark}{r} :call maw#Mark("{r}")<cr>')
    vim.command(f'nmap <silent> {prefixGoto}{r} :call maw#Goto("{r}")<cr>')
    

