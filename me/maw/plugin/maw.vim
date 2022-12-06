if exists("g:loaded_maw")
  finish
endif
let g:loaded_maw = 1

if !exists("g:maw_mark_prefix")
  let g:maw_mark_prefix = 'M'
endif
if !exists("g:maw_goto_prefix")
  let g:maw_goto_prefix = '``'
endif
if !exists("g:maw_no_map") || !g:maw_no_map
  call maw#RegisterMap(g:maw_mark_prefix, g:maw_goto_prefix)
endif

