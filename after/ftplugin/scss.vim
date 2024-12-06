
pyx << EOF

import vim
from pathlib import Path

def _me_scss_export_end():
  p = Path(vim.current.buffer.name)
  vim.command(f'let @"="{p.stem}.$"..@o')
EOF

" Auto paste variable to export, and g to next one
function! SmartExport()
  normal Ma^yy/:export%P>>^x"oyt:f:llct;$o`a
  pyx _me_scss_export_end()
  let @/='\v\$'
endfunction

function! PropertyYank()
  normal Ma^l"oyt:`a
  pyx _me_scss_export_end()
endfunction

nmap <silent> <leader>ee :call SmartExport()<cr>
nmap <silent> <leader>ey :call PropertyYank()<cr>

