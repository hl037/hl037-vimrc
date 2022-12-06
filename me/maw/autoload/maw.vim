
if exists("b:did_autoload_maw")
    finish
endif
let b:did_autoload_maw = 1

pyx import vim
pyx import maw

function! maw#RegisterMap(prefixMark, prefixGoto)
  pyx maw.registerMap(vim.eval('a:prefixMark'), vim.eval('a:prefixGoto'))
endfunction

function! maw#Mark(name)
  pyx maw.mark(vim.eval('a:name'))
endfunction


function! maw#Goto(name)
  pyx maw.goto(vim.eval('a:name'))
endfunction

