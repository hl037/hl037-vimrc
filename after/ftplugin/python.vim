if get(g:, 'config_flavor', 'default') == "bnpp"
  set shiftwidth=4
  set tabstop=4
else
  set shiftwidth=2
  set tabstop=2
endif
set expandtab

vnoremap <leader>cc :normal I#<CR>
vnoremap <leader>cd :normal 0f#x<CR>


" call textobj#user#map('python', {
"       \   'class': {
"       \     'select-a': '<buffer>ac',
"       \     'select-i': '<buffer>ic',
"       \     'move-n': '<buffer>]pc',
"       \     'move-p': '<buffer>[pc',
"       \   },
"       \   'function': {
"       \     'select-a': '<buffer>af',
"       \     'select-i': '<buffer>if',
"       \     'move-n': '<buffer>]pf',
"       \     'move-p': '<buffer>[pf',
"       \   }
"       \ })



