
function switchcase#switchcase(type='', word_case='camel')
  pyx from vim_hl037.utils import switchCase
  pyx switchCase(vim.eval('a:type'), vim.eval('a:word_case'))
endfunction

